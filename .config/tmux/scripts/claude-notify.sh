#!/bin/bash

JQ=$(command -v jq)

state=""
while [ $# -gt 0 ]; do
  case "$1" in
    --state) state="$2"; shift 2 ;;
    *) shift ;;
  esac
done

[ -z "$state" ] && exit 0
[ -z "$TMUX_PANE" ] && exit 0

body="$state"

cwd=""
if [ ! -t 0 ] && [ -n "$JQ" ]; then
  cwd=$(cat | "$JQ" -r '.cwd // empty' 2>/dev/null)
fi

proj=""
[ -n "$cwd" ] && proj=$(basename "$cwd")

title="Claude Code"
[ -n "$proj" ] && title="$title - $proj"

sanitize() { printf '%s' "$1" | tr -d '\000-\037' | tr ';' ':' | tr '\\' '/'; }
title=$(sanitize "$title")
body=$(sanitize "$body")

tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
[ -z "$tty" ] && exit 0
[ ! -w "$tty" ] && exit 0

printf '\033Ptmux;\033\033]777;notify;%s;%s\007\033\\' "$title" "$body" > "$tty" 2>/dev/null
