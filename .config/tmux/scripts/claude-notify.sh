#!/bin/bash

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

sanitize() { printf '%s' "$1" | tr -d '\000-\037' | tr '"' "'"; }
title=$(sanitize "$title")
body=$(sanitize "$body")

if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$body\" with title \"$title\" sound name \"Glass\"" >/dev/null 2>&1 &
fi
