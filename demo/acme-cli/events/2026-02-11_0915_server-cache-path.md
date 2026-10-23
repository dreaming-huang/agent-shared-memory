---
type: event
tags: [demo, cli, path]
links: [../SUMMARY.md]
created: 2026-02-11 09:15
modified: 2026-02-11 09:15
source_agent: Codex
device: server-a
domain: demo
project: acme-cli
---

# 2026-02-11 09:15 · Codex

- 做了什么：在 server-a 上选定构建缓存目录为 `$DATA_ROOT/acme-cli/cache`；发布产物目录 `$DATA_ROOT/acme-cli/dist`。禁止把 cache 放进仓库 `./.cache` 或 `$HOME/tmp`（多 agent / `git clean` 会互踩或丢缓存）。
- 位置：server-a 收件箱 → 经 collector 归档到本 events/。
- 结果：SUMMARY「关键路径」更新；CI 与手工 `go build` 共用同一 cache 根。
