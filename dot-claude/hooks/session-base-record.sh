#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Records HEAD SHA at session startup so /session-diff can show cumulative diff.
set -euo pipefail

payload=$(cat)
source_kind=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"source"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)

if [[ "$source_kind" != "startup" && -n "$source_kind" ]]; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$repo_root" ]]; then
  exit 0
fi

head_sha=$(git rev-parse HEAD 2>/dev/null || true)
if [[ -z "$head_sha" ]]; then
  exit 0
fi

repo_hash=$(printf '%s' "$repo_root" | shasum -a 256 | cut -c1-16)
base_dir="$HOME/.claude/tmp/session-base"
mkdir -p "$base_dir"
printf '%s\n' "$head_sha" > "$base_dir/$repo_hash"
