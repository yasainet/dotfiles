#!/usr/bin/env bash
# Spawn a herdr tab running `hunk diff <HEAD> --watch` so the session's
# cumulative diff is visible while editing.
set -euo pipefail

if [[ "${HERDR_ENV:-}" != "1" ]]; then
  echo "error: HERDR_ENV=1 not set; must be run inside herdr" >&2
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "error: not inside a git repo" >&2
  exit 1
}

head_sha=$(git rev-parse HEAD 2>/dev/null) || {
  echo "error: no HEAD commit" >&2
  exit 1
}

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
')
[[ -n "$ws_id" ]] || {
  echo "error: could not find focused workspace" >&2
  exit 1
}

tab_resp=$(herdr tab create --workspace "$ws_id" --label "hunk" --no-focus 2>/dev/null) || {
  echo "error: herdr tab create failed" >&2
  exit 1
}

pane_id=$(printf '%s' "$tab_resp" | python3 -c '
import sys, json
try:
    data = json.load(sys.stdin)
    print(data["result"]["root_pane"]["pane_id"])
except Exception:
    pass
')
[[ -n "$pane_id" ]] || {
  echo "error: could not parse pane_id from tab response" >&2
  exit 1
}

herdr pane run "$pane_id" "cd '$repo_root' && hunk diff $head_sha --watch"
echo "hunk tab spawned (pane $pane_id, base $head_sha)"
