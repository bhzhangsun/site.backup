# nestseeker.xyz VPS 部署

Hugo 静态站 + Reality/HY2 代理的一键部署脚本集。

## 目录

```
deploy/
├── hosts.json              # GitHub Actions 部署目标（rsync 路径在这里定义）
├── known_hosts             # SSH 主机指纹
└── scripts/
    ├── setup-deploy-user.sh   # ① 创建 deploy 用户 + SSH 公钥 + sudo 免密
    ├── setup-nginx-site.sh    # ② 自编译 nginx + quictls + :80 HTTP + :443 TCP/UDP (h2 + h3 共 listen)
    └── setup-singbox.sh       # ③ sing-box 1.11+ + trojan reality :2053 + vless reality :1443 + hy2 UDP:8443
```

## 执行顺序

**每台新 VPS 上**严格按 ① → ② → ③ 顺序执行，三个脚本都幂等（可重复跑）。

```
① setup-deploy-user.sh
   │  创建 deploy 用户、装 SSH 公钥、配 sudo NOPASSWD、chown 部署目录
   │
   ▼
② setup-nginx-site.sh
   │  自编译 nginx + quictls（带 QUIC 支持；Debian 11 系统 OpenSSL 1.1.1 走 apt 装不出 QUIC，必须自编译）
   │  （:80 = 直访 + hy2 masq；:443 TCP = 标准 https 站点；:443 UDP = h3 升级目标；Alt-Svc 头无端口写法 h3=":443"）
   │  :443 缺 cert 时脚本内 openssl 自签兜底（CN/SAN=nestseeker.xyz，10 年）
   │  跑通后用 acme.sh 申请真实 cert，直接覆盖脚本 env 指定的路径即可
   │
   ▼
③ setup-singbox.sh
   │  装 sing-box、生成 Reality/HY2 密钥、自签 HY2 cert、写 systemd
   │  trojan reality 监听 :2053、vless reality :1443、HY2 监听 UDP:8443
   │  （HY2 错开 443：443 TCP/UDP 整组给 nginx h2 + h3）
   │
   ▼
[完] 客户端用脚本末尾打印的配置连接
```

## 端口分配

| 端口 | 协议 | 服务 | 用途 |
|---|---|---|---|
| `:80`    | TCP    | nginx              | Hugo 静态站（直接访问 + hy2 masq 探测者伪装目标；带 Alt-Svc 引导 h3） |
| `:443`   | TCP    | nginx (h2/h1.1)    | nestseeker.xyz https 站点（自签兜底，acme.sh 可升级） + Alt-Svc 源 |
| `:443`   | UDP    | nginx (h3/QUIC)    | 浏览器 Alt-Svc 升级后的 h3 目标（跟 TCP 443 同 server block，共享 cert） |
| `:1443`  | TCP    | sing-box **vless** + reality | 备用入口；短 ID 错 → reality 透明转发 dest（反探测稍强） |
| `:2053`  | TCP    | sing-box **trojan** + reality | 主入口；短 ID 错 → reality 透明转发 dest（端口故意错开 443，让 nginx 拿到） |
| `:8443`  | UDP    | sing-box **hy2**   | 代理客户端；非 hy2 客户端 → masq → :80 |

**关键路由**：
- 浏览器 `https://nestseeker.xyz/` → TCP 443 nginx h2（直接命中，**不经过 sing-box**）→ 响应带 `Alt-Svc: h3=":443"`
- 浏览器第二次访问 → happy-eyeballs 升级到 UDP 443 nginx h3（同 listen 端口，QUIC 自动接管）
- 探测者 SNI=tesla.com → 连 :2053 trojan 验证失败 → reality 透明转发到真实 tesla.com:443（反探测保留）
- 备用入口：客户端连 `vps:1443` 走 vless+reality（无 fallback 暴露面，更"沉默"）

**为什么 443 TCP/UDP 整组给 nginx**：
- 主流部署模式：Cloudflare / Caddy / LiteSpeed / Apache 2.4.49+ 都在 443 同时跑 h2(TCP) + h3(UDP)
- Alt-Svc 头用无端口写法 `h3=":443"` 是 Chrome 首选（带端口写法 `:8443` 是 fallback 方案）
- 443 UDP 不再归 sing-box HY2：HY2 改 8443 UDP 错开
- trojan reality 监听 :2053（非标但够冷门；客户端配 2053 即可）
- vless 备用入口仍在 :1443（sing-box 同端口只能一个 inbound listen）

## 各脚本职责与边界
| 脚本 | 不做什么 | 让谁做 |
|---|---|---|
| `setup-deploy-user.sh` | 不装 nginx、不装 sing-box | — |
| `setup-nginx-site.sh` | 不创建 deploy 用户、不配 sudo；**不集成 acme.sh 申请 cert**（缺 cert 时脚本内 openssl 自签兜底） | `setup-deploy-user.sh`（用户）；acme.sh（cert，可选） |
| `setup-singbox.sh` | 不改 sudo、不动 nginx | 前两个 |

## SSL 证书清单

两张 cert，**职责分离**：

| cert | 生成者 | 初始来源 | 路径 | 给谁看 |
|---|---|---|---|---|
| **nginx HTTPS cert**（h2 + h3 共用） | `setup-nginx-site.sh` 自签兜底（CN/SAN=`nestseeker.xyz`，10 年） | 脚本内 `openssl req -x509` | `/etc/sing-box/certs/nestseeker.xyz.{fullchain,key}.pem`（env 可覆盖） | 浏览器（h2/h3 真实 TLS 握手） |
| **HY2 自签 cert** | `setup-singbox.sh` 自签（CN=`nestseeker.xyz`） | 脚本内 `openssl req -x509` | `/etc/sing-box/certs/hy2.pem` + `.key` | HY2 客户端（验证 CN == SNI） |

**自签 cert 能不能用？** 能，握手能通。**能跑通**就够了。浏览器会报「NET::ERR_CERT_AUTHORITY_INVALID」红屏（自签 cert 不在系统信任链），但 `:443` 的实际响应能验证、h3 升级逻辑能跑通（自签阶段 h3 不会被浏览器真正启用，要等 acme.sh 真实 cert 上后才能看到 h3 协议列）。

**跑通后升级成真实 cert**：用 acme.sh 申请 `nestseeker.xyz`，把产物覆盖到 nginx HTTPS cert 路径即可（**不需要改 nginx 配置**，env 默认路径就是 acme.sh `--install-cert` 的输出位置）：

```bash
acme.sh --issue -d nestseeker.xyz --webroot /var/www/nestseeker.xyz
acme.sh --install-cert -d nestseeker.xyz \
  --cert-file      /etc/sing-box/certs/nestseeker.xyz.cert.pem \
  --key-file       /etc/sing-box/certs/nestseeker.xyz.key.pem \
  --fullchain-file /etc/sing-box/certs/nestseeker.xyz.fullchain.pem \
  --reloadcmd      "systemctl reload nginx"
```

> 为什么不共用一张 cert 给 nginx 和 hy2？
> 1. **职责分离**：hy2 cert 是给受控客户端用的（`insecure=true`），浏览器不碰；https cert 是公开信任的。
> 2. **续签解耦**：acme.sh `--reloadcmd` 只 reload nginx，sing-box 不动；reload 出错互不影响。
> 3. **hy2 永久自签更省事**：hy2 客户端配 `insecure=true`，cert 内容只校验 CN，10 年自签都行，acme.sh cron 不必管它。
> 4. **未来灵活**：以后给 hy2 配不同伪装域名（`cdn.example.com`）时，hy2 cert 单独换，https cert 继续是 `nestseeker.xyz`，互不干扰。

- Reality 自带跳过 cert 验证，不依赖任何 cert
- 浏览器访问 `https://nestseeker.xyz/`（**443 标准端口**）自签阶段会红屏，curl 加 `-k` 跳过 cert 校验可验证握手

## VPS 上完整执行流程

脚本都从 GitHub 仓库 `raw.githubusercontent.com` 拉取，**不需手动上传**。

> 前提：仓库已 push 到 `main` 分支。如果要锁版本，把 `main` 换成 tag（如 `v1.0`）或 commit SHA。

### 1. ① 创建 deploy 用户

VPS 上**以 root 登录**后执行：

```bash
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-deploy-user.sh?t=$(date +%s)" | bash
```

可选覆盖（一般不用）：

```bash
# 自定义部署路径
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-deploy-user.sh?t=$(date +%s)" | DEPLOY_PATH=/var/www/nestseeker.xyz bash

# 临时换 SSH 公钥
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-deploy-user.sh?t=$(date +%s)" | SSH_PUBKEY="ssh-ed25519 AAAA..." bash
```

> **不要让脚本读本机 `hosts.json`** — 脚本在 VPS 上跑，VPS 没有仓库里的 `hosts.json`。
> 默认路径已跟 `hosts.json` 对齐（`/var/www/nestseeker.xyz`），需要换路径时用 `DEPLOY_PATH=...` 覆盖。

**验证**：另开终端 `ssh deploy@<VPS_IP>` 能免密登录。

### 2. ② 装 nginx

继续以 root 登录：

```bash
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-nginx-site.sh?t=$(date +%s)" | bash
```

可选覆盖（一般不用动）：

```bash
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-nginx-site.sh?t=$(date +%s)" | MASQ_PORT=80 MASQ_DOC_ROOT=/var/www/nestseeker.xyz bash
```

> :443 缺 cert 时脚本内 openssl 自签兜底，浏览器会红屏但能握手。跑通后用 acme.sh 申请真实 cert 覆盖默认路径即可（见上方 SSL 章节）。

**本地验证**：

```bash
curl -I  http://127.0.0.1:80         # Hugo plain HTTP（响应头含 Alt-Svc: h3=":443"）
curl -kI https://127.0.0.1:443/      # HTTPS（响应头含 Alt-Svc: h3=":443"）
ss -lntu | grep -E ':(80|443)\s'      # 应看到 :80 tcp + :443 tcp + :443 udp（h2 + h3 同 listen）
```

### 3. ③ 装 sing-box

```bash
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh?t=$(date +%s)" | bash
```

可选覆盖（默认就够用）：

```bash
wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh?t=$(date +%s)" | REALITY_HANDSHAKE_SERVER=www.tesla.com HY2_SERVER_NAME=nestseeker.xyz MASQ_PROXY_PORT=80 bash
```

**脚本末尾会打印客户端配置**，包含：
- Reality Trojan: `password`(=UUID) / `publicKey` / `shortId` / SNI（TCP:**2053**，主入口）
- Reality Vless: `uuid` / `publicKey` / `shortId` / SNI（TCP:1443，备用入口）
- HY2: `password` / SNI（UDP:8443）

**本地验证**：

```bash
sing-box check -c /etc/sing-box/config.json
systemctl status sing-box
ss -lntu | grep -E ':(8443|1443|2053)\s'   # 应看到 :8443 udp (hy2) + :1443 tcp (vless) + :2053 tcp (trojan) 都 LISTEN
```

### 4. 客户端连接

脚本 ③ 跑完会打印形如下面的配置（每台 VPS 密钥不同）：

```ini
[Reality Trojan - 主入口]
type=trojan, port=2053
password=<UUID>
serverName=www.tesla.com
publicKey=<...>
shortId=<...>
network=tcp
# ALPN 可任意配（fallback 已移除）

[Reality Vless - 备用入口]
type=vless, port=1443
uuid=<UUID>
flow=xtls-rprx-vision
serverName=www.tesla.com
publicKey=<...>
shortId=<...>
network=tcp

[HY2]
type=hysteria2, port=8443
password=<...>
sni=nestseeker.xyz
insecure=true
```

> Reality 客户端必须跳过 cert 验证（v2rayN/Nekoray/Shadowrocket 等都默认如此）。
>
> **Trojan 主入口端口是 2053 不是 443**（443 让给 nginx 跑 nestseeker.xyz 标准 https）。
>
> **Vless 备用入口的端口是 1443**（sing-box 同端口只能一个 inbound listen）。

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
  wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh?t=$(date +%s)" | FORCE_REGEN_KEYS=1 bash
  ```
- **重置 cert**：
  ```bash
  wget -qO- "https://raw.githubusercontent.com/bhzhangsun/site.backup/main/deploy/scripts/setup-singbox.sh?t=$(date +%s)" | FORCE_REGEN_CERT=1 bash
  ```
- **首次部署 Hugo 内容**：`gh workflow run deploy.yml`（GitHub Actions，依赖 `hosts.json`）
