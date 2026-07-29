#!/bin/sh
# PreToolUse (ExitPlanMode): 解錠されていなければ ExitPlanMode を止める
#
# 解錠は user が行頭で `;go` と書いたとき。ExitPlanMode が呼ばれると再び施錠される。
# 状態ファイルは持たず、transcript の最後のマーカーで判定する。

input=$(cat)

[ "$(printf '%s' "$input" | jq -r '.permission_mode // ""')" = "plan" ] || exit 0

transcript=$(printf '%s' "$input" | jq -r '.transcript_path // ""')
[ -f "$transcript" ] || exit 0

marker=$(jq -r '
  select(type == "object")
  | if .type == "user" then
      ((.message.content? // "")
        | if type == "string" then .
          elif type == "array" then (map(select(.type? == "text") | .text? // "") | join("\n"))
          else "" end)
      | if test("(^|\n);go([^a-zA-Z0-9]|$)") then "open" else empty end
    elif .type == "assistant" then
      ((.message.content? // []) | if type == "array" then . else [] end)
      | if (map(select(.type? == "tool_use" and .name? == "ExitPlanMode")) | length) > 0
        then "close" else empty end
    else empty end
' "$transcript" 2>/dev/null | tail -1)

[ "$marker" = "open" ] && exit 0

jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: "協議中。user が行頭で ;go と指示するまで plan を提示するな。再試行するな"
  }
}'
