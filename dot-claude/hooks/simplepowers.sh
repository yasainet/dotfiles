#!/usr/bin/env bash
set -uf

JQ=/opt/homebrew/bin/jq
[ -x "$JQ" ] || JQ=jq

BOOTSTRAP="${BASH_SOURCE[0]%/*}/../skills/simplepowers-00-bootstrap/SKILL.md"
[ -f "$BOOTSTRAP" ] || exit 0

body=$(awk 'NR==1 && $0=="---" {fm=1; next} fm && $0=="---" {fm=0; next} !fm' "$BOOTSTRAP") || exit 0
[ -z "$body" ] && exit 0

"$JQ" -n --arg c "<EXTREMELY_IMPORTANT>
$body
</EXTREMELY_IMPORTANT>" \
  '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}' 2> /dev/null || exit 0
