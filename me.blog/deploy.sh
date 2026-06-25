#!/bin/bash
# ============================================================
# Ghost 博客一键部署脚本 (Ubuntu 22.04/24.04)
# 用法: sudo bash deploy-ghost.sh [选项]
#   选项:
#     --url <URL>         博客访问地址 (如 https://example.com 或 http://<IP>)
#     --ssl               自动申请 Let's Encrypt SSL (需域名且已解析)
#     --dbpass <密码>     MySQL root 密码 (若不指定则随机生成并保存)
#     --user <用户名>     运行 Ghost 的系统用户 (默认 bloguser)
# ============================================================

set -e

# ---------- 默认值 ----------
GHOST_USER="bloger"
BLOG_URL="http://$(curl -s ifconfig.me)"
ENABLE_SSL=false
MYSQL_PASS=""

# ---------- 解析参数 ----------
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
        *)
            echo "未知选项: $1"
            exit 1
            ;;
    esac
done

# ---------- 颜色输出 ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

if [ "$EUID" -ne 0 ]; then
    error "请使用 root 权限运行此脚本 (sudo bash $0)"
fi

info "开始部署 Ghost 博客..."

# ---------- 1. 更新系统 ----------
info "更新系统软件包..."
# apt-get update
# apt-get install -y software-properties-common
# add-apt-repository universe -y
apt-get update && apt-get upgrade -y

# ---------- 2. 安装基础软件 ----------
info "安装 Nginx, MySQL, 及其他依赖..."
apt-get install -y nginx mariadb-server curl git

# ========== 配置 MariaDB root 密码 ==========
if [ -z "$MYSQL_PASS" ]; then
    MYSQL_PASS=$(openssl rand -base64 18 | tr -d "=+/" | cut -c1-16)
    info "已自动生成 MariaDB root 密码: $MYSQL_PASS"
fi

info "配置 MariaDB root 密码..."
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_PASS}');
FLUSH PRIVILEGES;
EOF

# 验证密码是否生效
mysql -u root -p"${MYSQL_PASS}" -e "SELECT 1" &>/dev/null
if [ $? -ne 0 ]; then
    # 如果上面的 ALTER USER 语法不生效（不同 MariaDB 版本差异），使用备选方案
    mysql <<EOF
UPDATE mysql.user SET plugin='mysql_native_password', Password=PASSWORD('${MYSQL_PASS}') WHERE User='root';
FLUSH PRIVILEGES;
EOF
fi

info "MariaDB root 密码配置完成"

# ---------- 4. 安装 Node.js 22.x ----------
info "安装 Node.js 22.x..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs
node -v

# ---------- 5. 安装 Ghost-CLI ----------
info "安装 Ghost-CLI..."
npm install -g ghost-cli@latest

# ---------- 6. 创建系统用户 ----------
if id "$GHOST_USER" &>/dev/null; then
    info "用户 $GHOST_USER 已存在，跳过创建"
else
    info "创建用户 $GHOST_USER..."
    useradd -m -s /bin/bash "$GHOST_USER"
    echo "$GHOST_USER:$(openssl rand -base64 12)" | chpasswd
fi

# ---------- 7. 准备 Ghost 安装目录 ----------
GHOST_DIR="/var/www/ghost"
info "创建 Ghost 安装目录 $GHOST_DIR..."
mkdir -p "$GHOST_DIR"
chown -R "$GHOST_USER":"$GHOST_USER" "$GHOST_DIR"

# ---------- 8. 以非 root 用户执行 Ghost 安装 ----------
info "切换至用户 $GHOST_USER 执行 Ghost 安装..."
INSTALL_CMD="cd $GHOST_DIR && ghost install \
    --url '$BLOG_URL' \
    --db mysql \
    --dbhost localhost \
    --dbuser root \
    --dbpass '$MYSQL_PASS' \
    --dbname ghost_production"

if [ "$ENABLE_SSL" = true ]; then
    INSTALL_CMD="$INSTALL_CMD --ssl"
else
    INSTALL_CMD="$INSTALL_CMD --no-setup-ssl"
fi

su - "$GHOST_USER" -c "$INSTALL_CMD"

# ---------- 9. 保存密码到凭证文件 ----------
CRED_FILE="$GHOST_DIR/.credentials"
info "保存 MySQL 密码到 $CRED_FILE ..."
cat > "$CRED_FILE" <<EOF
# Ghost 部署凭证 - 请勿泄露
# 生成时间: $(date)
MYSQL_ROOT_PASSWORD=$MYSQL_PASS
EOF
chown "$GHOST_USER":"$GHOST_USER" "$CRED_FILE"
chmod 600 "$CRED_FILE"

# ---------- 10. 完成提示 ----------
info "🎉 Ghost 博客部署完成！"
info "访问地址: $BLOG_URL"
if [ "$ENABLE_SSL" = false ] && [[ "$BLOG_URL" != https://* ]]; then
    warn "您未启用 SSL，建议后续通过 'ghost setup ssl' 配置证书"
fi
info "后台管理地址: $BLOG_URL/ghost (首次访问需创建管理员账户)"
info "MySQL root 密码已保存至: $CRED_FILE"
info "请将备份脚本中的密码文件路径指向此文件"

