#!/usr/bin/env bash
# 在 VPS 上以 root 权限执行：创建 deploy 用户、配置 SSH 公钥登录、配置 sudo 免密码
# 可选：DEPLOY_PATH=/your/path  指定部署目录（默认 /var/www/html），会 chown 给新用户
# 不修改 sshd，不影响其他账户。
#
# 用法：sudo ./setup-deploy-user.sh [username]
#       username  可选，默认 deploy
#       SSH_PUBKEY=... 可临时覆盖脚本内嵌的公钥

set -euo pipefail

USERNAME="${1:-deploy}"

# === 在此填入 deploy 用户的 SSH 公钥（必填，提交到仓库是安全的）===
DEPLOY_PUBKEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMkqePFmGCKonjet7fnt4QK0W1k0O2S6lHzC35vfGiQ github-actions-deploy'
# ====================================================================

# 优先使用环境变量覆盖，否则取脚本内嵌的公钥
SSH_PUBKEY="${SSH_PUBKEY:-$DEPLOY_PUBKEY}"

# --- 前置检查 ---
if [[ $EUID -ne 0 ]]; then
  echo "[error] 请用 root 或 sudo 执行此脚本" >&2
  exit 1
fi

if [[ -z "$SSH_PUBKEY" || "$SSH_PUBKEY" == "REPLACE_ME_WITH_SSH_PUBLIC_KEY" ]]; then
  cat >&2 <<'EOF'
[error] 未配置 deploy 用户的 SSH 公钥。
请编辑脚本顶部 DEPLOY_PUBKEY= 一行，填入完整公钥。
或运行时传入：sudo SSH_PUBKEY="ssh-ed25519 ..." ./setup-deploy-user.sh
EOF
  exit 1
fi

# 1. 创建用户（幂等）
if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USERNAME"
  echo "[ok] 已创建用户 $USERNAME"
else
  echo "[ok] 用户 $USERNAME 已存在"
fi

# 2. 配置 .ssh 与 authorized_keys
USER_HOME=$(getent passwd "$USERNAME" | cut -d: -f6)
install -d -m 700 -o "$USERNAME" -g "$USERNAME" "$USER_HOME/.ssh"

AUTH_KEYS="$USER_HOME/.ssh/authorized_keys"
touch "$AUTH_KEYS"
chown "$USERNAME:$USERNAME" "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

if grep -qF "$SSH_PUBKEY" "$AUTH_KEYS"; then
  echo "[ok] 公钥已存在，跳过追加"
else
  printf '%s\n' "$SSH_PUBKEY" >> "$AUTH_KEYS"
  echo "[ok] 公钥已写入 $AUTH_KEYS"
fi

# 3. sudo 免密码（仅 deploy 用户）
SUDOERS_FILE="/etc/sudoers.d/90-${USERNAME}-deploy"
cat > "$SUDOERS_FILE" <<EOF
# 由 setup-deploy-user.sh 生成
${USERNAME} ALL=(ALL) NOPASSWD:ALL
EOF
chmod 440 "$SUDOERS_FILE"
visudo -c -f "$SUDOERS_FILE" >/dev/null
echo "[ok] 已配置 sudo 免密码（$SUDOERS_FILE）"

# 4. 部署目录所有权（让 deploy 用户对部署路径可写）
DEPLOY_PATH="${DEPLOY_PATH:-/var/www/html}"
if [[ -d "$DEPLOY_PATH" ]]; then
  chown -R "$USERNAME:$USERNAME" "$DEPLOY_PATH"
  echo "[ok] 已将 $DEPLOY_PATH 所有权交给 $USERNAME"
else
  echo "[warn] $DEPLOY_PATH 不存在；可后续手动执行：sudo mkdir -p $DEPLOY_PATH && sudo chown $USERNAME:$USERNAME $DEPLOY_PATH"
fi

# 5. 不再自动修改 /etc/ssh/sshd_config，避免影响其他账户登录方式。
# 如需加固，可参考（按需手动执行）：
#   sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
#   sudo tee -a /etc/ssh/sshd_config >/dev/null <<'EOF'
#   # 仅允许 deploy 用密钥登录，其他账户不受影响
#   Match User deploy
#       PasswordAuthentication no
#   EOF
#   sudo sshd -t && sudo systemctl reload sshd
echo "[ok] sshd 未做改动；如需加固请按脚本末尾的提示手动操作"

cat <<EOF

[完成] 接下来：
  1) 本地验证（确认能登录再退出当前会话）：
       ssh ${USERNAME}@<VPS_IP>
  2) 确认部署目录 ${USER_HOME} 或指定 path 有写权限后再接入 workflow
EOF
