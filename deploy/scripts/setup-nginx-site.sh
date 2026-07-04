#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：装 nginx 1.27+（nginx.org 源），
# 写 3 个 server block：
#   :80    HTTP            Hugo 静态站（直接访问 + hy2 masq 目标）
#   :8443  HTTPS (TCP)     sing-box vless reality fallback 目标 + Alt-Svc 源
#   :8443  HTTP/3 (UDP)    浏览器 Alt-Svc 升级后的 h3 目标
# 8443 TCP/UDP 共存：协议不同，socket 独立，互不干扰。
# 配置全部走 /etc/nginx/conf.d/，不污染主配置。
# 幂等：可重复执行；旧端口的 masq-site-*.conf 与废弃的 masq-fallback-*.conf
# 在每次重跑时自动清理。
#
# 用法：sudo ./setup-nginx-site.sh
# 可选环境变量：
#   MASQ_PORT=80
#   MASQ_DOC_ROOT=/var/www/nestseeker.xyz
#   SKIP_NGINX_INSTALL=1          # 已装好 nginx 1.27+ 时跳过安装

set -euo pipefail

# === 默认值 ===
MASQ_PORT="${MASQ_PORT:-80}"
MASQ_DOC_ROOT="${MASQ_DOC_ROOT:-/var/www/nestseeker.xyz}"
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
# 3a. 老脚本的 :8443 Reality fallback（已废弃）
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

    # 跟生产 Hugo 站行为一致
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
echo "[ok] 写入 $MASQ_CONF"

# === 4b. 写 :8443 TCP (HTTPS) + UDP (HTTP/3) 双栈 conf ===
# TCP 8443：sing-box vless reality 的 fallback 目标 (ALPN h2/h1.1 → 127.0.0.1:8443)
#           同时作为 Alt-Svc 源，告诉浏览器 h3 也在 8443 (UDP)
# UDP 8443：HTTP/3 over QUIC；浏览器拿到 Alt-Svc 后升级到此
# TCP/UDP 共用 8443：协议不同，socket 独立，互不抢
# cert 复用 setup-singbox.sh 生成的 hy2 自签 cert（CN=nestseeker.xyz）
HTTPS_CONF="$NGINX_CONF_DIR/site-https-8443.conf"
cat > "$HTTPS_CONF" <<EOF
# 由 setup-nginx-site.sh 生成
# sing-box vless reality fallback 目标 (TCP 8443)
# 浏览器走 https://nestseeker.xyz/ 时，vless fallback_for_alpn 把
# h2/http/1.1 请求转到这里；同时响应 Alt-Svc 头引导浏览器升级到 h3
server {
    listen 8443 ssl;
    listen [::]:8443 ssl;
    http2 on;                       # nginx 1.25+ 推荐写法（替代 listen ... http2）

    server_name nestseeker.xyz;

    ssl_certificate     /etc/sing-box/certs/hy2.pem;
    ssl_certificate_key /etc/sing-box/certs/hy2.key;

    # 告诉浏览器：h3 也在 8443 (UDP)
    # always 确保 4xx/5xx 错误响应也带这头，否则出错时浏览器永远不知道 h3 可用
    add_header Alt-Svc 'h3=":8443"; ma=86400' always;

    root ${MASQ_DOC_ROOT};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
echo "[ok] 写入 $HTTPS_CONF"

H3_CONF="$NGINX_CONF_DIR/site-h3-8443.conf"
cat > "$H3_CONF" <<EOF
# 由 setup-nginx-site.sh 生成
# HTTP/3 over QUIC (UDP 8443)
# 浏览器从 TCP 8443 的 Alt-Svc 头学到这里
# 与 TCP 8443 (site-https-8443.conf) 共享 cert，但 listen 协议不同
server {
    listen 8443 quic;               # QUIC = UDP 上的 h3 传输
    http3 on;                       # 启用 HTTP/3 (nginx 1.25.0+)

    server_name nestseeker.xyz;

    # QUIC 握手也要 cert（h3 客户端会验证）
    ssl_certificate     /etc/sing-box/certs/hy2.pem;
    ssl_certificate_key /etc/sing-box/certs/hy2.key;

    root ${MASQ_DOC_ROOT};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
echo "[ok] 写入 $H3_CONF"

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
for p in "$MASQ_PORT" "8443"; do
  if ss -lntu "sport = :$p" 2>/dev/null | grep -q LISTEN; then
    echo "[ok] :$p 在监听 ($(ss -lntu "sport = :$p" 2>/dev/null | grep LISTEN | awk '{print $1}' | sort -u | tr '\n' ',' | sed 's/,$//'))"
  else
    echo "[warn] :$p 暂未在监听"
  fi
done

cat <<EOF

[完成] nginx 已就位：
  - :${MASQ_PORT}   HTTP              Hugo 静态站（直接访问 + hy2 masq 目标）
  - :8443 TCP       HTTPS (h2)        vless reality fallback 目标 + Alt-Svc 源
  - :8443 UDP       HTTP/3 (QUIC)     浏览器 Alt-Svc 升级后的 h3 目标
  cert 复用 /etc/sing-box/certs/hy2.{pem,key}（自签，浏览器需手动信任）

[本地验证] 跑完后从 VPS 本地：
  curl -I  http://127.0.0.1:${MASQ_PORT}/                   # 80/8080：Hugo plain HTTP
  curl -kI https://127.0.0.1:8443/                          # HTTPS（自签 cert，跳过验证）
  ss -lntu | grep -E ':(${MASQ_PORT}|8443)\s'                # 应看到 :MASQ_PORT tcp, :8443 tcp+udp

[下一步] 跑 setup-singbox.sh，让 443 上的 Reality/HY2 流量
  在 masq 不匹配时转发到 :${MASQ_PORT}；短 ID 失败 + ALPN 时 fallback 到 :8443。
EOF
