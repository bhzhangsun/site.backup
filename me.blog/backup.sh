#!/bin/bash
# ================================================================
# Ghost 完整备份脚本 (需 root 权限)
# 功能：备份 content、数据库、配置、凭证、Nginx 配置，推送到 Git
# 用法：sudo bash backup.sh [--keep-days <天数>]
# ================================================================

set -e

# ---------- 配置区 ----------
GHOST_DIR="/var/www/ghost"
BACKUP_BASE="/data"
REPO_DIR="$BACKUP_BASE/site.backup"            # 克隆后的仓库目录
BACKUP_SUBDIR="site.me"                         # 备份文件存放的子目录
GIT_REMOTE="git@github.com:bhzhangsun/site.backup.git"
GIT_BRANCH="main"
KEEP_DAYS=7

LOG_FILE="/var/log/ghost-backup.log"

# ---------- 颜色与日志 ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; exit 1; }

# ---------- 检查运行权限 ----------
if [ "$EUID" -ne 0 ]; then
    error "请使用 root 权限运行此脚本 (sudo bash $0)"
fi

if [ "$1" == "--keep-days" ] && [ -n "$2" ]; then
    KEEP_DAYS="$2"
    shift 2
fi

info "开始 Ghost 备份（保留最近 $KEEP_DAYS 天）..."

# ---------- 加载 MySQL 密码 ----------
CRED_FILE="$GHOST_DIR/.credentials"
if [ ! -f "$CRED_FILE" ]; then
    error "凭证文件 $CRED_FILE 不存在！请先部署 Ghost。"
fi
source "$CRED_FILE"
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    error "无法从 $CRED_FILE 读取 MySQL 密码。"
fi

# ---------- 确保备份目录和 Git 仓库 ----------
mkdir -p "$BACKUP_BASE"
cd "$BACKUP_BASE" || error "无法进入 $BACKUP_BASE"

if [ ! -d "$REPO_DIR/.git" ]; then
    info "首次运行，克隆远程仓库..."
    git clone "$GIT_REMOTE" "$REPO_DIR" || error "克隆仓库失败，请检查 GIT_REMOTE 和 SSH 密钥。"
else
    info "更新本地仓库..."
    cd "$REPO_DIR" || error "无法进入 $REPO_DIR"
    git pull origin "$GIT_BRANCH" 2>/dev/null || warn "git pull 失败，将尝试继续。"
fi

# 确保备份子目录存在
cd "$REPO_DIR" || error "无法进入 $REPO_DIR"
mkdir -p "$BACKUP_SUBDIR"
cd "$BACKUP_SUBDIR" || error "无法进入 $BACKUP_SUBDIR"

# ---------- 生成备份文件（带时间戳） ----------
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
CONTENT_BACKUP="content_$TIMESTAMP.tar.gz"
DB_BACKUP="ghost_db_$TIMESTAMP.sql"
CONFIG_BACKUP="config_$TIMESTAMP.json"
CRED_BACKUP="credentials_$TIMESTAMP.txt"
NGINX_BACKUP="nginx_$TIMESTAMP.conf"

# 1. 备份 content 目录
info "备份 content 目录..."
tar -czf "$CONTENT_BACKUP" \
    --exclude="*.log" \
    --exclude="*.tmp" \
    --exclude="node_modules" \
    -C "$GHOST_DIR" content/ || warn "content 备份可能不完整。"

# 2. 备份 MySQL 数据库
info "备份 MySQL 数据库..."
mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" ghost_production > "$DB_BACKUP" || error "数据库备份失败。"

# 3. 备份 config.production.json
info "备份 Ghost 配置文件..."
cp "$GHOST_DIR/config.production.json" "$CONFIG_BACKUP" || warn "config.production.json 不存在"

# 4. 备份凭证文件
info "备份凭证文件..."
cp "$CRED_FILE" "$CRED_BACKUP"

# 5. 备份 Nginx 配置
info "备份 Nginx 配置..."
NGINX_CONF=$(grep -l "proxy_pass.*2368" /etc/nginx/sites-available/* 2>/dev/null | head -n1)
if [ -n "$NGINX_CONF" ]; then
    cp "$NGINX_CONF" "$NGINX_BACKUP"
    info "Nginx 配置已备份: $NGINX_CONF"
else
    warn "未找到与 Ghost 相关的 Nginx 配置文件，跳过 Nginx 备份。"
fi

# 6. 显示备份文件大小
info "备份文件列表:"
ls -lh "$CONTENT_BACKUP" "$DB_BACKUP" "$CONFIG_BACKUP" "$CRED_BACKUP" "$NGINX_BACKUP" 2>/dev/null | awk '{print $9, $5}'

# ---------- 提交到 Git ----------
info "提交并推送到 Git..."
cd "$REPO_DIR" || error "无法进入 $REPO_DIR"
git add .
git commit -m "自动备份: $TIMESTAMP" || info "无变更需要提交。"
git push origin "$GIT_BRANCH" || error "Git 推送失败。"

# ---------- 清理旧备份 ----------
if [ "$KEEP_DAYS" -gt 0 ]; then
    info "清理 $KEEP_DAYS 天前的旧备份文件..."
    cd "$REPO_DIR/$BACKUP_SUBDIR" || error "无法进入 $BACKUP_SUBDIR"
    find . -name "content_*.tar.gz" -mtime +$KEEP_DAYS -delete
    find . -name "ghost_db_*.sql" -mtime +$KEEP_DAYS -delete
    find . -name "config_*.json" -mtime +$KEEP_DAYS -delete
    find . -name "credentials_*.txt" -mtime +$KEEP_DAYS -delete
    find . -name "nginx_*.conf" -mtime +$KEEP_DAYS -delete
fi

info "✅ 备份完成！"
info "备份仓库: $REPO_DIR"
info "备份文件位置: $REPO_DIR/$BACKUP_SUBDIR"
info "日志: $LOG_FILE"
