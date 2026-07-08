#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Opens a herdr tab that runs `hunk diff <HEAD-at-start> --watch`
# so the session's cumulative diff is visible from the start.
set -euo pipefail

[[ "${HERDR_ENV:-}" == "1" ]] || exit 0

payload=$(cat)
source_kind=$(printf '%s' "$payload" \
  | /usr/bin/grep -oE '"source"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | /usr/bin/sed -E 's/.*"([^"]*)"$/\1/' \
  || true)

if [[ "$source_kind" != "startup" && -n "$source_kind" ]]; then
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
