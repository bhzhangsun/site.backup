#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：装 sing-box（1.11+），
# 写 /etc/sing-box/config.json：
#   - Reality Trojan TCP:2053 trojan + reality（短 ID 错 → reality 透明转发
#                                  handshake_server；端口错开 443 让出给 nginx https/h3）
#   - Reality Vless  TCP:1443 vless + reality（备用入口，无 fallback；
#                                  短 ID 错 → reality 透明转发 handshake_server）
#   - HY2            UDP:8443 hysteria2（非 hy2 客户端 → masq → http://127.0.0.1:80 nginx）
#                                  8443 错开 443：443 TCP/UDP 整组让给 nginx serve https + h3
# 生成所有密钥（UUID / Reality keypair / shortId / HY2 password），
# 自签 HY2 cert（CN=nestseeker.xyz），
# 启动 systemd service。
# 幂等：可重复执行；密钥/cert 已存在则不覆盖；config.json 由环境变量重写。
#
# 用法：sudo ./setup-singbox.sh
# 可选环境变量：
#   TROJAN_PORT=2053                       # trojan reality 监听端口（443 让给 nginx https）
#   REALITY_HANDSHAKE_SERVER=www.tesla.com # reality 透明转发的伪装站
#   REALITY_HANDSHAKE_PORT=443
#   VLESS_PORT=1443
#   HY2_SERVER_NAME=nestseeker.xyz
#   HY2_CERT_CN=nestseeker.xyz
#   MASQ_PROXY_ADDR=127.0.0.1
#   MASQ_PROXY_PORT=80
#   FORCE_REGEN_KEYS=1   # 强制重新生成所有密钥（重置后所有客户端失效）
#   FORCE_REGEN_CERT=1   # 强制重新生成 HY2 cert

set -euo pipefail
# 出错时打印死在哪行、什么命令（避免 set -e 静默死）
trap 'echo "[FATAL] line $LINENO: $BASH_COMMAND  exit=$?" >&2' ERR
trap 'echo "[FATAL] interrupted line $LINENO" >&2' INT TERM

# === 默认值 ===
REALITY_HANDSHAKE_SERVER="${REALITY_HANDSHAKE_SERVER:-www.tesla.com}"
REALITY_HANDSHAKE_PORT="${REALITY_HANDSHAKE_PORT:-443}"
# Reality 协议硬约束：客户端 SNI 必须 = HANDSHAKE_SERVER（cert 是 dest 的，SNI 错就 cert 验证失败）
# 所以这里没有独立的 SERVER_NAME 变量，直接用 HANDSHAKE_SERVER
HY2_SERVER_NAME="${HY2_SERVER_NAME:-nestseeker.xyz}"
HY2_CERT_CN="${HY2_CERT_CN:-nestseeker.xyz}"
# HY2 硬约束（设计决定，不要改）：
#   listen = ::     IPv4+IPv6 dual stack
#   port  = 8443    独立 UDP 端口；443 TCP/UDP 整组让给 nginx（h2 + h3 共占）
#                   HY2 与 443 互不干扰（端口不同：8443 vs 443，socket 独立）
TROJAN_PORT="${TROJAN_PORT:-2053}"
# Trojan reality 监听端口：故意错开 443（443 TCP/UDP 整组归 nginx h2+h3）
# sing-box 1.13 同一 inbound 不支持同端口 listen（vless 1443 也是这个原因）
VLESS_PORT="${VLESS_PORT:-1443}"
MASQ_PROXY_ADDR="${MASQ_PROXY_ADDR:-127.0.0.1}"
MASQ_PROXY_PORT="${MASQ_PROXY_PORT:-80}"
FORCE_REGEN_KEYS="${FORCE_REGEN_KEYS:-0}"
FORCE_REGEN_CERT="${FORCE_REGEN_CERT:-0}"

SING_BOX_DIR="/etc/sing-box"
# keys.json 必须放配置目录外：sing-box 1.13+ systemd service 用 -C /etc/sing-box
# 扫描整个目录所有 .json 作 config；放 config 目录里会被当第二份 config 加载并报 schema 错
# StateDirectory=/var/lib/sing-box 是 sing-box service 的 working dir，天然归属 sing-box 用户
KEYS_FILE="/var/lib/sing-box/keys.json"
CONFIG_FILE="$SING_BOX_DIR/config.json"
CERT_DIR="$SING_BOX_DIR/certs"
HY2_CERT="$CERT_DIR/hy2.pem"
HY2_KEY="$CERT_DIR/hy2.key"
CERT_DAYS=3650

# === 探测本机出口 IP（用于生成客户端 URI） ===
# 用 "ip route get <公网地址> 的 src" 拿真实对外的公网 IP（双网卡 VPS 也准）
# 加 timeout + || echo "" 兜底：IP 探测绝不让 set -e 触发导致整个脚本静默死
HOSTNAME_SHORT=$(hostname -s 2>/dev/null | tr -dc 'A-Za-z0-9_-' | head -c 32 || echo "vps")
VPS_IPV4=$(timeout 3 ip -4 route get 1.1.1.1 2>/dev/null \
  | awk '{for(i=1;i<=NF;i++) if($i=="src") {print $(i+1); exit}}' \
  || echo "")
VPS_IPV6=$(timeout 3 ip -6 route get 2606:4700:4700::1111 2>/dev/null \
  | awk '{for(i=1;i<=NF;i++) if($i=="src") {print $(i+1); exit}}' \
  || echo "")
# 防 set -u 触发：变量可能未定义
: "${VPS_IPV4:=""}"
: "${VPS_IPV6:=""}"

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

  echo "[info] 装 sing-box..."

  if ! command -v jq >/dev/null 2>&1; then
    apt-get update -y >/dev/null
    apt-get install -y --no-install-recommends jq >/dev/null
  fi

  apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg >/dev/null

  local CODENAME ARCH
  CODENAME=$(lsb_release -cs)
  ARCH=$(dpkg --print-architecture)

  # 探测 sing-box 官方 apt 源是否可达（GFW 会屏蔽 deb.sing-box.app）
  if curl -fsSI --max-time 5 \
      "https://deb.sing-box.app/dists/$CODENAME/InRelease" >/dev/null 2>&1; then
    echo "[info] 使用 sing-box 官方 apt 源..."
    curl -fsSL https://sing-box.app/gpg.key \
      | gpg --dearmor --yes -o /usr/share/keyrings/sing-box-archive-keyring.gpg 2>/dev/null
    echo "deb [signed-by=/usr/share/keyrings/sing-box-archive-keyring.gpg] \
https://deb.sing-box.app/ $CODENAME main" \
      > /etc/apt/sources.list.d/sing-box.list
    apt-get update -y >/dev/null
    apt-get install -y --no-install-recommends sing-box >/dev/null
  else
    # 官方源被 GFW 屏蔽：从 GitHub release 下载 .deb 包安装
    echo "[info] 官方源不可达，改用 GitHub release .deb..."
    local VERSION DEB_URL TMP_DEB
    VERSION=$(curl -fsSL --max-time 10 \
      https://api.github.com/repos/SagerNet/sing-box/releases/latest \
      | grep -oP '"tag_name":\s*"v\K[^"]+' | head -1)
    if [[ -z "$VERSION" ]]; then
      echo "[error] 无法获取 sing-box 最新版本号（GitHub API 不通？）" >&2
      echo "        手动测试: curl -fsSI https://api.github.com" >&2
      exit 1
    fi
    DEB_URL="https://github.com/SagerNet/sing-box/releases/download/v${VERSION}/sing-box_${VERSION}_linux_${ARCH}.deb"
    TMP_DEB=$(mktemp --suffix=.deb)
    if ! curl -fsSL --max-time 60 -o "$TMP_DEB" "$DEB_URL"; then
      rm -f "$TMP_DEB"
      echo "[error] 下载失败: $DEB_URL" >&2
      exit 1
    fi
    apt-get install -y "$TMP_DEB" >/dev/null
    rm -f "$TMP_DEB"
  fi

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

  # 防御：清掉 config 目录里残留的旧 keys.json（sing-box 1.13+ -C 扫描会把它当 config 加载）
  # 老版本脚本把 keys.json 写在 /etc/sing-box/，迁移路径后若残留会让 sing-box 启动 FATAL
  if [[ -f "$SING_BOX_DIR/keys.json" ]]; then
    echo "[info] 清掉残留的 $SING_BOX_DIR/keys.json（避免被 sing-box 1.13 当 config 加载）"
    rm -f "$SING_BOX_DIR/keys.json"
  fi

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
#   - Trojan+Reality 监听 TCP:$TROJAN_PORT（IPv6 dual stack）
#       · 短 ID 错 → reality 透明转发到 handshake_server（反探测）
#       · 端口 2053 故意错开 443，让 443 TCP/UDP 给 nginx https / h3
#       · 不再需要 fallback / fallback_for_alpn：443 已不归 sing-box 管
#   - Vless+Reality 监听 TCP:$VLESS_PORT（备用入口，IPv6 dual stack）
#       · sing-box 1.13 vless 不支持 fallback，且同端口两个 inbound 冲突 → 必须独立端口
#       · 短 ID 错 → reality 透明转发到 handshake_server（反探测，无 fallback 弱点）
#   - HY2 监听 UDP:8443（hysteria2，独立端口；443 UDP 已归 nginx h3）
#   - HY2 失败（非 HY2 客户端）→ masquerade proxy → http://127.0.0.1:80 (nginx http)
#
# 关键选择：trojan 与 vless 共用同一 Reality keypair + short_id
#   - 它们共享一个 reality 私钥（一份 Reality config）
#   - 客户端配同样的 serverName / publicKey / shortId
#   - 差异只在协议层（vless uuid / trojan password）
#   - trojan password 直接复用 UUID（避免引入新密钥类型）
echo "[info] 写入 $CONFIG_FILE"

cat > "$CONFIG_FILE" <<EOF
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "trojan",
      "listen": "::",
      "listen_port": $TROJAN_PORT,
      "users": [
        {
          "name": "default",
          "password": "$UUID"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "$REALITY_HANDSHAKE_SERVER",
        "reality": {
          "enabled": true,
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
      "type": "vless",
      "listen": "::",
      "listen_port": $VLESS_PORT,
      "users": [
        {
          "name": "default",
          "uuid": "$UUID",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "$REALITY_HANDSHAKE_SERVER",
        "reality": {
          "enabled": true,
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
      "listen_port": 8443,
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
        "url": "http://$MASQ_PROXY_ADDR:$MASQ_PROXY_PORT",
        "rewrite_host": true
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
# 把 Reality public_key 从 standard base64 转成 URL safe（v2rayN 习惯）
REALITY_PBK_URLSAFE=$(printf '%s' "$REALITY_PUBLIC_KEY" | tr '+/' '-_' | tr -d '=')

cat <<EOF

[完成] sing-box 已就位：
  - Reality Trojan (TCP:$TROJAN_PORT) : password=UUID, SNI=$REALITY_HANDSHAKE_SERVER, dest=$REALITY_HANDSHAKE_SERVER
                                 短 ID 错 → reality 透明转发到真实 $REALITY_HANDSHAKE_SERVER
  - Reality Vless  (TCP:$VLESS_PORT) : UUID, SNI=$REALITY_HANDSHAKE_SERVER, dest=$REALITY_HANDSHAKE_SERVER
                                 短 ID 错 → reality 透明转发到真实 $REALITY_HANDSHAKE_SERVER（无 fallback，反探测更收敛）
  - HY2            (UDP:8443) : SNI=$HY2_SERVER_NAME, CN=$HY2_CERT_CN
  - masq                       : http://$MASQ_PROXY_ADDR:$MASQ_PROXY_PORT/ (HY2 失败时 → nginx serve Hugo)

[客户端配置 - 通用]
  vps_ip: <your vps ip>

[Reality Trojan 客户端 - 主入口]
  port: $TROJAN_PORT
  type: trojan
  password: $UUID
  serverName: $REALITY_HANDSHAKE_SERVER
  publicKey: $REALITY_PUBLIC_KEY
  shortId: $SHORT_ID_1
  network: tcp
  # ALPN 可任意配（fallback 已移除，ALPN=h2/h1.1 不再被截）

[Reality Vless 客户端 - 备用入口（反探测稍强，无 fallback 暴露面）]
  port: $VLESS_PORT
  type: vless
  uuid: $UUID
  flow: xtls-rprx-vision
  serverName: $REALITY_HANDSHAKE_SERVER
  publicKey: $REALITY_PUBLIC_KEY
  shortId: $SHORT_ID_1
  network: tcp

[HY2 客户端]
  port: 8443
  type: hysteria2
  password: $HY2_PASSWORD
  sni: $HY2_SERVER_NAME
  insecure: true   (因为是自签 cert)

EOF

# === 8. 打印 v2rayN / v2rayNG 订阅 URL（trojan + vless + hy2）×（ipv4 + ipv6）正交 ===
# IPv6 在 URI 里用 [] 包裹；URI fragment 用 hostname + proto + af 区分
# 注：fallback 已移除，trojan URI 不强制 alpn=空（客户端可任意配 alpn）
echo "[v2rayN / v2rayNG 订阅 URL]（复制整行导入 v2rayN / v2rayNG / Nekoray / Shadowrocket）"
if [[ -n "$VPS_IPV4" ]]; then
  echo "  trojan://${UUID}@${VPS_IPV4}:${TROJAN_PORT}?security=reality&sni=${REALITY_HANDSHAKE_SERVER}&fp=chrome&pbk=${REALITY_PBK_URLSAFE}&sid=${SHORT_ID_1}&type=tcp#${HOSTNAME_SHORT}-trojan-v4"
  echo "  vless://${UUID}@${VPS_IPV4}:${VLESS_PORT}?encryption=none&flow=xtls-rprx-vision&security=reality&sni=${REALITY_HANDSHAKE_SERVER}&fp=chrome&pbk=${REALITY_PBK_URLSAFE}&sid=${SHORT_ID_1}&type=tcp#${HOSTNAME_SHORT}-vless-v4"
  echo "  hysteria2://${HY2_PASSWORD}@${VPS_IPV4}:8443?sni=${HY2_SERVER_NAME}&insecure=true#${HOSTNAME_SHORT}-hy2-v4"
else
  echo "  (无 IPv4，跳过 v4 URI)"
fi
if [[ -n "$VPS_IPV6" ]]; then
  echo "  trojan://${UUID}@[${VPS_IPV6}]:${TROJAN_PORT}?security=reality&sni=${REALITY_HANDSHAKE_SERVER}&fp=chrome&pbk=${REALITY_PBK_URLSAFE}&sid=${SHORT_ID_1}&type=tcp#${HOSTNAME_SHORT}-trojan-v6"
  echo "  vless://${UUID}@[${VPS_IPV6}]:${VLESS_PORT}?encryption=none&flow=xtls-rprx-vision&security=reality&sni=${REALITY_HANDSHAKE_SERVER}&fp=chrome&pbk=${REALITY_PBK_URLSAFE}&sid=${SHORT_ID_1}&type=tcp#${HOSTNAME_SHORT}-vless-v6"
  echo "  hysteria2://${HY2_PASSWORD}@[${VPS_IPV6}]:8443?sni=${HY2_SERVER_NAME}&insecure=true#${HOSTNAME_SHORT}-hy2-v6"
else
  echo "  (无 IPv6，跳过 v6 URI)"
fi
echo ""

cat <<'EOF'
[密钥备份]
  客户端需要上面的值；密钥原文在 /var/lib/sing-box/keys.json (mode 600)
  每台 VPS 密钥独立（防止 one compromised = all compromised）

[下一步]
  1) VPS 上本地验证：
     sing-box check -c /etc/sing-box/config.json
     systemctl status sing-box
     ss -lntu | grep -E ':(8443|'"$TROJAN_PORT"'|'"$VLESS_PORT"')\s'
  2) 客户端用上面的 URI 连一下，确认能上网
  3) 用 setup-nginx-site.sh 部署 nginx（如果还没跑）
EOF
