#!/bin/bash

TMUX_BIN=$(command -v tmux)
JQ=$(command -v jq)

state=""
while [ $# -gt 0 ]; do
  case "$1" in
    --state) state="$2"; shift 2 ;;
    *) shift ;;
  esac
done

input=""
[ ! -t 0 ] && input=$(cat)

msg=""
cwd=""
if [ -n "$input" ] && [ -n "$JQ" ]; then
  msg=$(printf '%s' "$input" | "$JQ" -r '.message // empty' 2>/dev/null)
  cwd=$(printf '%s' "$input" | "$JQ" -r '.cwd // empty' 2>/dev/null)
fi

proj=""
[ -n "$cwd" ] && proj=$(basename "$cwd")

case "$state" in
  done)        body=${msg:-Task complete} ;;
  needs-input) body=${msg:-Awaiting your input} ;;
  *)           body=${msg:-$state} ;;
esac
title="Claude Code${proj:+ - $proj}"

sanitize() { printf '%s' "$1" | tr -d '\000-\037' | tr ';' ','; }
title=$(sanitize "$title")
body=$(sanitize "$body")

if [ -n "$TMUX_PANE" ] && [ -n "$TMUX_BIN" ]; then
  pane_tty=$("$TMUX_BIN" display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
  if [ -n "$pane_tty" ] && [ -w "$pane_tty" ]; then
    printf '\ePtmux;\e\e]777;notify;%s;%s\a\e\\' "$title" "$body" > "$pane_tty"
  fi
fi
