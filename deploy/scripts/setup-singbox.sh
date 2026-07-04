#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：装 sing-box（1.11+），
# 写 /etc/sing-box/config.json（Reality + HY2 共用 443），
# 生成所有密钥（UUID / Reality keypair / shortId / HY2 password），
# 自签 HY2 cert（CN=nestseeker.xyz），
# 启动 systemd service。
# 幂等：可重复执行；密钥已存在则不覆盖。
#
# 用法：sudo ./setup-singbox.sh
# 可选环境变量：
#   REALITY_HANDSHAKE_SERVER=www.tesla.com
#   REALITY_HANDSHAKE_PORT=443
#   REALITY_SERVER_NAME=nestseeker.xyz
#   HY2_SERVER_NAME=nestseeker.xyz
#   HY2_CERT_CN=nestseeker.xyz
#   MASQ_PROXY_ADDR=127.0.0.1
#   MASQ_PROXY_PORT=8080
#   FORCE_REGEN_KEYS=1   # 强制重新生成所有密钥（重置后所有客户端失效）
#   FORCE_REGEN_CERT=1   # 强制重新生成 HY2 cert

set -euo pipefail

# === 默认值 ===
REALITY_HANDSHAKE_SERVER="${REALITY_HANDSHAKE_SERVER:-www.tesla.com}"
REALITY_HANDSHAKE_PORT="${REALITY_HANDSHAKE_PORT:-443}"
REALITY_SERVER_NAME="${REALITY_SERVER_NAME:-nestseeker.xyz}"
HY2_SERVER_NAME="${HY2_SERVER_NAME:-nestseeker.xyz}"
HY2_CERT_CN="${HY2_CERT_CN:-nestseeker.xyz}"
MASQ_PROXY_ADDR="${MASQ_PROXY_ADDR:-127.0.0.1}"
MASQ_PROXY_PORT="${MASQ_PROXY_PORT:-8080}"
FORCE_REGEN_KEYS="${FORCE_REGEN_KEYS:-0}"
FORCE_REGEN_CERT="${FORCE_REGEN_CERT:-0}"

SING_BOX_DIR="/etc/sing-box"
KEYS_FILE="$SING_BOX_DIR/keys.json"
CONFIG_FILE="$SING_BOX_DIR/config.json"
CERT_DIR="$SING_BOX_DIR/certs"
HY2_CERT="$CERT_DIR/hy2.pem"
HY2_KEY="$CERT_DIR/hy2.key"
CERT_DAYS=3650

# --- 前置检查 ---
if [[ $EUID -ne 0 ]]; then
  echo "[error] 请用 root 或 sudo 执行此脚本" >&2
  exit 1
fi

# === 1. 装 sing-box（官方 apt 源） ===
install_sing_box() {
  if command -v sing-box >/dev/null 2>&1; then
    local v
    v=$(sing-box version 2>/dev/null | awk '{print $3}')
    if [[ -n "$v" ]]; then
      echo "[ok] sing-box $v 已安装"
      return
    fi
  fi

  echo "[info] 装 sing-box（官方源）..."

  if ! command -v jq >/dev/null 2>&1; then
    apt-get update -y >/dev/null
    apt-get install -y --no-install-recommends jq >/dev/null
  fi

  apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg >/dev/null

  local CODENAME
  CODENAME=$(lsb_release -cs)

  # sing-box 官方源（社区维护，1.11+）
  curl -fsSL https://sing-box.app/gpg.key \
    | gpg --dearmor -o /usr/share/keyrings/sing-box-archive-keyring.gpg 2>/dev/null

  echo "deb [signed-by=/usr/share/keyrings/sing-box-archive-keyring.gpg] \
https://deb.sing-box.app/ $CODENAME main" \
    > /etc/apt/sources.list.d/sing-box.list

  apt-get update -y >/dev/null
  apt-get install -y --no-install-recommends sing-box >/dev/null

  echo "[ok] 已安装 $(sing-box version 2>/dev/null | awk '{print $3}')"
}

install_sing_box

# === 2. 准备目录 ===
mkdir -p "$SING_BOX_DIR" "$CERT_DIR"
chmod 700 "$SING_BOX_DIR"

# === 3. 加载或生成密钥 ===
# keys.json 结构：
# {
#   "uuid": "<vless uuid>",
#   "reality": { "private_key", "public_key", "short_id": ["..."] },
#   "hysteria2": { "password" }
# }
if [[ -f "$KEYS_FILE" && "$FORCE_REGEN_KEYS" != "1" ]]; then
  echo "[ok] 密钥文件已存在: $KEYS_FILE"
  echo "    (用 FORCE_REGEN_KEYS=1 重新生成，警告：所有客户端会失效)"

  if ! command -v jq >/dev/null 2>&1; then
    echo "[error] 需要 jq 来解析 $KEYS_FILE" >&2
    exit 1
  fi

  UUID=$(jq -r '.uuid // empty' "$KEYS_FILE")
  REALITY_PRIVATE_KEY=$(jq -r '.reality.private_key // empty' "$KEYS_FILE")
  REALITY_PUBLIC_KEY=$(jq -r '.reality.public_key // empty' "$KEYS_FILE")
  SHORT_ID_1=$(jq -r '.reality.short_id[0] // empty' "$KEYS_FILE")
  HY2_PASSWORD=$(jq -r '.hysteria2.password // empty' "$KEYS_FILE")
else
  echo "[info] 生成新密钥..."

  if ! command -v jq >/dev/null 2>&1; then
    apt-get install -y --no-install-recommends jq >/dev/null
  fi

  UUID=$(sing-box generate uuid)
  local_keys=$(sing-box generate reality-keypair)
  REALITY_PRIVATE_KEY=$(echo "$local_keys" | awk '/PrivateKey/ {print $2}')
  REALITY_PUBLIC_KEY=$(echo "$local_keys" | awk '/PublicKey/ {print $2}')
  SHORT_ID_1=$(openssl rand -hex 8)             # 8 bytes = 16 hex chars
  HY2_PASSWORD=$(openssl rand -base64 24 | tr -d '/+=' | head -c 32)

  cat > "$KEYS_FILE" <<EOF
{
  "uuid": "$UUID",
  "reality": {
    "private_key": "$REALITY_PRIVATE_KEY",
    "public_key": "$REALITY_PUBLIC_KEY",
    "short_id": ["$SHORT_ID_1"]
  },
  "hysteria2": {
    "password": "$HY2_PASSWORD"
  }
}
EOF
  chmod 600 "$KEYS_FILE"
  echo "[ok] 密钥已写入 $KEYS_FILE (mode 600)"
fi

# 验证所有密钥都拿到了
for k in UUID REALITY_PRIVATE_KEY REALITY_PUBLIC_KEY SHORT_ID_1 HY2_PASSWORD; do
  if [[ -z "${!k:-}" ]]; then
    echo "[error] 密钥缺失: $k" >&2
    echo "        检查 $KEYS_FILE 内容或用 FORCE_REGEN_KEYS=1 重新生成" >&2
    exit 1
  fi
done

# === 4. 自签 HY2 cert（CN=$HY2_CERT_CN） ===
# HY2 客户端会验证 cert CN == server_name，必须一致
# 自签 cert：客户端需要配置 insecure=true
# 真实 cert（acme.sh 申请 nestseeker.xyz）：客户端无需 insecure
mkdir -p "$CERT_DIR"
chmod 700 "$CERT_DIR"

if [[ -f "$HY2_CERT" && -f "$HY2_KEY" && "$FORCE_REGEN_CERT" != "1" ]]; then
  echo "[ok] HY2 cert 已存在: $HY2_CERT"
else
  echo "[info] 自签 HY2 cert: CN=$HY2_CERT_CN"
  openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout "$HY2_KEY" \
    -out "$HY2_CERT" \
    -days "$CERT_DAYS" \
    -subj "/CN=$HY2_CERT_CN" \
    -addext "subjectAltName=DNS:$HY2_CERT_CN" \
    >/dev/null 2>&1
  chmod 600 "$HY2_KEY"
  chmod 644 "$HY2_CERT"
  echo "[ok] HY2 cert 已生成: $HY2_CERT"
fi

# === 5. 写 sing-box config.json ===
# 关键设计：
#   - Reality 监听 TCP:443（vless + reality）
#   - HY2     监听 UDP:443（hysteria2）
#   sing-box 内部自动区分 TCP/UDP，同一端口不冲突
#   - Reality 失败（短 ID 验证失败）→ sing-box 直接关连接（不配 fallback：探测者被 reset）
#   - HY2 失败（非 HY2 客户端）    → masquerade proxy 到 127.0.0.1:8080 (nginx)
echo "[info] 写入 $CONFIG_FILE"

cat > "$CONFIG_FILE" <<EOF
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "vless",
      "listen": "::",
      "listen_port": 443,
      "users": [
        {
          "name": "default",
          "uuid": "$UUID",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "reality": {
          "handshake": {
            "server": "$REALITY_HANDSHAKE_SERVER",
            "server_port": $REALITY_HANDSHAKE_PORT
          },
          "private_key": "$REALITY_PRIVATE_KEY",
          "short_id": ["$SHORT_ID_1"]
        }
      }
    },
    {
      "type": "hysteria2",
      "listen": "::",
      "listen_port": 443,
      "users": [
        {
          "name": "default",
          "password": "$HY2_PASSWORD"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "$HY2_SERVER_NAME",
        "certificate_path": "$HY2_CERT",
        "key_path": "$HY2_KEY"
      },
      "masquerade": {
        "type": "proxy",
        "server": "$MASQ_PROXY_ADDR",
        "server_port": $MASQ_PROXY_PORT
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct"
    }
  ]
}
EOF
chmod 600 "$CONFIG_FILE"
echo "[ok] $CONFIG_FILE 已写入 (mode 600)"

# === 6. 验证 + 启动 ===
echo "[info] 验证 config..."
sing-box check -c "$CONFIG_FILE"

# sing-box 官方包自带 systemd service（/lib/systemd/system/sing-box.service）
# 不需要自己写 service 文件
systemctl daemon-reload
systemctl enable sing-box
systemctl restart sing-box

# 等待启动
sleep 1
if systemctl is-active --quiet sing-box; then
  echo "[ok] sing-box 已启动"
else
  echo "[error] sing-box 启动失败，查看日志："
  journalctl -u sing-box -n 30 --no-pager
  exit 1
fi

# === 7. 打印客户端配置 ===
cat <<EOF

[完成] sing-box 已就位：
  - Reality (TCP:443) : UUID=$UUID, SNI=$REALITY_SERVER_NAME, dest=$REALITY_HANDSHAKE_SERVER
  - HY2     (UDP:443) : SNI=$HY2_SERVER_NAME, CN=$HY2_CERT_CN
  - masq     : $MASQ_PROXY_ADDR:$MASQ_PROXY_PORT (HY2 失败时 → nginx 8080)
  - (Reality 失败探测者：sing-box 直接 reset，无 fallback)

[客户端配置 - 通用]
  vps_ip: <your vps ip>
  port: 443

[Reality 客户端]
  type: vless
  uuid: $UUID
  flow: xtls-rprx-vision
  serverName: $REALITY_SERVER_NAME
  publicKey: $REALITY_PUBLIC_KEY
  shortId: $SHORT_ID_1
  network: tcp

[HY2 客户端]
  type: hysteria2
  password: $HY2_PASSWORD
  sni: $HY2_SERVER_NAME
  insecure: true   (因为是自签 cert)

[密钥备份]
  客户端需要上面的值；密钥原文在 $KEYS_FILE (mode 600)
  每台 VPS 密钥独立（防止 one compromised = all compromised）

[下一步]
  1) VPS 上本地验证：
     sing-box check -c $CONFIG_FILE
     systemctl status sing-box
     ss -lntu | grep ':443'
  2) 客户端用上面的配置连一下，确认能上网
  3) 用 setup-nginx-site.sh 部署 nginx（如果还没跑）
EOF
