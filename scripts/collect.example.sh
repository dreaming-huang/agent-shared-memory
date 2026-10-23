#!/usr/bin/env bash
# collect.example.sh — EXAMPLE collector sketch (not production-ready).
# 示例收取脚本：替换占位符后自测；不要把真实 Host / 路径提交回公开模板。
#
# Usage:
#   cp config.example.env config.env   # edit locally
#   set -a; source ./config.env; set +a
#   bash scripts/collect.example.sh
#
set -euo pipefail

: "${SHARED_MEMORY_ROOT:?set SHARED_MEMORY_ROOT in config.env}"
: "${SSH_HOST_A:=jump-a}"
: "${SSH_HOST_B:=gpu-cluster-b}"
: "${SSH_HOST_W:=gpu-workstation}"
: "${MEMORY_INBOX_A:=/data/memory_inbox}"
: "${MEMORY_INBOX_B:=/share/memory_inbox}"
: "${MEMORY_INBOX_W:=$HOME/memory_inbox}"

STAGING="${SHARED_MEMORY_ROOT}/.collect-staging"
mkdir -p "$STAGING"

echo "==> 1. git pull --rebase in \$SHARED_MEMORY_ROOT"
git -C "$SHARED_MEMORY_ROOT" pull --rebase

fetch_inbox() {
  local host="$1" remote_dir="$2" label="$3"
  local dest="$STAGING/$label"
  mkdir -p "$dest"
  echo "==> 2. fetch inbox from $host:$remote_dir → $dest"
  # NOTE: replace with your preferred transfer. For non-ASCII names, consider
  # listing remotely and base64-encoding filenames before scp/rsync.
  # Example (pseudo):
  #   ssh "$host" "ls -1 '$remote_dir'/*.md 2>/dev/null | grep -v README" \
  #     | while read -r f; do scp "$host:$f" "$dest/"; done
  echo "    (example only — implement scp/rsync/base64 transfer here)"
}

fetch_inbox "$SSH_HOST_A" "$MEMORY_INBOX_A" "gpu-cluster-a"
fetch_inbox "$SSH_HOST_B" "$MEMORY_INBOX_B" "gpu-cluster-b"
fetch_inbox "$SSH_HOST_W" "$MEMORY_INBOX_W" "gpu-workstation"

echo "==> 3. organize (human/agent step — NOT automated here)"
echo "    - denoise: drop PID/ETA/progress noise"
echo "    - archive into domain/project/events/"
echo "    - merge conclusions into SUMMARY.md / _facts/"
echo "    - update MEMORY.md"
echo "    - leave unclear items in _inbox/ with domain: 待定"

echo "==> 4. commit + push (only after organize)"
echo "    git -C \"\$SHARED_MEMORY_ROOT\" add -A"
echo "    git -C \"\$SHARED_MEMORY_ROOT\" commit -m \"collector: inbox $(date +%Y-%m-%d)\""
echo "    git -C \"\$SHARED_MEMORY_ROOT\" push"

echo "==> 5. AFTER successful push: move remote files to done/"
echo "    ssh \$SSH_HOST_* \"mkdir -p \$MEMORY_INBOX_*/done && mv … done/\""

echo "==> 6. notify only if domain 待定 or host unreachable (else silent)"
echo "Done (example sketch)."
