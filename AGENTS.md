# AGENTS.md — 这个仓库的工作流

本站是 Hugo 静态博客（`nestseeker.xyz`），双语（中文 + 英文），通过 GitHub Actions
构建后 rsync 到两台 VPS。

本文件写给 AI agent。**它是流程约束，不是建议。** 下面是本项目的文章工作流，
每一步的验收标准都写死了。跳过步骤、跳过验证的后果在文末有记录。

---

## 文章工作流（五步，不要跳步）

### 1. 用户口述观点 → 我负责讨论，并且要"烦"他

用户会在会话中直接给观点，通常粗糙、带编号、有跳跃。我的任务不是记录，是把它打磨到站得住。

- **逐条给出证据等级**：分清哪条是事实、哪条是预测、哪条是同义反复（定义循环）、
  哪条是价值判断。分开讲。
- **必须提出最强反驳**，不是象征性提问。至少覆盖四类：
  - 定义是否循环。例："未来只有工程师"——若"工程师"的定义就是"有系统思维的人"，
    这句话等于"没有系统思维的人会被淘汰"，无信息量。
  - 是否有排他性证据。例：岗位减少是 AI 造成的，还是 2021 年扩张后的矫正？
  - 内部是否自相矛盾。例："技术栈分化减小"与"依赖管理岗位会被替代"不能同时说满。
  - 反例是否存在。例："人写的代码更可信"——没人理解的遗留代码同样是黑盒。
- **指出缺失的关键一环**，而不只挑错。历史上真正有价值的补充长这样：
  验证能力分实现层与设计层、信任判据是"可排查性"而非"有无 bug"、
  需求侧是长尾上移而非新需求池、ground truth 必须由人提供。
- **主动使用"承认没想清楚"**。把未解之处留进文章，比假装闭合可信。
- **不要一次抛十个问题**。挑 3–4 条决定文章骨架的，其余顺带提。用户可能只答其中几条，
  这时把他已经给出的口径**固化成"定稿口径"**再往下走。
- **用户说"我认"就采纳**，不要反复论证。用户说"这条不成立"或"这次历史失效了"，
  要接住并改自己的框架。
- **用户随时可能补新事实**（例：前端岗位需求下降但客户端岗位变多）。立刻用它修正口径，
  并检查它是否与已有结论冲突。
- **反 AI 味但不要反确定性**：技术文章可以下绝对判断。要改的是节奏，不是语气。

**验收**：每条核心观点都有证据等级、有对最强反驳的回应、矛盾已消除或已给出边界条件
（时间序、适用范围、前提）。

### 2. 观点确认后 → 生成大纲，等用户检查

大纲必须含：

- 标题候选 2–3 个，标出推荐哪个及理由
- 读者定位（泛开发者 / 前端 / 管理者？不要猜，等用户说）
- 章节顺序表：每节写什么、落点是什么、承接哪条观点
- front matter 拟稿（`description`、`tags`、`categories`）
- 篇幅估计
- **明确列出讨论中留下的未解之处**，并标注它落进哪一节

**验收**：用户明确说"可以写"。没说就只改大纲，不许动正文。

### 3. 生成中文版和英文版

**动笔前必须加载 `humanize-writing` skill。**

用户明确抱怨过两点：**"太难懂"** 和 **"一股 AI 味"**。这两条都是验收项。

**可读性是硬约束（对应"太难懂"）：**

- 每节开头先用一两句人话把这一节的问题说出来，再进术语和论证。
- 一个论点后面**紧跟**一句"它意味着什么"或一个具体例子，不要让抽象名词连续堆三句。
- 第一次出现的概念要落地。例：不要只写"验证能力的瓶颈在设计层"，要接着说
  "也就是：AI 忠实实现了一个错的设计，测试一路绿灯，没有任何环节会顶回来"。
- 宁可多写一段具体的，也不要靠读者自己跨越跳跃。
- 交付前通读一遍，只问一个问题：**一个没读过这个讨论的人，能不能顺着读下来。**

**去 AI 味（对应"一股 AI 味"）：**

- 开头用具体场景，不要用宣言。
- 加粗金句每 300 字最多 1 处；表格全文最多 2 张；破折号每 500 字最多 1 处；
  每节结尾不要回扣前文；结尾不要"不是……而是……"式升华。
- 该承认不确定的地方就承认，不要每段都密不透风。
- 写完对照 `humanize-writing` 的自查表数一遍再交付。

**英文版不是直译。** 按英文节奏重写：拆长句、去掉中文式破折号插入语、例子换成英文读者
能直接理解的表达。标题可以意译。

**两个文件，slug 必须完全相同**（Hugo 靠同名路径关联翻译）：

| 语言 | 路径 |
|---|---|
| 中文 | `content/zh/blogs/<slug>.md` |
| 英文 | `content/en/blogs/<slug>.md` |

两边 `date`/`lastmod` 保持一致。

**TOML front matter 的坑（踩过，会让整站构建失败）**：单引号字符串里不能出现 `'`。
`title = 'A Developer's ...'` 会报 `expected newline but got U+0027`，含撇号改用双引号。
写完立刻用 `tomllib` 校验。

### 4. 本地构建验证 → 改完成状态 → push 触发 CI

**顺序不能换。**

**4.1 先补 `data` 清单（最容易漏，漏了发布出去也没人看得见）**

列表页和首页**不读 content**，只读手工清单：

- `layouts/_default/blogs.html` 渲染 `/blogs/` 和 `/zh/blogs/`，读 `site.Data.<lang>.blogs`
- `layouts/index.html` 首页博客区读同一来源，且 `first 3` 只显示最近 3 篇

所以每篇都要在 `data/zh/blogs.toml` 和 `data/en/blogs.toml` 各加一条：

```toml
[[blogs]]
title = "标题"
date = "YYYY-MM-DD"
summary = "一句话摘要（列表页显示）"
tags = ["标签1", "标签2"]
content = """
开场段落。主题模板目前不渲染这个字段，但既有条目都写了，保持一致。
"""
link = "/路径/"
```

**`link` 两种语言写法不同（站点实际行为，不是笔误）：**

| 语言 | 正确 link | 说明 |
|---|---|---|
| 中文 | `/zh/blogs/<slug>/` | 正确 |
| 英文 | `/blogs/<slug>/` | **没有 `/en/` 前缀** |

英文内容实际输出在**根路径**，`/en/blogs/<slug>/` 是 404。`data/en/blogs.toml` 里
`collective-sexual-repression` 那条的 `link` 是坏的（指向 `/en/...`），属于既有问题，
新条目不要跟着学。

**4.2 本地构建验证（强制）**

主题 submodule 默认未检出，`/tmp` 跨调用会消失，所以这一整套要在**同一次 shell 调用**
里跑完：

```bash
cd /data/workspace/site.backup
git submodule update --init themes/hugo-noir   # 若 themes/hugo-noir 为空
mkdir -p .theme-check/bin
curl -sSL -o .theme-check/hugo.tgz \
  "https://github.com/gohugoio/hugo/releases/download/v0.147.0/hugo_extended_0.147.0_linux-amd64.tar.gz"
tar xzf .theme-check/hugo.tgz -C .theme-check/bin hugo

# 与 CI 完全相同的参数
.theme-check/bin/hugo --gc --minify --logLevel warn --destination .theme-check/public
```

必须逐项确认（任何一项不符都**不要 push**）：

```bash
# 两篇文章页都产出（注意英文在根路径）
ls .theme-check/public/blogs/<slug>/index.html
ls .theme-check/public/zh/blogs/<slug>/index.html
# 两个列表页 + 两个首页都含新文章
grep -c "<slug>" .theme-check/public/blogs/index.html .theme-check/public/zh/blogs/index.html
grep -c "<slug>" .theme-check/public/index.html       .theme-check/public/zh/index.html
```

构建输出里的 `WARN ... No <x> data found for language` 是站点既有的，可忽略。
出现 `Error:` 一律不可忽略。

**4.3 改状态**：两个语言文件 `draft = true` → `false`，`date`/`lastmod` 改成当前时间，
两边一致。

**4.4 提交并 push。** 提交信息用 `feat(content):` / `fix(content):` 前缀，
正文写清做了什么、验证了什么。

push 若报 `Bad owner or permissions on /etc/ssh/ssh_config.d/...`（本机 `/etc/ssh`
属主被改成了 `nobody`，SSH 拒绝加载系统配置），用空配置绕开，**不要改系统文件**：

```bash
cd /data/workspace/site.backup
CFG=$(mktemp); : > "$CFG"
GIT_SSH_COMMAND="ssh -F $CFG -i $HOME/.ssh/id_rsa_github -o IdentitiesOnly=yes" \
  git push origin main
```

`CFG` 必须在同一次 shell 调用里创建。

**4.5 清理** `rm -rf .theme-check`，不要留未跟踪的临时目录。

### 5. 跟进部署，不要假设成功

push 到 `main` 会触发 `.github/workflows/hugo-deploy.yml`：构建 → 上传 artifact →
按 `deploy/hosts.json` 逐台 rsync。

**5.1 看 CI**（无需 gh CLI，公开仓库匿名可查）：

```bash
curl -sS "https://api.github.com/repos/bhzhangsun/site.backup/actions/runs?per_page=1"
curl -sS "https://api.github.com/repos/bhzhangsun/site.backup/actions/runs/<run_id>/jobs"
```

**5.2 逐台核验线上**。域名有两个 IPv4 加一个 IPv6，用 `--resolve` 指定某一台，
**不要只查一个 URL**：

```bash
curl -sS -o /dev/null -w "%{http_code}\n" -L https://nestseeker.xyz/blogs/<slug>/
curl -sS -o /dev/null -w "%{http_code}\n" -L https://nestseeker.xyz/zh/blogs/<slug>/
curl -sS -L https://nestseeker.xyz/blogs/        | grep -c "<slug>"
curl -sS -L https://nestseeker.xyz/zh/blogs/     | grep -c "<slug>"
curl -sS -L https://nestseeker.xyz/              | grep -c "<slug>"
curl -sS -L https://nestseeker.xyz/zh/           | grep -c "<slug>"
curl -sS -L https://nestseeker.xyz/en/sitemap.xml | grep -c "<slug>"
curl -sS -L https://nestseeker.xyz/zh/sitemap.xml | grep -c "<slug>"
# 每台单独验：--resolve nestseeker.xyz:443:<ip> https://...
```

**5.3 如实报告。** CI 红了就说红，某台没更新就说没更新。不要因为文章能打开就宣布发布成功。

---

## 硬约束

1. 第 1、2 步没走完，不许写正文。
2. 本地构建验证没过，不许 push。
3. **不许为了让 CI 变绿而往 `deploy/known_hosts` 塞未经验证的公钥。**
4. 不要动 `deploy/` 下的服务器脚本和 `hugo.toml` 的多语言配置，除非用户明确要求。
5. 作者署名默认 `Diogo Ferro`（`hugo.toml` 的 `params.name`），不要自行改。

---

## 已知的既存问题（不是本次引入的，也不要顺手改）

- **`Deploy to my-vps` 长期失败**，卡在 `Verify live host key vs known_hosts`。
  实测 `ssh-keyscan 45.134.36.142:22` 被服务器关闭连接（`uk-vps:24743` 正常），
  说明那台机器主机密钥轮换了。现在两台 VPS 仍能收到内容，但将来可能只更新一台。
  需要用户确认后处理，不许绕过。
- **hreflang 全站失效**：`layouts/_default/baseof.html` 的 `{{ if .IsTranslated }}`
  对任何页面都没成立过，既有文章也没有。
- **`description` / `canonical` 标签未渲染**（提交 `49db149` 声称加了，实际没有）。
- **英文内容输出在根路径**，`/en/blogs/...` 是 404，`/en/` 下只有跳转别名页。
- `data/en/blogs.toml` 中 `collective-sexual-repression` 的 `link` 指向 `/en/...`，是坏的。
- `hugo.toml` 里 `defaultContentLanguageInSubdir = true` 与 `languageCode = 'en-us'`
  的组合，与「英文输出在根路径」的实际行为存在矛盾，未查明。

---

## 环境备忘

- 仓库 `git@github.com:bhzhangsun/site.backup.git`，分支 `main`
- 部署目标 `deploy/hosts.json`：`my-vps`、`uk-vps`，rsync 到 `/var/www/nestseeker.xyz`
- CI 用的 Hugo：**0.147.0 extended**，本地验证必须同版本
- 主题 `themes/hugo-noir`（submodule，pin 见 `git submodule status`）
- 本机没有 `hugo`、没有 `gh`，需要时即时下载
- `.theme-check/`、`public/`、`resources/` 不要提交
