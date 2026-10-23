# memory_inbox — 服务器收件箱说明模板

把本文件复制到每台远程服务器主机的 `$MEMORY_INBOX/`（目录名可自定，与 `config.env` 一致即可）。

## 给 server agent / 服务器 agent 的短说明

1. **先读**镜像里的 `AGENTS.md` + `SERVER.md`（路径：`$MIRROR_ROOT`）。
2. **只在本目录新建** `YYYY-MM-DD_HHMM_简短描述.md`（一事一文件）。
3. **不要**修改本 README；**不要**写入或删除 `done/`（由 collector 在 push 成功后移动）。
4. **不要**在 `$MIRROR_ROOT` 里 commit / push。
5. **永不**写入 token、密码、私钥、cookie。

## 推荐目录

```
$MEMORY_INBOX/
  README.md          # 本文件
  done/              # collector 已入库的归档（可空）
  YYYY-MM-DD_….md    # 待收取
```

## frontmatter 最小集

```yaml
---
type: event
tags: []
links: []
created: YYYY-MM-DD HH:MM
modified: YYYY-MM-DD HH:MM
source_agent: Cursor|Codex|Grok|other
device: server-a|server-b|server-workstation
domain: 待定
project: ""
---
```
