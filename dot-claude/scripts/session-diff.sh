#!/usr/bin/env bash
# /session-diff の実装。
# SessionStart hook が記録した base SHA からの累積 diff を hunk で開く。
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$repo_root" ]]; then
  echo "not in a git repo. /session-diff needs a git repo." >&2
  exit 1
fi

repo_hash=$(printf '%s' "$repo_root" | shasum -a 256 | cut -c1-16)
base_file="$HOME/.claude/tmp/session-base/$repo_hash"
if [[ ! -f "$base_file" ]]; then
  echo "no session base recorded for $repo_root" >&2
  echo "restart Claude Code session to record one, or set manually:" >&2
  echo "  git rev-parse HEAD > $base_file" >&2
  exit 1
fi

base=$(cat "$base_file")

if hunk session get --repo "$repo_root" >/dev/null 2>&1; then
  hunk session reload --repo "$repo_root" -- diff "$base"
  echo "reloaded hunk session: diff $base"
else
  cat <<EOF
no live hunk session for this repo. run in another terminal:

    cd $repo_root
    hunk diff $base --watch
EOF
fi
