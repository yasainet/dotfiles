#!/bin/sh
payload=$(cat 2>/dev/null || true)

log_file="$HOME/.claude/notification.log"
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null || true)
printf '%s\tsource=PermissionRequest\tcwd=%s\n' "$ts" "$cwd" >> "$log_file"

# IME を ASCII へ戻す
/opt/homebrew/bin/macism com.apple.keylayout.ABC || true
