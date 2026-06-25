#!/bin/bash
# ================================================================
# Ghost 一键部署脚本 (支持 Debian 11/12, Ubuntu 20.04/22.04)
# 功能：Nginx + MariaDB + Node.js + Ghost + 可选 SSL
# 用法：sudo bash deploy-ghost.sh [选项]
#   选项：
#     --url <URL>       博客地址 (如 http://example.com 或 https://example.com)
#     --ssl             启用 HTTPS (需域名已解析，且 --url 为 https://)
#     --dbpass <密码>   指定 MariaDB root 密码 (默认随机生成)
#     --user <用户名>   运行 Ghost 的系统用户 (默认 bloger)
#     --domain <域名>   指定 SSL 域名 (若不提供则从 --url 提取)
#     --skip-swap       跳过 Swap 创建 (如果已存在)
# ================================================================

set -e

# ---------- 默认值 ----------
GHOST_USER="bloger"
BLOG_URL=""
ENABLE_SSL=false
MYSQL_PASS=""
DOMAIN=""
SKIP_SWAP=false

# ---------- 参数解析 ----------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --url)
            BLOG_URL="$2"
            shift 2
            ;;
        --ssl)
            ENABLE_SSL=true
            shift
            ;;
        --dbpass)
            MYSQL_PASS="$2"
            shift 2
            ;;
        --user)
            GHOST_USER="$2"
            shift 2
            ;;
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --skip-swap)
            SKIP_SWAP=true
            shift
            ;;
        *)
            echo "未知选项: $1"
            echo "用法: sudo $0 --url <URL> [--ssl] [--dbpass <密码>] [--user <用户名>] [--domain <域名>]"
            exit 1
            ;;
    esac
done

if [ -z "$BLOG_URL" ]; then
    echo "错误: 必须指定 --url 参数"
    echo "用法: sudo $0 --url <URL> [--ssl]"
    exit 1
fi

# 如果启用 SSL 但未指定域名，从 BLOG_URL 提取
if [ "$ENABLE_SSL" = true ] && [ -z "$DOMAIN" ]; then
    DOMAIN=$(echo "$BLOG_URL" | sed -e 's|^https\?://||' -e 's|/.*$||')
fi

# ---------- 颜色输出 ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

if [ "$EUID" -ne 0 ]; then
    error "请使用 root 权限运行此脚本 (sudo bash $0)"
fi

info "开始 Ghost 部署..."
info "目标地址: $BLOG_URL"
[ "$ENABLE_SSL" = true ] && info "SSL: 已启用 (域名: $DOMAIN)" || info "SSL: 未启用"

# ---------- 1. 检测系统类型 ----------
info "检测系统类型..."
if [ -f /etc/debian_version ]; then
    OS="debian"
    info "系统: Debian"
else
    OS="ubuntu"
    info "系统: Ubuntu"
fi

# ---------- 2. 更新系统 ----------
info "更新系统软件包..."
apt-get update && apt-get upgrade -y

# ---------- 3. 创建 Swap (避免内存不足) ----------
if [ "$SKIP_SWAP" = false ] && [ ! -f /swapfile ]; then
    info "创建 1GB Swap 空间..."
    fallocate -l 1G /swapfile 2>/dev/null || dd if=/dev/zero of=/swapfile bs=1024 count=1048576
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    info "Swap 创建并启用成功。"
elif [ -f /swapfile ]; then
    info "Swap 已存在，跳过创建。"
else
    info "已通过 --skip-swap 跳过 Swap 创建。"
fi

# ---------- 4. 安装基础软件 ----------
info "安装 Nginx, MariaDB, curl, git..."
apt-get install -y nginx mariadb-server curl git

# ---------- 5. 配置 MariaDB root 密码 ----------
if [ -z "$MYSQL_PASS" ]; then
    MYSQL_PASS=$(openssl rand -base64 18 | tr -d "=+/" | cut -c1-16)
    info "已生成 MariaDB root 密码: $MYSQL_PASS"
fi

info "配置 MariaDB root 密码..."
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_PASS}');
FLUSH PRIVILEGES;
EOF

# 验证密码
mysql -u root -p"${MYSQL_PASS}" -e "SELECT 1" &>/dev/null || error "MariaDB 密码设置失败，请检查。"

# ---------- 6. 安装 Node.js 22.x ----------
info "安装 Node.js 22.x..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs
node -v

# ---------- 7. 安装 Ghost-CLI ----------
info "安装 Ghost-CLI..."
npm install -g ghost-cli@latest

# ---------- 8. 创建系统用户 ----------
if id "$GHOST_USER" &>/dev/null; then
    info "用户 $GHOST_USER 已存在，跳过创建。"
else
    info "创建用户 $GHOST_USER..."
    useradd -m -s /bin/bash "$GHOST_USER"
    echo "$GHOST_USER:$(openssl rand -base64 12)" | chpasswd
    usermod -aG sudo "$GHOST_USER"
fi

# ---------- 9. 配置 sudo 免密 ----------
info "配置 sudo 免密权限 (仅限 ghost 命令)..."
echo "$GHOST_USER ALL=(ALL) NOPASSWD: /usr/bin/ghost" > /etc/sudoers.d/ghost
chmod 440 /etc/sudoers.d/ghost

# ---------- 10. 准备 Ghost 安装目录 ----------
GHOST_DIR="/var/www/ghost"
info "创建 Ghost 安装目录 $GHOST_DIR..."
rm -rf "$GHOST_DIR" 2>/dev/null
mkdir -p "$GHOST_DIR"
chown "$GHOST_USER":"$GHOST_USER" "$GHOST_DIR"

# ---------- 11. 以非 root 用户执行 Ghost 安装 ----------
info "切换至用户 $GHOST_USER 执行 Ghost 安装..."
INSTALL_CMD="cd $GHOST_DIR && ghost install \
    --url '$BLOG_URL' \
    --db mysql \
    --dbhost localhost \
    --dbuser root \
    --dbpass '$MYSQL_PASS' \
    --dbname ghost_production \
    --no-setup-ssl"

su - "$GHOST_USER" -c "$INSTALL_CMD" || error "Ghost 安装失败。"

# ---------- 12. 保存凭证 ----------
CRED_FILE="$GHOST_DIR/.credentials"
info "保存密码和配置到 $CRED_FILE ..."
cat > "$CRED_FILE" <<EOF
# Ghost 部署凭证 - 请妥善保管
# 生成时间: $(date)
MYSQL_ROOT_PASSWORD=$MYSQL_PASS
GHOST_USER=$GHOST_USER
BLOG_URL=$BLOG_URL
DOMAIN=$DOMAIN
ENABLE_SSL=$ENABLE_SSL
EOF
chown "$GHOST_USER":"$GHOST_USER" "$CRED_FILE"
chmod 600 "$CRED_FILE"

# ---------- 13. 配置 Nginx (手动生成，避免 ghost setup 跳过) ----------
info "配置 Nginx 反向代理..."

# 先移除可能存在的默认配置干扰
rm -f /etc/nginx/sites-enabled/default

# 生成 Nginx 配置文件 (HTTP)
cat > /etc/nginx/sites-available/ghost <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Host \$http_host;
        proxy_pass http://127.0.0.1:2368;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        client_max_body_size 50m;
    }
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/
nginx -t || error "Nginx 配置语法错误"
systemctl reload nginx

# ---------- 14. SSL 配置 ----------
if [ "$ENABLE_SSL" = true ] && [ -n "$DOMAIN" ]; then
    info "配置 SSL (域名: $DOMAIN)..."

    # 安装 Certbot
    apt-get install -y certbot python3-certbot-nginx

    # 尝试申请证书 (增加超时重试)
    info "正在申请 Let's Encrypt 证书 (可能需要几分钟)..."
    if certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email "admin@$DOMAIN" --redirect; then
        info "SSL 证书配置成功！"
    else
        warn "SSL 证书申请失败，可能原因:"
        warn "  1. 域名解析未生效 (请确认 $DOMAIN 已指向本机 IP)"
        warn "  2. 80/443 端口未在防火墙/安全组中放行"
        warn "  3. Let's Encrypt 临时限制，请稍后重试"
        warn "你可以稍后手动运行: certbot --nginx -d $DOMAIN"
    fi
else
    info "未启用 SSL。你也可以稍后手动配置: certbot --nginx -d your-domain.com"
fi

# ---------- 15. 更新 Ghost URL (如果启用了 SSL) ----------
if [ "$ENABLE_SSL" = true ] && [ -n "$DOMAIN" ]; then
    info "更新 Ghost URL 为 HTTPS..."
    su - "$GHOST_USER" -c "cd $GHOST_DIR && ghost config url https://$DOMAIN && ghost restart"
fi

# ---------- 16. 完成提示 ----------
info "==========================================="
info "🎉 Ghost 部署完成！"
if [ "$ENABLE_SSL" = true ] && [ -n "$DOMAIN" ]; then
    info "博客访问: https://$DOMAIN"
    info "后台管理: https://$DOMAIN/ghost"
else
    info "博客访问: $BLOG_URL"
    info "后台管理: $BLOG_URL/ghost"
fi
info "MariaDB root 密码: $MYSQL_PASS"
info "凭证文件: $CRED_FILE"
info "系统用户: $GHOST_USER"
info "==========================================="
info "首次访问后台请创建管理员账户。"

