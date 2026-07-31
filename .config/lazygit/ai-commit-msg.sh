#!/bin/sh
if git diff --cached --quiet; then
  echo "nothing staged" >&2
  exit 1
fi

generate() {
  {
    echo "## Context"
    echo "- Current git status:"
    git status
    echo "- Current git diff (staged changes):"
    git diff --cached
    echo "- Current branch:"
    git branch --show-current
    echo "- Recent commits:"
    git log --oneline -10
  } | MAX_THINKING_TOKENS=0 claude \
    -p "Based on the above changes, create a single git commit message for the staged changes. Output only the commit message on a single line, following the style of the recent commits. Do not send any other text besides the message." \
    --model haiku \
    --safe-mode \
    --permission-mode manual \
    --tools "" \
    --no-session-persistence \
    --strict-mcp-config --mcp-config '{"mcpServers":{}}'
}

while :; do
  echo "Generating commit message..."
  MSG=$(generate)
  if [ -z "$MSG" ]; then
    echo "claude returned an empty message" >&2
    exit 1
  fi
  printf '\n  %s\n\n' "$MSG"
  printf '[Enter] commit  [e] edit  [r] regenerate  [q] cancel > '
  read -r ans
  case "$ans" in
    "" | y) git commit -m "$MSG" && break ;;
    e) git commit -e -m "$MSG" && break ;;
    r) continue ;;
    *) echo "canceled"; break ;;
  esac
done
