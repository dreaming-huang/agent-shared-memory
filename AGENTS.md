---
type: reference
tags: [rules]
links: [MEMORY.md, SERVER.md, COLLECTOR.md]
created: 2026-01-01 12:00
modified: 2026-01-01 12:00
source_agent: template
device: workstation
---

# 共享记忆通用规则 / Shared Memory — Agent Rules

（Cursor / Codex / Grok / 其他 agent 通用）

规则只在本仓库维护：**服务器上的 agent 再读 [SERVER.md](SERVER.md)；收取记忆的 agent 再读 [COLLECTOR.md](COLLECTOR.md)。**

## 读（按需） / Read (on demand)

只有用户说「读共享记忆」/「看共享记忆」/ *read shared memory* 时才读，严格按顺序：

1. 先读 `MEMORY.md` 总索引，判断哪些领域 / 项目 / `_facts` 相关；
2. 只进相关文件夹读 `SUMMARY.md`（或 `_facts/*.md`）；
3. 需要细节时才开 `events/`。

**不要**遍历或全量读取仓库。

## 写（默认） / Write (default)

不用等用户说：得出结论、做了决定、踩坑、环境/配置变化、阶段完成或产生关键路径时**主动写**。

- **要记**：结论/数字、决定、踩坑及原因、环境/配置变化、阶段完成、**关键路径**（结果、环境、权重、数据在哪、怎么启动），写成「东西 · 路径 · 一句说明」，放进事件并并入项目 SUMMARY「关键路径」。多项目共用路径（conda、缓存、代理）放 `_facts/`。
- **不记**：试跑、调参过程、临时状态（PID、ETA、进度、在跑任务）、临时目录和中间日志；**token / 密码 / 密钥永不存**。
- 判断标准：一个月后换个 agent 接手，没有这条会不会走弯路？一句话：**过程不记，结论和路径要记。**
- 定时建议：每个 bot 每小时第 35 分巡检一次近期结论，有新的才写（写收件箱的不 commit/push；与已有 inbox / 已归档事件重复则不写）；收取者在第 47 分收取整理（见 COLLECTOR.md）。

## 工作站怎么写 / Workstation write path

（仓库写入端，路径用 `$SHARED_MEMORY_ROOT`）

1. `git pull --rebase`
2. 新建事件 `<领域>/<项目>/events/YYYY-MM-DD_HHMM_简短描述.md`（本地时区）
3. 更新 `MEMORY.md` 该项目一行（现状 / tags；新项目加一行）；按需更新项目 `SUMMARY.md`
4. `git commit -m "<工具>: <描述>"`（Cursor / Codex / Grok / …）
5. `git push`；冲突就 `git pull --rebase` 后重推

服务器上**不写仓库**，见 SERVER.md。不要把本仓库放进工作项目目录（避免被工具自动加载）。

## 结构 / Layout

- `MEMORY.md` 总索引：`- [领域/项目](path/SUMMARY.md) — 一句话现状 · tags: a, b`，建议保持约 200 行内。
- `_facts/` 稳定事实，原地修改；过时加 `superseded_by` / `valid_until`，不删除。
- `<领域>/<项目>/SUMMARY.md` 可重写：现状 / 结论（链接来源事件）/ 关键路径 / 坑 / 下一步 / 当前状态。
- `<领域>/<项目>/events/` **不可变**，一事一文件；旧事件不改，新结论推翻旧结论时在 SUMMARY / `_facts` 标 `superseded_by`。
- `_inbox/`：领域待定的条目。跨领域内容只存一次（放主项目），别处用 tags / links 引用。

## 领域 / 项目 / Domains & projects

- 平时只能在已有领域下新建项目（建 `SUMMARY.md` 并在 MEMORY.md 加一行）；都不合适写到 `_inbox/`（服务器写到 `$MEMORY_INBOX`），`domain: 待定`。
- 只有用户要求「整理记忆」并开新领域时，被叫来的 agent（任何工具）才新建领域：建 `SUMMARY.md`、MEMORY.md 加一行，移动用 `git mv` 并修正链接。
- 「整理记忆」：把 `_inbox/` 归类，新事件合并进 SUMMARY / `_facts/`，检查矛盾；同一时间只在一台设备上整理。
- **项目别名（示例）**：`hello` = `hello-memory` → `demo/hello-memory/`（`domain: demo`）。按需在本地维护自己的别名表，勿把私人项目名提交到公开 fork。

## Frontmatter 模板

每个文件开头必须有：

```yaml
---
type: fact|event|summary|feedback|reference
tags: [a, b]
links: [相对路径]
created: YYYY-MM-DD HH:MM
modified: YYYY-MM-DD HH:MM
source_agent: Cursor|Codex|Grok|other
device: workstation|laptop|gpu-cluster-a|gpu-cluster-b|gpu-workstation|...
# 仅事实可选: superseded_by: 路径 / valid_until: YYYY-MM-DD
---
```

## 事件模板 / Event template

```markdown
---
type: event
tags: []
links: [../SUMMARY.md]
created: YYYY-MM-DD HH:MM
modified: YYYY-MM-DD HH:MM
source_agent: Cursor
device: workstation
---

# YYYY-MM-DD HH:MM · 工具名
- 做了什么：
- 位置：
- 结果：
```

## SUMMARY 模板

```markdown
---
type: summary
tags: []
links: [events/...]
created: YYYY-MM-DD HH:MM
modified: YYYY-MM-DD HH:MM
source_agent: Cursor
device: workstation
---

# 项目名
## 现状
## 结论（每条链接来源事件）
## 关键路径
- 东西 · 路径 · 一句说明
## 坑
## 下一步
## 当前状态
```
