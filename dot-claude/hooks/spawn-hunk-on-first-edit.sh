#!/usr/bin/env bash
# Claude Code PreToolUse hook (Edit / Write / NotebookEdit).
# On the first file-mutating tool call of a session, opens a herdr tab
# running `hunk diff <HEAD-at-first-edit> --watch` so the session's
# cumulative diff is visible from the moment editing begins.
# Subsequent tool calls in the same session are no-op.
set -euo pipefail

[[ "${HERDR_ENV:-}" == "1" ]] || exit 0

payload=$(cat)

session_id=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)
[[ -n "$session_id" ]] || exit 0

sentinel_dir="$HOME/.claude/tmp/hunk-spawned"
mkdir -p "$sentinel_dir"
sentinel="$sentinel_dir/$session_id"

if ! (set -o noclobber; : > "$sentinel") 2>/dev/null; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
[[ -n "$repo_root" ]] || exit 0

head_sha=$(git rev-parse HEAD 2>/dev/null || true)
[[ -n "$head_sha" ]] || exit 0

ws_id=$(herdr pane list 2>/dev/null | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for pane in data.get("result", {}).get("panes", []):
    if pane.get("focused"):
        print(pane.get("workspace_id", ""))
        break
' || true)
[[ -n "$ws_id" ]] || exit 0

tab_resp=$(herdr tab create --workspace "$ws_id" --label "hunk" --no-focus 2>/dev/null || true)
[[ -n "$tab_resp" ]] || exit 0

pane_id=$(printf '%s' "$tab_resp" | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
    print(data["result"]["root_pane"]["pane_id"])
except Exception:
    pass
' || true)
[[ -n "$pane_id" ]] || exit 0

herdr pane run "$pane_id" "cd '$repo_root' && hunk diff $head_sha --watch"
