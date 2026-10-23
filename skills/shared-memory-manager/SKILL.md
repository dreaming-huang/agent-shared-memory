---
name: shared-memory-manager
description: >-
  Read, write, collect, organize, or weekly-digest a Git-backed cross-host shared
  memory for Cursor / Grok / other agents. Use when the user says 读共享记忆 /
  写共享记忆 / 收记忆 / 整理记忆 / 出周报, or when durable conclusions, decisions,
  pitfalls, or key paths should be persisted across machines. Generic paths only
  ($SHARED_MEMORY_ROOT, $MEMORY_INBOX, $MIRROR_ROOT); never private hostnames.
---

# Shared Memory Manager

## When to use

- User: 「读共享记忆」「写共享记忆」「收记忆」「整理记忆」「出周报」
- You produced a durable conclusion, decision, pitfall, env change, or key path
- You are the **collector** on the workstation and it is time to pull server inboxes

Do **not** use for ephemeral logs, PIDs, ETA, or secrets.

## Read discipline

Only when asked to read shared memory:

1. `$SHARED_MEMORY_ROOT/MEMORY.md` (or `$MIRROR_ROOT/MEMORY.md` on servers)
2. Relevant `SUMMARY.md` / `_facts/*.md` only
3. `events/` only if detail is needed

Never full-scan the repo.

## Write discipline

- **Record**: conclusions, decisions, pitfalls + why, env/config changes, milestones, key paths as `thing · path · one-line`
- **Skip**: trial runs, tuning process, temp state; **never** tokens/passwords/keys
- Workstation: pull → new event under `domain/project/events/` → update SUMMARY + MEMORY line → commit → push
- Server: **inbox only** (`$MEMORY_INBOX/YYYY-MM-DD_HHMM_desc.md`); no git write on mirror

Prefer AGENTS.md / SERVER.md in the memory repo over inventing new structure.

## Collect (collector host)

1. `git pull --rebase` in `$SHARED_MEMORY_ROOT`
2. Fetch new `.md` from each `$MEMORY_INBOX_*` via SSH Host aliases in config (exclude README / `done/`)
3. Denoise → archive to `events/` → merge into SUMMARY / `_facts` → update MEMORY
4. Commit + push; **then** move remote files to `done/`
5. Notify only on `domain: 待定` or unreachable hosts

See COLLECTOR.md and `scripts/collect.example.sh`.

## Organize / 琐碎汇总

- Consolidate trivial / process events into SUMMARY; mark superseded facts; never delete `events/`
- Clear `_inbox/` only when classifying; same moment → one device only

## Weekly digest / 周报

After consolidation (or on request), write a short human-facing digest: new conclusions, key-path changes, pending domains, next focus. No secrets / IPs / private accounts. Send only if the user or routine asks.

## Safety

- Load paths from `config.env` (gitignored); never hardcode real hosts in skill edits you commit upstream
- Run DESENSITIZE.md checks before any public push
