#!/bin/bash
# SessionStart hook (matcher: compact): inject the last compact handoff note via additionalContext
set -eu

pass() { echo '{}'; exit 0; }

input="$(cat)"
source_type="$(printf '%s' "$input" | jq -r '.source // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"

[ "$source_type" = "compact" ] || pass
[ -n "$cwd" ] && [ -d "$cwd/docs/compacts" ] || pass

latest="$(ls -1t "$cwd/docs/compacts"/*.md 2>/dev/null | head -1 || true)"
[ -n "$latest" ] && [ -f "$latest" ] || pass

content="$(cat "$latest" 2>/dev/null || true)"
[ -n "$content" ] || pass

jq -n --arg ctx "Below is the handoff note saved by /handoff just before compaction. Use it as a reference to continue the context.

$content" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
