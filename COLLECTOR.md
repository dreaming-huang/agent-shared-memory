---
type: reference
tags: [rules, collector]
links: [AGENTS.md, SERVER.md]
created: 2026-01-01 12:00
modified: 2026-01-01 12:00
source_agent: template
device: workstation
---

# 收取流程 / Collector Playbook

在 **workstation**（或你指定的 collector 主机）上运行。主机与路径全部使用占位符 / 环境变量（见 `config.example.env`）。

## 何时 / 从哪 · When & where

- 建议每小时第 **47** 分定时收取（服务器镜像 pull 建议第 **17** 分）；用户说「收记忆」/ *collect memory* 时也收。
- 写入侧配对：各 bot 每小时第 **35** 分巡检，有新的持久结论 / 决定 / 踩坑 / 关键路径才写收件箱（workstation `_inbox/` 或服务器 `$MEMORY_INBOX_*`），无新内容不写、不 commit/push；工作刚完成时也可立刻写。
- 来源：
  - `$MEMORY_INBOX_A`（`gpu-cluster-a`，经 `SSH_HOST_A`，例：`ssh jump-a`）
  - `$MEMORY_INBOX_B`（`gpu-cluster-b`，经 `SSH_HOST_B`）
  - `$MEMORY_INBOX_W`（`gpu-workstation`，经 `SSH_HOST_W`）
  - 以及仓库根 `_inbox/`
  - 只取新 `.md`，排除 `README.md` 与 `done/`
- SSH：只用 `~/.ssh/config` 里的 **Host 别名**（如 `jump-a`、`gpu-cluster-b`、`gpu-workstation`）。文档与脚本中**不要**写真实 IP。

## 步骤 / Steps

1. 在 `$SHARED_MEMORY_ROOT`：`git pull --rebase`。
2. 拉取各服务器 inbox 新文件（含非 ASCII 文件名时可用 base64 中转，避免乱码）。
3. **先整理再推送（降噪）**：
   - 去掉过程记录和临时状态（PID、ETA、进度）；
   - 合并重复（含与已有事件重复）；
   - 按领域 / 项目归档到 `events/`，不明确的放 `_inbox/` 并标 `domain: 待定`；
   - 结论和关键路径并入对应 `SUMMARY.md` 并加 links；
   - 与已有记忆核对矛盾，过时项标 `superseded_by`；
   - 更新 `MEMORY.md`。
4. `git commit -m "collector: …"` 并 `git push`。
5. **仅在 push 成功后**，把服务器原文件移到该机 `memory_inbox/done/`。
6. **通知策略**：只在有 `domain: 待定` 条目或某服务器不可达时通知用户；否则静默。

参考示例脚本：[scripts/collect.example.sh](scripts/collect.example.sh)。

## 两步整理 / Two-step curation

### ① 琐碎汇总（定期） · Trivial-event consolidation

- **inbox 可以保持凌乱**：不必为了整齐而频繁清空 `_inbox/` 或逐条催收。
- **定期汇总**：把琐碎 / 过程性 event（进度、冒烟、重复状态、已无增量信息的流水）consolidate 进对应项目的 `SUMMARY.md`（必要时 `_facts/`）；提炼持久结论与关键路径，去掉过程噪声。
- **过时结论**：旧结论标 `superseded_by` / `valid_until`；**不要删除** event 文件（`events/` 只增不删）。
- **例行时间建议**：每周一本地时区上午（可自行设 routine）；也可在用户点名或 inbox/events 明显堆积时提前做。

### ② 周报（可选） · Weekly digest

- 在琐碎汇总之后（或单独触发），生成一份**周报**（可放 `_inbox/` 或 `demo/` 外自建的 `digests/YYYY-Www.md`，公开模板不含私人 digest）：
  - 本周新增 / 变更的项目与关键结论（各 1～3 条）；
  - 关键路径变更；
  - 未归类（`domain: 待定`）与阻塞项；
  - 下一周建议关注点。
- 周报面向**人**阅读；不要把密钥、内网 IP、私人账号写进周报。
- 通知：周报默认只在用户要求「出周报」或 routine 配置为「发送」时推送；否则只写入仓库。

## 镜像自拉取 / Mirror self-pull

各 GPU 主机的 `$MIRROR_ROOT_*` 应自行配置远程凭据（机器本地，**勿**写入本仓库）与 cron（如每小时第 17 分 `git pull --ff-only`）。collector **不必**再 bundle 推送到镜像。保持镜像工作区可写（否则 pull 可能失败）；不要额外改成整树只读除非你有其它同步方案。

## 改规则 / Changing rules

只改本仓库的 `AGENTS.md` / `SERVER.md` / `COLLECTOR.md` 并 push；各机镜像一小时内自动同步。服务器上的短指针（如 `.cursor/rules/shared-memory.mdc`、`memory_inbox/README.md`）只指向镜像里的 SERVER.md，一般无需改。
