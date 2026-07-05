#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：自编译 nginx 1.30.x + OpenSSL 3.2+（带 QUIC 支持），
# 写 2 个 server block：
#   :80   HTTP        Hugo 静态站（直接访问 + hy2 masq 目标；带 Alt-Svc 引导 h3）
#   :443  HTTPS (TCP) + HTTP/3 (UDP)  nestseeker.xyz 真实 https + h3 双栈（同 listen 端口）
# 端口分配原因：
#   - 443 TCP/UDP 整组给 nginx：TCP = https，UDP = h3，跟主流部署一致（Cloudflare/Caddy/LiteSpeed）
#   - 443 UDP 不再归 sing-box HY2（HY2 改 8443 UDP 错开），Alt-Svc 用无端口写法 h3=":443"
#   - cert 路径对齐 acme.sh --install-cert 默认输出，跑通后真实 cert 直接覆盖
# 配置全部走 /etc/nginx/conf.d/，不污染主配置。
#
# 为什么自编译：
#   Debian 11 (bullseye) 系统 OpenSSL 1.1.1 没 QUIC API；
#   nginx.org 官方 mainline 包编自 OpenSSL 1.1.1，configure 阶段自动跳过
#   http_v3_module（参数保留在 nginx -V 输出里，但模块代码没编入二进制），
#   "http3 on;" 指令被静默忽略，UDP :443 永远不起。
#   必须自编译 nginx + OpenSSL 3.2+（quictls fork 已合并到 OpenSSL 主线 3.2+）。
#   Debian 12+ 系统 OpenSSL 3.0/3.5 可走 apt 装 nginx-extras，到时改 SKIP_NGINX_INSTALL=1 即可。
#
# 幂等：可重复执行；
#   - 检测到 /usr/sbin/nginx 二进制里有 ngx_quic_ssl 符号 → 跳过整段（真 QUIC）
#   - 检测到 apt 装的 nginx 1.30.3-1~bullseye 假包（configure 有 with-http_v3_module
#     但二进制里没 ngx_quic_ssl，OpenSSL 1.1.1 编的）→ 打 [warn] 提示并自编译
#   - OpenSSL 源码已就位跳过 git clone
#   - 旧 apt 源 nginx 自动 purge（不动 /etc/sing-box/certs/、/etc/nginx/conf.d/、/var/www/）
#
# 用法（本地）：sudo ./setup-nginx-site.sh
# 用法（远程，GitHub raw CDN 有缓存，加 cb=$RANDOM 必 bust）：
#   wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-nginx-site.sh?cb=$RANDOM" | sudo bash
#
# 可选环境变量：
#   MASQ_PORT=80                                 # :80 HTTP 端口
#   MASQ_DOC_ROOT=/var/www/nestseeker.xyz        # Hugo 站点根
#   SITE_CERT_FULLCHAIN=/etc/sing-box/certs/nestseeker.xyz.fullchain.pem
#   SITE_CERT_KEY=/etc/sing-box/certs/nestseeker.xyz.key.pem
#   NGINX_VERSION=1.30.3                         # 编译用的 nginx 版本（升级时改这里）
#   OPENSSL_VERSION=3.2.1                        # 编译用的 OpenSSL 版本
#   OPENSSL_SRC=/opt/openssl-src                 # OpenSSL 源码位置
#   SKIP_NGINX_INSTALL=1                         # 跳过 nginx 安装/编译（已自编译好时用）

set -euo pipefail

# === 默认值 ===
MASQ_PORT="${MASQ_PORT:-80}"
MASQ_DOC_ROOT="${MASQ_DOC_ROOT:-/var/www/nestseeker.xyz}"
# :443 TCP/UDP 共用同一张 cert（acme.sh 申请 nestseeker.xyz 的产物）
# 路径对齐 acme.sh --install-cert 的 --fullchain-file / --key-file 默认输出位置
SITE_CERT_FULLCHAIN="${SITE_CERT_FULLCHAIN:-/etc/sing-box/certs/nestseeker.xyz.fullchain.pem}"
SITE_CERT_KEY="${SITE_CERT_KEY:-/etc/sing-box/certs/nestseeker.xyz.key.pem}"
NGINX_VERSION="${NGINX_VERSION:-1.30.3}"
OPENSSL_VERSION="${OPENSSL_VERSION:-3.2.1}"
OPENSSL_SRC="${OPENSSL_SRC:-/opt/openssl-src}"
SKIP_NGINX_INSTALL="${SKIP_NGINX_INSTALL:-0}"

NGINX_CONF_DIR="/etc/nginx/conf.d"
MASQ_CONF="$NGINX_CONF_DIR/masq-site-${MASQ_PORT}.conf"

# --- 前置检查 ---
if [[ $EUID -ne 0 ]]; then
  echo "[error] 请用 root 或 sudo 执行此脚本" >&2
  exit 1
fi

# === 1. 自编译 nginx + OpenSSL 3.2+（带 QUIC 支持）===
# 检测：二进制里有 ngx_quic_ssl 符号 → 跳过（真 QUIC）
# 流程：装编译依赖 → 拉 OpenSSL 源码 → 卸旧 apt nginx → 编译 nginx（自动 build OpenSSL）
#       → 写 mime.types + nginx.conf + 创建 nginx user → 写 systemd service
install_nginx() {
  # 1) 已有 nginx 且二进制里有 ngx_quic_ssl 符号 → 跳过（真 QUIC）
  # 不能用 "with-http_v3_module" 判断：apt 装的 nginx 1.30.3-1~bullseye
  #   configure 参数里有这个标志但实际没编（OpenSSL 1.1.1 没 QUIC API，模块被跳过），
  #   二进制里根本没有 ngx_quic_ssl 符号。"ngx_quic_ssl" 是 nginx quic 模块的 C 符号，
  #   OpenSSL 1.1.1 编的 nginx 永远不会出现这个符号——这是金标准。
  if command -v nginx >/dev/null 2>&1 && strings /usr/sbin/nginx 2>/dev/null | grep -q "ngx_quic_ssl"; then
    local v
    v=$(nginx -v 2>&1 | awk -F/ '{print $2}')
    echo "[ok] nginx $v 已编入 QUIC 模块（ngx_quic_ssl 符号在），跳过编译"
    return
  fi
  if command -v nginx >/dev/null 2>&1 && nginx -V 2>&1 | grep -q "with-http_v3_module"; then
    echo "[warn] 检测到 nginx 1.30.3-1~bullseye（nginx.org 源，OpenSSL 1.1.1 编出假 QUIC），将卸载并自编译"
  fi

  echo "[info] 准备编译环境（依赖 + OpenSSL $OPENSSL_VERSION + nginx $NGINX_VERSION）..."

  # 2) 装编译依赖
  # - git：拉 OpenSSL 3.2+ 源码（hg.nginx.org 2024 年已废弃）
  # - perl + perl-modules-5.32：OpenSSL configure 阶段必用
  apt-get update -y >/dev/null
  apt-get install -y --no-install-recommends \
    build-essential wget curl ca-certificates git \
    libpcre3-dev zlib1g-dev libssl-dev \
    libxml2-dev libxslt1-dev libgd-dev libgeoip-dev \
    perl perl-modules-5.32 \
    >/dev/null

  # 3) 拉 OpenSSL 3.2+ 源码（quictls fork 已合并到 OpenSSL 主线 3.2+）
  # -c advice.detachedHead=false：关掉 git 对 --depth 1 切到 tag 的 detached HEAD 警告
  # 强制 rm -rf .openssl 残留：OpenSSL 3.x 构建中间目录；上次失败构建留的旧 Makefile/configdata.pm
  #   会让本次 build 继续用残留选项（含 enable-tls1.3），必须清。
  if [[ ! -d "$OPENSSL_SRC" ]]; then
    echo "[info] 拉取 OpenSSL $OPENSSL_VERSION 源码..."
    git -c advice.detachedHead=false clone --depth 1 --branch "openssl-$OPENSSL_VERSION" \
      https://github.com/openssl/openssl.git "$OPENSSL_SRC" >/dev/null
    echo "[ok] OpenSSL 源码已就位: $OPENSSL_SRC"
  else
    echo "[ok] OpenSSL 源码已存在: $OPENSSL_SRC"
  fi
  rm -rf "$OPENSSL_SRC/.openssl" "$OPENSSL_SRC/Makefile" "$OPENSSL_SRC/configdata.pm"

  # 4) 卸载旧 apt 装的 nginx（不带 QUIC；保留 /etc/sing-box/certs/、/etc/nginx/conf.d/ 不动）
  if dpkg -l nginx 2>/dev/null | grep -q '^ii'; then
    echo "[info] 卸载旧 apt 装的 nginx（不带 QUIC）..."
    systemctl stop nginx 2>/dev/null || true
    apt-get purge -y nginx nginx-common >/dev/null
    rm -f /etc/apt/sources.list.d/nginx.list /etc/apt/preferences.d/99nginx
    apt-get update -y >/dev/null
  fi

  # 5) 编译 nginx $NGINX_VERSION（让 nginx 编译时自动 build OpenSSL 3.2+）
  # --with-openssl= 让 nginx 自己 build OpenSSL，比单独 build 少一步、链接更稳
  # 不传 --with-openssl-opt：nginx 1.30.3 的 auto/lib/openssl/make 已硬编码
  #   ./config --prefix=... no-shared no-threads $OPENSSL_OPT
  # OPENSSL_OPT 是追加在最后，传 no-shared 跟硬编码重复；
  # 传 -DOPENSSL_NO_HEARTBEATS / enable-tls1.3 在 OpenSSL 3.x 都是无效选项，
  # 会让 build 直接报 "Unsupported options" 挂掉。留空让 nginx 用默认 no-shared no-threads。
  echo "[info] 编译 nginx $NGINX_VERSION + OpenSSL $OPENSSL_VERSION（首次约 5-10min）..."
  rm -rf "/tmp/nginx-$NGINX_VERSION"
  (cd /tmp && \
    wget -q "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" && \
    tar xzf "nginx-$NGINX_VERSION.tar.gz" && \
    cd "nginx-$NGINX_VERSION" && \
    ./configure \
      --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/var/log/nginx/error.log \
      --http-log-path=/var/log/nginx/access.log \
      --pid-path=/var/run/nginx.pid \
      --lock-path=/var/run/nginx.lock \
      --with-http_v3_module \
      --with-openssl="$OPENSSL_SRC" \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-http_stub_status_module \
      --with-http_realip_module \
      >/dev/null && \
    make -j"$(nproc)" >/dev/null && \
    make install >/dev/null)

  echo "[ok] nginx $NGINX_VERSION 已编译: $(nginx -v 2>&1)"

  # 6) 写 /etc/nginx/mime.types（自编译不会装；apt 装的也被 purge 带掉）
  #    不写的话 http 块里 include mime.types 会失败，所有静态文件变 application/octet-stream。
  if [[ ! -f /etc/nginx/mime.types ]]; then
    echo "[info] 下载 /etc/nginx/mime.types..."
    wget -q "https://raw.githubusercontent.com/nginx/nginx/release-$NGINX_VERSION/conf/mime.types" \
      -O /etc/nginx/mime.types
    echo "[ok] 已写入 /etc/nginx/mime.types"
  fi

  # 7) 写 /etc/nginx/nginx.conf（自编译不会装；apt 装的也被 purge 带掉）
  #    用最小可用模板，http 块里 include /etc/nginx/conf.d/*.conf；
  #    不含示例 server 块（避免跟 conf.d 里的 :80/:443 server 冲突）。
  cat > /etc/nginx/nginx.conf <<'NGINX_MAIN_EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    access_log    /var/log/nginx/access.log;
    sendfile      on;
    keepalive_timeout 65;

    include /etc/nginx/conf.d/*.conf;
}
NGINX_MAIN_EOF
  echo "[ok] 已写入 /etc/nginx/nginx.conf"

  # 8) 确保 nginx user 存在（apt purge nginx-common 会带掉，user 启动会失败）
  if ! getent passwd nginx >/dev/null; then
    useradd -r -s /usr/sbin/nologin nginx
    echo "[ok] 已创建 nginx user"
  fi

  # 9) 写 systemd service（apt 卸载会带掉，自己补一份）
  if [[ ! -f /lib/systemd/system/nginx.service ]] && [[ ! -f /etc/systemd/system/nginx.service ]]; then
    cat > /lib/systemd/system/nginx.service <<'EOF'
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    echo "[ok] 已写入 /lib/systemd/system/nginx.service"
  fi
}

if [[ "$SKIP_NGINX_INSTALL" == "1" ]]; then
  echo "[ok] SKIP_NGINX_INSTALL=1，跳过 nginx 安装/编译"
else
  install_nginx
fi

# === 2. 确保 conf.d 布局 ===
# install_nginx() 内部已主动写好 /etc/nginx/nginx.conf（http 块里 include conf.d/*.conf），
# 这里只确保 conf.d 目录存在即可。
mkdir -p "$NGINX_CONF_DIR"

# === 3. 清理废弃/旧端口 conf ===
# 3a. 老脚本的 :8443 Reality fallback（已废弃；h3 切到 :443 UDP 后 8443 整段作废）
shopt -s nullglob
for stale in "$NGINX_CONF_DIR"/masq-fallback-*.conf; do
  rm -f "$stale"
  echo "[ok] 已清理废弃 fallback conf: $stale"
done
# 3b. 旧 MASQ_PORT 的 masq-site-*.conf（端口改了，旧的没用了；当前端口会被 cat > 覆盖）
for stale in "$NGINX_CONF_DIR"/masq-site-*.conf; do
  if [[ "$(basename "$stale")" != "masq-site-${MASQ_PORT}.conf" ]]; then
    rm -f "$stale"
    echo "[ok] 已清理旧 masq conf: $stale"
  fi
done
shopt -u nullglob

# === 3c. 确保 :443 cert 存在（自签兜底）===
# 缺 cert 时用 openssl 自签（CN/SAN=nestseeker.xyz，10 年）
# 跑通后用 acme.sh 申请真实 cert，直接覆盖此路径即可（路径对齐 acme.sh --install-cert 默认输出）
# 幂等：cert 已存在则跳过；不会被覆盖
ensure_site_cert() {
  if [[ -f "$SITE_CERT_FULLCHAIN" && -f "$SITE_CERT_KEY" ]]; then
    echo "[ok] site cert 已存在: $SITE_CERT_FULLCHAIN"
    return
  fi
  echo "[info] site cert 缺失，自签兜底（CN/SAN=nestseeker.xyz，3650 天）"
  mkdir -p "$(dirname "$SITE_CERT_FULLCHAIN")"
  chmod 700 "$(dirname "$SITE_CERT_FULLCHAIN")"
  openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout "$SITE_CERT_KEY" \
    -out "$SITE_CERT_FULLCHAIN" \
    -days 3650 \
    -subj "/CN=nestseeker.xyz" \
    -addext "subjectAltName=DNS:nestseeker.xyz" 2>/dev/null
  # 644 兼容 nginx 进程以非 root 用户读（nginx.org 源默认 User=nginx）
  chmod 644 "$SITE_CERT_FULLCHAIN" "$SITE_CERT_KEY"
  echo "[ok] 已自签 site cert"
  echo "     跑通后用 acme.sh 申请 nestseeker.xyz 真实 cert，直接覆盖："
  echo "       $SITE_CERT_FULLCHAIN"
  echo "       $SITE_CERT_KEY"
}
ensure_site_cert

# === 4. 写 masq conf（默认 :80）===
# 这个端口同时承担两个角色：
#   1) 用户直接 http://nestseeker.xyz/ 访问
#   2) sing-box hy2 masq 失败时的下游目标（探测者转发到这里）
# sing-box 内置 masq proxy 把 QUIC 包解码成 HTTP/1.1 再发到这，
# 所以这里不开 TLS（开了也用不上，masq 走 http:// 协议）
if [[ ! -d "$MASQ_DOC_ROOT" ]]; then
  echo "[warn] $MASQ_DOC_ROOT 不存在，创建"
  mkdir -p "$MASQ_DOC_ROOT"
  if id deploy &>/dev/null; then
    chown -R deploy:deploy "$MASQ_DOC_ROOT"
    echo "[ok] chown deploy:deploy $MASQ_DOC_ROOT"
  fi
fi

cat > "$MASQ_CONF" <<EOF
# 由 setup-nginx-site.sh 生成
# HTTP 直接访问 + hy2 masq 探测者伪装
# 不开 TLS：masq 走 http://，直接访问也是 plain HTTP
server {
    listen ${MASQ_PORT};
    listen [::]:${MASQ_PORT};

    server_name _;

    root ${MASQ_DOC_ROOT};
    index index.html;

    # 引导浏览器后续请求走 h3 (UDP 443，无端口写法 = Chrome 首选)
    # always 确保 4xx/5xx 错误响应也带这头
    add_header Alt-Svc 'h3=":443"; ma=86400' always;

    # 跟生产 Hugo 站行为一致
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
echo "[ok] 写入 $MASQ_CONF"

# === 4b. 写 :443 TCP (HTTPS) + :443 UDP (HTTP/3) 双栈 conf ===
# TCP/UDP 443 整组归 nginx：TCP = https，UDP = h3（主流部署模式，Alt-Svc 头无端口）
# cert：acme.sh 申请的 nestseeker.xyz 真实 cert（默认路径见 env 变量）
HTTPS_CONF="$NGINX_CONF_DIR/site-https-443.conf"
cat > "$HTTPS_CONF" <<EOF
# 由 setup-nginx-site.sh 生成
# nestseeker.xyz 真实 https 站点 (TCP 443) + h3 (UDP 443) 双栈
# 浏览器直接访问 https://nestseeker.xyz/ 命中 TCP 443；同时响应 Alt-Svc 头引导升级到 h3
# 同一端口 TCP+UDP 各走各的 socket，互不干扰
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;                       # nginx 1.25+ 推荐写法（替代 listen ... http2）
    http3 on;                       # 启用 HTTP/3 (nginx 1.25.0+，QUIC 监听同 :443 UDP)

    server_name nestseeker.xyz;

    ssl_certificate     ${SITE_CERT_FULLCHAIN};
    ssl_certificate_key ${SITE_CERT_KEY};

    # 告诉浏览器：h3 在 443 (UDP)（无端口写法 = Chrome 首选，h2 跟 h3 同 listen 端口）
    # always 确保 4xx/5xx 错误响应也带这头，否则出错时浏览器永远不知道 h3 可用
    add_header Alt-Svc 'h3=":443"; ma=86400' always;

    root ${MASQ_DOC_ROOT};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
echo "[ok] 写入 $HTTPS_CONF"

# === 4c. 清理旧独立 h3 conf（h3 已合并进 :443 server block） ===
# 历史版本有独立的 site-h3-8443.conf 走 :8443 UDP；切端口后 :443 TCP+UDP 同 server block
# 留下旧文件会被 nginx include 二次监听 :8443（端口冲突 nginx -t 报错）
shopt -s nullglob
for stale in "$NGINX_CONF_DIR"/site-h3-*.conf; do
  rm -f "$stale"
  echo "[ok] 已清理旧独立 h3 conf: $stale"
done
shopt -u nullglob

# === 5. 验证并 reload ===
echo "[info] 验证 nginx 配置..."
nginx -t

echo "[info] ensure nginx is running..."
# nginx.org 官方 .deb 装完默认不 enable --now，reload 会因 service not active 失败。
# 启动优先级：reload（已运行） > start（未运行） > enable --now（首次安装）。
if systemctl is-active --quiet nginx; then
  systemctl reload nginx
  echo "[ok] nginx reloaded"
else
  systemctl enable --now nginx >/dev/null
  echo "[ok] nginx 已 enable 并 start"
  # 启动后再 reload 一次确保本次新配置生效
  systemctl reload nginx
  echo "[ok] nginx reloaded"
fi

# 探测端口监听
for p in "$MASQ_PORT" "443"; do
  if ss -lntu "sport = :$p" 2>/dev/null | grep -q LISTEN; then
    echo "[ok] :$p 在监听 ($(ss -lntu "sport = :$p" 2>/dev/null | grep LISTEN | awk '{print $1}' | sort -u | tr '\n' ',' | sed 's/,$//'))"
  else
    echo "[warn] :$p 暂未在监听"
  fi
done

cat <<EOF

[完成] nginx 已就位：
  - :${MASQ_PORT}    HTTP              Hugo 静态站（直接访问 + hy2 masq 目标；带 Alt-Svc 引导 h3）
  - :443    TCP+UDP  HTTPS + h3        nestseeker.xyz 真实 https (h2) + h3 (QUIC)，与 cert 共享
  cert: ${SITE_CERT_FULLCHAIN}（当前自签兜底；跑通后用 acme.sh 申请 nestseeker.xyz 真实 cert 直接覆盖此路径）

[本地验证] 跑完后从 VPS 本地：
  curl -I  http://127.0.0.1:${MASQ_PORT}/                            # :MASQ_PORT：Hugo plain HTTP（响应头含 Alt-Svc: h3=":443"）
  curl -kI https://127.0.0.1:443/                                  # :443：HTTPS（响应头含 Alt-Svc: h3=":443"）
  ss -lntu | grep -E ':(${MASQ_PORT}|443)\s'                         # 应看到 :MASQ_PORT tcp, :443 tcp+udp

[下一步] 跑 setup-singbox.sh，让 trojan reality 监听 :2053（错开 443 让 nginx 拿到），
  HY2 在 UDP:8443（错开 443），vless 备用入口在 :1443。
EOF
