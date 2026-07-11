#!/bin/bash
# SessionStart hook (matcher: compact): 直前 compact の引き継ぎメモを additionalContext で注入
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

jq -n --arg ctx "以下は /handoff で保存された、圧縮直前の引き継ぎメモです。文脈を継続する際の参考にしてください。

$content" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
