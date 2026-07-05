#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：装 nginx 1.27+（nginx.org 源），
# 写 3 个 server block：
#   :80   HTTP        Hugo 静态站（直接访问 + hy2 masq 目标；带 Alt-Svc 引导 h3）
#   :443  HTTPS (TCP) nestseeker.xyz 真实 https 站点（h2/h1.1）+ Alt-Svc 源
#   :443  HTTP/3 (UDP) Alt-Svc 升级后的 h3 目标（QUIC，跟 443 TCP 共享 cert 和 listen）
# 端口分配原因：
#   - 443 TCP/UDP 整组给 nginx：TCP = https，UDP = h3，跟主流部署一致（Cloudflare/Caddy/LiteSpeed）
#   - 443 UDP 不再归 sing-box HY2（HY2 改 8443 UDP 错开），Alt-Svc 用无端口写法 h3=":443"
#   - cert 路径对齐 acme.sh --install-cert 默认输出，跑通后真实 cert 直接覆盖
# 配置全部走 /etc/nginx/conf.d/，不污染主配置。
# 幂等：可重复执行；旧 conf（masq-site-*.conf / masq-fallback-*.conf / site-h3-8443.conf）在每次重跑时自动清理。
#
# 用法：sudo ./setup-nginx-site.sh
# 可选环境变量：
#   MASQ_PORT=80                                 # :80 HTTP 端口
#   MASQ_DOC_ROOT=/var/www/nestseeker.xyz        # Hugo 站点根
#   SITE_CERT_FULLCHAIN=/etc/sing-box/certs/nestseeker.xyz.fullchain.pem
#   SITE_CERT_KEY=/etc/sing-box/certs/nestseeker.xyz.key.pem
#   SKIP_NGINX_INSTALL=1                         # 已装好 nginx 1.27+ 时跳过安装

set -euo pipefail

# === 默认值 ===
MASQ_PORT="${MASQ_PORT:-80}"
MASQ_DOC_ROOT="${MASQ_DOC_ROOT:-/var/www/nestseeker.xyz}"
# :443 TCP/UDP 共用同一张 cert（acme.sh 申请 nestseeker.xyz 的产物）
# 路径对齐 acme.sh --install-cert 的 --fullchain-file / --key-file 默认输出位置
SITE_CERT_FULLCHAIN="${SITE_CERT_FULLCHAIN:-/etc/sing-box/certs/nestseeker.xyz.fullchain.pem}"
SITE_CERT_KEY="${SITE_CERT_KEY:-/etc/sing-box/certs/nestseeker.xyz.key.pem}"
SKIP_NGINX_INSTALL="${SKIP_NGINX_INSTALL:-0}"

NGINX_CONF_DIR="/etc/nginx/conf.d"
MASQ_CONF="$NGINX_CONF_DIR/masq-site-${MASQ_PORT}.conf"

# --- 前置检查 ---
if [[ $EUID -ne 0 ]]; then
  echo "[error] 请用 root 或 sudo 执行此脚本" >&2
  exit 1
fi

# === 1. 装 nginx 1.31.x（nginx.org 源） ===
install_nginx() {
  if command -v nginx >/dev/null 2>&1; then
    local v
    v=$(nginx -v 2>&1 | awk -F/ '{print $2}' | cut -d. -f1,2)
    # 1.27+ 都是 mainline，足够新；这里只检查"不是太旧"
    if awk -v cur="$v" 'BEGIN { split(cur, a, "."); exit !(a[1] >= 1 && a[2] >= 27) }'; then
      echo "[ok] nginx $v.x 已安装，跳过"
      return
    fi
    echo "[warn] 当前 nginx $v.x 版本偏旧，将升级到 mainline"
  fi

  echo "[info] 装 nginx mainline（nginx.org 源）..."

  apt-get update -y >/dev/null
  apt-get install -y --no-install-recommends \
    curl gnupg2 ca-certificates lsb-release openssl >/dev/null

  local CODENAME
  CODENAME=$(lsb_release -cs)

  # 加 nginx.org 源
  curl -fsSL https://nginx.org/keys/nginx_signing.key \
    | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian $CODENAME nginx" \
    > /etc/apt/sources.list.d/nginx.list

  # 锁定 nginx.org 源（防止被 Debian 官方源冲掉）
  cat > /etc/apt/preferences.d/99nginx <<'EOF'
Package: *
Pin: origin nginx.org
Pin-Priority: 900
EOF

  apt-get update -y >/dev/null
  apt-get install -y --no-install-recommends nginx >/dev/null

  echo "[ok] 已安装 $(nginx -v 2>&1)"
}

if [[ "$SKIP_NGINX_INSTALL" == "1" ]]; then
  echo "[ok] SKIP_NGINX_INSTALL=1，跳过 nginx 安装"
else
  install_nginx
fi

# === 2. 确保 conf.d 布局 ===
NGINX_MAIN="/etc/nginx/nginx.conf"
mkdir -p "$NGINX_CONF_DIR"

# 官方包默认就有 include /etc/nginx/conf.d/*.conf，不动它
if ! grep -qE 'include\s+/etc/nginx/conf.d/\*\.conf\s*;' "$NGINX_MAIN"; then
  echo "[warn] nginx.conf 缺 conf.d include，手动补"
  # 在第一个 "}" 之前（http 块结束）插入
  sed -i '0,/^}/{s|^}\s*$|    include /etc/nginx/conf.d/*.conf;\n}\n|}' "$NGINX_MAIN"
fi

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
