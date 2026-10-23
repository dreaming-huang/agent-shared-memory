---
type: event
tags: [demo, cli, decision, release]
links: [../SUMMARY.md]
created: 2026-02-13 11:00
modified: 2026-02-13 11:00
source_agent: Cursor
device: workstation
domain: demo
project: acme-cli
---

# 2026-02-13 11:00 · Cursor

- 做了什么：决定正式发布只认 git tag `v*`（例：`v1.2.0`）。`main` 尖端与 `rc-*` 分支/标签不算 release，不写入 `$DATA_ROOT/acme-cli/dist`。
- 位置：workstation；与 server-a 上 tag 触发的构建流水线对齐。
- 结果：SUMMARY「结论」与「关键路径·发布产物目录」已对齐；新 agent 不应把 tip commit 当正式版分发。
