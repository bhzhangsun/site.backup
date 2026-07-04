#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：装 nginx 1.31.x（nginx.org 源），
# 写一个 server block：
#   :8080  HY2 masq          —— 主动 UDP 探测者看到的 Hugo 静态站
# 配置全部走 /etc/nginx/conf.d/，不污染主配置。
# 幂等：可重复执行。
#
# 旧版本里有 :8443 Reality fallback（plain TCP + 444 关连接）。
# 已删除：sing-box Reality 不配 fallback 时探测者会被直接 reset，
# 效果与 444 等价，少一个端口+少一个进程+反侦察更友好（探测者看到 RST）。
# 本脚本会清理旧的 /etc/nginx/conf.d/masq-fallback-*.conf。
#
# 用法：sudo ./setup-nginx-site.sh
# 可选环境变量：
#   MASQ_PORT=8080
#   MASQ_DOC_ROOT=/var/www/nestseeker.xyz
#   SKIP_NGINX_INSTALL=1          # 已装好 nginx 1.27+ 时跳过安装

set -euo pipefail

# === 默认值 ===
MASQ_PORT="${MASQ_PORT:-8080}"
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

# === 3. 清理旧的 :8443 fallback conf（已废弃） ===
# 老脚本会写 /etc/nginx/conf.d/masq-fallback-8443.conf，删掉避免 reload 时被加载。
shopt -s nullglob
for stale in "$NGINX_CONF_DIR"/masq-fallback-*.conf; do
  rm -f "$stale"
  echo "[ok] 已清理废弃 fallback conf: $stale"
done
shopt -u nullglob

# === 4. 写 :8080（HY2 masq）配置 ===
# HY2 客户端通过密码验证，不会走 masquerade。
# 走 masquerade 的是：主动 UDP 探测者（GFW 扫全端口）。
# 行为：直接 serve Hugo 静态站，探测者看到的是 nestseeker.xyz 博客
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
# HY2 masq: 主动 UDP 探测者（不是 HY2 客户端）看到的是 Hugo 静态站
# 不开 TLS：sing-box 内置 masq proxy 已经把 QUIC 转成 HTTP
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

# 探测 :8080 端口
if ss -lnt "sport = :$MASQ_PORT" 2>/dev/null | grep -q LISTEN; then
  echo "[ok] $MASQ_PORT 在监听"
else
  echo "[warn] $MASQ_PORT 暂未在监听"
fi

cat <<EOF

[完成] nginx 已就位：
  - :$MASQ_PORT   HY2 masq         (serve $MASQ_DOC_ROOT)

[本地验证] 跑完后从 VPS 本地：
  curl -I  http://127.0.0.1:$MASQ_PORT        # 应返回 200 + Hugo

[下一步] 跑 setup-singbox.sh 让 443 上的 Reality/HY2 流量
  在 masq 不匹配时转发到 :$MASQ_PORT。
EOF
