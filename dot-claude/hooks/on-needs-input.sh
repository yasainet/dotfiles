#!/bin/sh
payload=$(cat 2>/dev/null || true)

log_file="$HOME/.claude/notification.log"
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null || true)
printf '%s\tsource=PermissionRequest\tcwd=%s\n' "$ts" "$cwd" >> "$log_file"

bash ~/.config/tmux/plugins/tmux-claude-signal/scripts/state.sh --state needs-input || true
printf '%s' "$payload" | bash ~/.config/tmux/scripts/claude-notify.sh --state needs-input || true
/opt/homebrew/bin/macism com.apple.keylayout.ABC || true
