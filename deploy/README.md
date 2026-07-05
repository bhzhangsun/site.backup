# nestseeker.xyz VPS 部署

Hugo 静态站 + Reality/HY2 代理的一键部署脚本集。

## 目录

```
deploy/
├── hosts.json              # GitHub Actions 部署目标（rsync 路径在这里定义）
├── known_hosts             # SSH 主机指纹
└── scripts/
    ├── setup-deploy-user.sh   # ① 创建 deploy 用户 + SSH 公钥 + sudo 免密
    ├── setup-nginx-site.sh    # ② nginx mainline + :80 HTTP + :8443 TCP/UDP 双栈
    └── setup-singbox.sh       # ③ sing-box 1.11+ + trojan reality :443 + vless reality :1443 + hy2 UDP:443
```

## 执行顺序

**每台新 VPS 上**严格按 ① → ② → ③ 顺序执行，三个脚本都幂等（可重复跑）。

```
① setup-deploy-user.sh
   │  创建 deploy 用户、装 SSH 公钥、配 sudo NOPASSWD、chown 部署目录
   │
   ▼
② setup-nginx-site.sh
   │  装 nginx mainline、写 :80 HTTP + :8443 TCP/UDP 双栈
   │  （:80 是直接访问入口 + hy2 masq 下游；:8443 是 reality fallback + h3 升级目标）
   │
   ▼
③ setup-singbox.sh
   │  装 sing-box、生成 Reality/HY2 密钥、自签 HY2 cert、写 systemd
   │
   ▼
[完] 客户端用脚本末尾打印的配置连接
```

## 端口分配

| 端口 | 协议 | 服务 | 用途 |
|---|---|---|---|
| `:80`    | TCP    | nginx              | Hugo 静态站（直接访问 + hy2 masq 探测者伪装目标） |
| `:443`   | TCP    | sing-box **trojan** + reality | 代理客户端 + fallback_for_alpn → :8443；裸探测者无 ALPN → reality 透明转发 dest |
| `:443`   | UDP    | sing-box **hy2**   | 代理客户端；非 hy2 客户端 → masq → :80 |
| `:1443`  | TCP    | sing-box **vless** + reality | 备用入口，无 fallback；短 ID 错 → reality 透明转发 dest（反探测稍强） |
| `:8443`  | TCP    | nginx (h2)         | trojan reality fallback 目标 + Alt-Svc 头（引导浏览器升 h3） |
| `:8443`  | UDP    | nginx (h3)         | 浏览器 Alt-Svc 升级后的 h3 目标 |

**关键路由**：
- 浏览器 `https://nestseeker.xyz/` → TCP 443 trojan → fallback_for_alpn → TCP 8443 nginx h2 → 响应带 `Alt-Svc: h3=":8443"`
- 浏览器第二次访问 → happy-eyeballs 升级到 UDP 8443 nginx h3（**绕开 sing-box**）
- 裸探测者（无 ALPN）→ trojan 不命中 fallback_for_alpn → reality 透明转发到真实 dest:443（反探测保留）
- 探测者 SNI=tesla.com → reality 透明转发到真实 tesla.com:443（vless/trojan 共享此行为）
- 备用入口：客户端连 `vps:1443` 走 vless+reality（无 fallback 暴露面，更"沉默"）

**为什么 trojan 与 vless 不都放 443**：
- sing-box 不支持两个 inbound 同时 listen 同一端口（`bind: address already in use`）
- 只能让 trojan 占 :443（带 fallback 满足浏览器需求），vless 让到 :1443（备用）

**Trojan 客户端必须 ALPN=空**：配 ALPN=h2/http1.1 会被 `fallback_for_alpn` 截到 nginx，永远进不了 trojan 协议。

## 各脚本职责与边界

| 脚本 | 不做什么 | 让谁做 |
|---|---|---|
| `setup-deploy-user.sh` | 不装 nginx、不装 sing-box | — |
| `setup-nginx-site.sh` | 不创建 deploy 用户、不配 sudo | `setup-deploy-user.sh` |
| `setup-singbox.sh` | 不改 sudo、不动 nginx | 前两个 |

## 端口分配

| 端口 | 协议 | 服务 | 用途 |
|---|---|---|---|
| `:80`   TCP | HTTP    | nginx | Hugo 静态站（直接访问 + hy2 masq 探测者伪装目标） |
| `:443`  TCP | TLS     | sing-box vless reality | 代理客户端 + 短 ID 失败 + ALPN 时 fallback 到 :8443 |
| `:443`  UDP | QUIC    | sing-box hy2 | 代理客户端；非 hy2 客户端 → masq → :80 |
| `:8443` TCP | TLS (h2)| nginx | vless reality fallback 目标 + Alt-Svc 头（引导浏览器升 h3） |
| `:8443` UDP | QUIC (h3) | nginx | 浏览器 Alt-Svc 升级后的 h3 目标 |

**关键路由**：
- 浏览器 `https://nestseeker.xyz/` → TCP 443 vless → fallback → TCP 8443 nginx h2 → 响应带 `Alt-Svc: h3=":8443"`
- 浏览器第二次访问 → happy-eyeballs 升级到 UDP 8443 nginx h3（**绕开 sing-box**）
- 裸探测者（无 ALPN）→ vless 直接 RST（反探测保留）
- 探测者 SNI=tesla.com → vless 透明转发到真实 tesla.com:443（reality 反探测）

## SSL 证书清单

只有一张**自签 cert**（CN=nestseeker.xyz），**两个用途复用**：

| cert | 生成脚本 | CN | 路径 | 给谁看 |
|---|---|---|---|---|
| **HY2 + nginx HTTPS cert** | `setup-singbox.sh` | `nestseeker.xyz` | `/etc/sing-box/certs/hy2.pem` + `.key` | HY2 客户端（验证 CN == SNI）；nginx 8443 TCP/UDP（h2/h3 TLS 握手） |

- HY2 客户端需要 `insecure=true`（自签 cert 信任问题）
- Reality 自带跳过 cert 验证，不依赖任何 cert
- 浏览器访问 `https://nestseeker.xyz:8443/` 需手动信任自签 cert
- 真实 cert（acme.sh 申请 `nestseeker.xyz`）可在 `setup-singbox.sh` 之后手动替换，**同时**更新 HY2 inbound 与 nginx 两个 server block 的 `ssl_certificate` 路径

## VPS 上完整执行流程

脚本都从 GitHub 仓库 `raw.githubusercontent.com` 拉取，**不需手动上传**。

> 前提：仓库已 push 到 `main` 分支。如果要锁版本，把 `main` 换成 tag（如 `v1.0`）或 commit SHA。

### 1. ① 创建 deploy 用户

VPS 上**以 root 登录**后执行：

```bash
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-deploy-user.sh | bash
```

可选覆盖（一般不用）：

```bash
# 自定义部署路径
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-deploy-user.sh | DEPLOY_PATH=/var/www/nestseeker.xyz bash

# 临时换 SSH 公钥
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-deploy-user.sh | SSH_PUBKEY="ssh-ed25519 AAAA..." bash
```

> **不要让脚本读本机 `hosts.json`** — 脚本在 VPS 上跑，VPS 没有仓库里的 `hosts.json`。
> 默认路径已跟 `hosts.json` 对齐（`/var/www/nestseeker.xyz`），需要换路径时用 `DEPLOY_PATH=...` 覆盖。

**验证**：另开终端 `ssh deploy@<VPS_IP>` 能免密登录。

### 2. ② 装 nginx

继续以 root 登录：

```bash
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-nginx-site.sh | bash
```

可选覆盖（一般不用动）：

```bash
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-nginx-site.sh | MASQ_PORT=80 MASQ_DOC_ROOT=/var/www/nestseeker.xyz bash
```

**本地验证**：

```bash
curl -I  http://127.0.0.1:80      # Hugo plain HTTP
curl -kI https://127.0.0.1:8443/  # HTTPS（自签 cert，-k 跳过验证）；响应头应带 Alt-Svc: h3=":8443"
ss -lntu | grep -E ':(80|8443)\s'  # 应看到 :80 tcp + :8443 tcp + udp
```

### 3. ③ 装 sing-box

```bash
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh | bash
```

可选覆盖（默认就够用）：

```bash
wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh | REALITY_HANDSHAKE_SERVER=www.tesla.com HY2_SERVER_NAME=nestseeker.xyz MASQ_PROXY_PORT=80 bash
```

**脚本末尾会打印客户端配置**，包含：
- Reality Trojan: `password`(=UUID) / `publicKey` / `shortId` / SNI（TCP:443，主入口）
- Reality Vless: `uuid` / `publicKey` / `shortId` / SNI（TCP:1443，备用入口）
- HY2: `password` / SNI（UDP:443）

**本地验证**：

```bash
sing-box check -c /etc/sing-box/config.json
systemctl status sing-box
ss -lntu | grep -E ':(443|1443)\s'   # 应看到 :443 tcp (trojan) + :443 udp (hy2) + :1443 tcp (vless) 都 LISTEN
```

### 4. 客户端连接

脚本 ③ 跑完会打印形如下面的配置（每台 VPS 密钥不同）：

```ini
[Reality Trojan - 主入口]
type=trojan, port=443
password=<UUID>
serverName=www.tesla.com
publicKey=<...>
shortId=<...>
network=tcp
# ⚠️ 客户端不要配 ALPN

[Reality Vless - 备用入口]
type=vless, port=1443
uuid=<UUID>
flow=xtls-rprx-vision
serverName=www.tesla.com
publicKey=<...>
shortId=<...>
network=tcp

[HY2]
type=hysteria2, port=443
password=<...>
sni=nestseeker.xyz
insecure=true
```

> Reality 客户端必须跳过 cert 验证（v2rayN/Nekoray/Shadowrocket 等都默认如此）。
>
> **Trojan 客户端不要配 ALPN**：ALPN=h2/http1.1 会被 `fallback_for_alpn` 截到 nginx，永远进不了 trojan 协议层。
>
> **Vless 备用入口的端口是 1443 不是 443**（sing-box 同端口只能一个 inbound listen）。

## 密钥与配置存放位置

| 文件 | 权限 | 作用 |
|---|---|---|
| `/etc/sing-box/config.json` | 600 | sing-box 主配置（inbound + outbound） |
| `/etc/sing-box/keys.json` | 600 | 所有密钥原文（UUID / Reality keypair / shortId / HY2 password） |
| `/etc/sing-box/certs/hy2.pem` | 644 | HY2 cert |
| `/etc/sing-box/certs/hy2.key` | 600 | HY2 cert key |
| `/var/www/nestseeker.xyz` | deploy:deploy | Hugo 静态站根（rsync 目标） |

## 日常维护

- **重启服务**：`systemctl restart sing-box` / `systemctl reload nginx`
- **查看日志**：`journalctl -u sing-box -n 100 --no-pager`
- **重置密钥**（警告：所有客户端失效）：
  ```bash
  wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh | FORCE_REGEN_KEYS=1 bash
  ```
- **重置 cert**：
  ```bash
  wget -qO- https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh | FORCE_REGEN_CERT=1 bash
  ```
- **首次部署 Hugo 内容**：`gh workflow run deploy.yml`（GitHub Actions，依赖 `hosts.json`）
