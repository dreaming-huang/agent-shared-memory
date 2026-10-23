---
type: event
tags: [demo, cli, pitfall, windows]
links: [../SUMMARY.md]
created: 2026-02-12 18:00
modified: 2026-02-12 18:00
source_agent: Grok
device: workstation
domain: demo
project: acme-cli
---

# 2026-02-12 18:00 · Grok

- 做了什么：记录踩坑——Windows PowerShell 用 `>` / `Out-File` 重定向脚本再 `ssh … bash` 时，文件常为 UTF-16，远端报 `$'\r': command not found` 或奇怪的语法错误。
- 位置：workstation → SSH Host 别名 `jump-a` / `server-a`（占位符）。
- 结果：约定改用 `cmd /c type script.sh | ssh server-a 'bash -s'`，或 `Out-File -Encoding utf8NoBOM`；已写入 SUMMARY「坑」。
