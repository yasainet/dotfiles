#!/usr/bin/env bash
set -euo pipefail

query=$(cat | jq -r '.query // ""')

{
  ghq list -p 2>/dev/null
  if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "$CLAUDE_PROJECT_DIR" ]; then
    ( cd "$CLAUDE_PROJECT_DIR" && rg --files --hidden --glob '!.git' 2>/dev/null )
  fi
} | fzf --filter="$query" | head -30
