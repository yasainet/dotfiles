#!/bin/sh
payload=$(cat 2>/dev/null || true)

log_file="$HOME/.claude/notification.log"
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ntype=$(printf '%s' "$payload" | jq -r '.notification_type // empty' 2>/dev/null || true)
msg=$(printf '%s' "$payload" | jq -r '.message // empty' 2>/dev/null || true)
cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null || true)
printf '%s\tsource=Notification\ttype=%s\tmsg=%s\tcwd=%s\n' "$ts" "$ntype" "$msg" "$cwd" >> "$log_file"
