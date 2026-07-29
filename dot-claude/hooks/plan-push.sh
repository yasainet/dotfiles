#!/bin/sh
# Stop: 解錠されたまま turn が終わろうとしたら止めて plan の提示を促す
#
# 解錠の判定は plan-hold.sh と同じ。stop_hook_active を見て 1 turn 1 回に留める。

input=$(cat)

[ "$(printf '%s' "$input" | jq -r '.permission_mode // ""')" = "plan" ] || exit 0
[ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0

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

[ "$marker" = "open" ] || exit 0

jq -n '{
  decision: "block",
  reason: ";go を指示済み。plan の提示を待っている",
  hookSpecificOutput: {
    hookEventName: "Stop",
    additionalContext: "user が ;go で plan の提示を指示している。plan file を書いて ExitPlanMode を呼べ"
  }
}'
