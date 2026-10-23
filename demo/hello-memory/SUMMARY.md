---
type: summary
tags: [demo, template]
links: [events/2026-01-01_1200_example-event.md]
created: 2026-01-01 12:00
modified: 2026-01-01 12:00
source_agent: template
device: workstation
---

# hello-memory（demo）

## 现状

虚构示例项目，用于演示共享记忆的 SUMMARY / events 写法。无真实业务含义。

## 结论（每条链接来源事件）

- 问候语约定为 `hello, shared memory`（见 [events/2026-01-01_1200_example-event.md](events/2026-01-01_1200_example-event.md)）。

## 关键路径

- 示例脚本 · `$SHARED_MEMORY_ROOT/demo/hello-memory/` · 仅作路径写法示范
- 配置模板 · `$SHARED_MEMORY_ROOT/config.example.env` · 复制为本地 `config.env`

## 坑

- 误把真实密钥写进 event → 用 DESENSITIZE.md 检查清单拦住。

## 下一步

- 克隆模板后替换为本机真实领域；删除或归档本 demo。

## 当前状态

模板就绪，可安全公开。
