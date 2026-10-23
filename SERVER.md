---
type: reference
tags: [rules, server]
links: [AGENTS.md]
created: 2026-01-01 12:00
modified: 2026-02-13 12:00
source_agent: template
device: workstation
---

# 服务器 agent 规则 / Server Agent Rules

> **Template note** · This file uses placeholder host aliases (`server-a`, `server-b`, `server-workstation`, `jump-a`) and env vars only. Fill **your** paths in local `config.env` and tell your server agents to follow this file — see the **This is a TEMPLATE** section in [README.md](README.md).
>
> **模板说明** · 本文仅含主机别名占位符与环境变量。请在本地 `config.env` 填入真实路径，并让你的 **server agent / 服务器 agent** 遵守本文件——详见 [README.md](README.md) 顶部的「这是一份模板」。

先读通用规则 [AGENTS.md](AGENTS.md)（记什么 / 不记什么、默认写、按需读、领域与别名）。本文件只写**服务器特有**部分。

路径一律用环境变量或占位符；在 `config.env`（由 `config.example.env` 复制）中填写真实值，**不要**把真实绝对路径或主机名写回本文件后公开发布。

## 只读镜像 / Read-only mirror

| 主机占位符 | 镜像路径示例 |
|------------|--------------|
| `server-a` | `$MIRROR_ROOT_A` （例：`$DATA_ROOT/shared-memory`） |
| `server-b` | `$MIRROR_ROOT_B` （例：`$SHARE_ROOT/shared-memory`，常为 `$MEMORY_INBOX_B/../shared-memory`） |
| `server-workstation` | `$MIRROR_ROOT_W` （例：`$HOME/shared-memory`） |

- 各机用 cron（或等价调度）每小时 `git pull --ff-only` 从远程同步。
- **禁止**在镜像里修改、commit、push；也不要执行 `git pull` 以外的 git 命令。
- 读记忆按 AGENTS.md 的读取顺序，**仅在用户说「读共享记忆」时**。

## 写记忆 = 写收件箱 / Write = inbox only

| 主机占位符 | 收件箱路径示例 |
|------------|----------------|
| `server-a` | `$MEMORY_INBOX_A`（跳板机路径；容器内可能是 `$MEMORY_INBOX_A_IN_POD`，与跳板机为同一挂载） |
| `server-b` | `$MEMORY_INBOX_B` |
| `server-workstation` | `$MEMORY_INBOX_W` |

规则：

- 一件事一个新 `.md`，不要追加到已有文件。
- 不要改 `memory_inbox/README.md`，不要碰 `memory_inbox/done/`。
- 文件名：`YYYY-MM-DD_HHMM_简短描述.md`（本地时区）。
- frontmatter：`type: event`、`tags`、`links`、`created`、`modified`、`source_agent`、`device`、`domain`、`project`；正文「做了什么 / 位置 / 结果」，关键路径写成「东西 · 路径 · 一句说明」。
- `domain` 只用 MEMORY.md 里已有领域；不合适写 `domain: 待定`，不要自建领域。
- 写完即可；collector 会收取并推送（见 COLLECTOR.md）。

## 环境变量示例（勿提交真实值）

```bash
export SHARED_MEMORY_ROOT="$HOME/shared-memory"          # workstation checkout
export MIRROR_ROOT_A="/data/shared-memory"               # server-a mirror
export MEMORY_INBOX_A="/data/memory_inbox"
export MEMORY_INBOX_A_IN_POD="/mnt/group/memory_inbox"   # same FS inside pod
export MIRROR_ROOT_B="/share/shared-memory"
export MEMORY_INBOX_B="/share/memory_inbox"
export MIRROR_ROOT_W="$HOME/shared-memory"
export MEMORY_INBOX_W="$HOME/memory_inbox"
```
