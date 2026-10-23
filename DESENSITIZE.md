# DESENSITIZE.md — 贡献前脱敏检查清单

在向**公开** fork / PR 提交前，跑完本清单。私人记忆仓库可以保留真实路径，但**不要**把它们同步进本 OSS 模板。

## 禁止出现 / Must not appear

| 类别 | 示例（应替换为） |
|------|------------------|
| 人名 / GitHub / 账号 | → `YOUR_GITHUB_USER` / `yourname` |
| 主机别名 / 集群名 | → `workstation` / `server-a` / `server-b` / `server-workstation` / `jump-a` |
| 绝对路径（盘符、集群 FS、家目录用户段） | → `$SHARED_MEMORY_ROOT` / `$MEMORY_INBOX` / `$MIRROR_ROOT` |
| IP、内网域名、跳板原文 | → SSH `Host` 别名占位符 |
| Token、密码、私钥、`.git-credentials`、cookie | → **删除**；改用本地 secret store |
| 真实项目名与研究结论 | → 虚构 `demo/hello-memory` / `demo/acme-cli` 或通用占位 |

## 提交前命令 / Pre-commit scan

1. 维护一份**仅存在于本机**的拒绝列表文件（勿提交），例如 `~/.config/shared-memory/deny-patterns.txt`，一行一个私有词根（账号、旧主机名、集群 FS 前缀、真实项目名等）。
2. 在仓库根扫描：

```bash
DENY="$HOME/.config/shared-memory/deny-patterns.txt"
# Should print nothing
if [ -f "$DENY" ]; then
  while IFS= read -r pat; do
    [ -z "$pat" ] || [ "${pat#\#}" != "$pat" ] && continue
    rg -n -i -- "$pat" . && echo "HIT: $pat"
  done < "$DENY"
fi

# Generic sweeps (safe to keep in-repo)
rg -n -i 'token|api[_-]?key|password|private[_-]?key|BEGIN OPENSSH|BEGIN RSA' || true
rg -n --regexp='([0-9]{1,3}\.){3}[0-9]{1,3}' || true
rg -n --regexp='[A-Za-z]:\\|/home/[^/[:space:]]+/' || true
```

若有命中：**先改成占位符或删除，再 commit**。不要把私人拒绝列表里的词写进本 OSS 仓库（包括本清单）。

## 文件级检查

- [ ] `config.env` / `.env` / 私钥 **未**加入版本库（见 `.gitignore`）
- [ ] `MEMORY.md` 与 `events/` 无真实业务结论（模板仅保留 demo）
- [ ] `COLLECTOR.md` / `SERVER.md` / 脚本中的 SSH 仅为 Host 别名占位符
- [ ] `LICENSE` 版权行使用 `YOUR_GITHUB_USER` 或你的公开名（自愿）
- [ ] README 架构图无内网拓扑细节

## 发现误提交时

1. 立刻轮换可能泄露的凭据（视为已泄露）。
2. 从 git 历史中清除敏感文件（`git filter-repo` / BFG）；强制推送仅限你拥有且确认无他人依赖的仓库。
3. 在 DESENSITIZE 清单补一条回归用例，避免再犯。

## 给 reviewer

PR 描述里写明：「已跑 DESENSITIZE.md 扫描，无命中。」Reviewer 抽查 `config.example.env`、`scripts/`、`SERVER.md`、`COLLECTOR.md` 即可。
