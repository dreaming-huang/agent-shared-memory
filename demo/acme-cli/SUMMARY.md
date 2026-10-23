---
type: summary
tags: [demo, showcase, cli]
links:
  - events/2026-02-10_1430_choose-json-flag.md
  - events/2026-02-11_0915_server-cache-path.md
  - events/2026-02-12_1800_powershell-utf16-pitfall.md
  - events/2026-02-13_1100_tag-release-policy.md
created: 2026-02-10 14:30
modified: 2026-02-13 11:00
source_agent: collector
device: workstation
---

# acme-cli（demo · 使用后的记忆效果）

> 虚构项目。演示工作站 writer + server-a 跨端写记忆几天后，SUMMARY 里应有的「结论 / 关键路径 / 坑」。无真实业务数据。

## 现状

虚构 CLI 工具 `acme-cli`：本地开发在 workstation，发布构建与缓存跑在 `server-a`。入口已定，`--json` 默认关闭，Windows 管道踩坑已记录，发版策略锁定为 `v*` tag。

## 结论（每条链接来源事件）

- CLI 入口为 `cmd/acme/main.go`；对外子命令 `acme run|status|version`（见 [events/2026-02-10_1430_choose-json-flag.md](events/2026-02-10_1430_choose-json-flag.md)）。
- 机器可读输出用 `--json`，**默认 off**（人读 stdout；脚本显式加 flag）（同上）。
- 服务器构建缓存放在 `$DATA_ROOT/acme-cli/cache`，勿写进仓库或 `$HOME/tmp`（见 [events/2026-02-11_0915_server-cache-path.md](events/2026-02-11_0915_server-cache-path.md)）。
- Windows PowerShell 重定向会把脚本变成 UTF-16；经 SSH 传 shell 时改用 `cmd /c type` 或显式 UTF-8（见 [events/2026-02-12_1800_powershell-utf16-pitfall.md](events/2026-02-12_1800_powershell-utf16-pitfall.md)）。
- 正式发布只打 `v*` tag（如 `v1.2.0`）；`main` tip 与 `rc-*` 不算 release（见 [events/2026-02-13_1100_tag-release-policy.md](events/2026-02-13_1100_tag-release-policy.md)）。

## 关键路径

- CLI 入口 · `$REPO_ROOT/cmd/acme/main.go` · `go run ./cmd/acme …` 本地试跑
- 服务器构建缓存 · `$DATA_ROOT/acme-cli/cache` · server-a 上 CI / 手工 build 共用
- 发布产物目录 · `$DATA_ROOT/acme-cli/dist` · 仅由 `v*` tag 流水线写入
- 配置模板 · `$SHARED_MEMORY_ROOT/config.example.env` · 本记忆仓库占位符（与业务无关）

## 坑

- PowerShell `>` / `Out-File` 默认 UTF-16 → 远端 `bash` 报 `$'\r': command not found` 或乱码；改用 `cmd /c type file.sh | ssh server-a 'bash -s'`，或 `Out-File -Encoding utf8NoBOM`。
- 把 build cache 放在仓库 `./.cache` 会被 `git clean` / 多 agent 互踩；统一 `$DATA_ROOT/acme-cli/cache`。
- 误把 `--json` 设成默认 on 会破坏人类可读日志与现有脚本；保持默认 off。

## 下一步

- 补 `acme completion`（bash/zsh）并写一条 event。
- 评估是否把 dist 校验和写入 `_facts/`（跨项目复用时再迁）。

## 当前状态

虚构 demo 已「成熟」：跨 workstation + server-a 的决定与踩坑可被新 agent 经「读共享记忆」继承。可安全公开。
