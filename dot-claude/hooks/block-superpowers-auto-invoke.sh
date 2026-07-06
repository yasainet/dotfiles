#!/usr/bin/env bash
# PreToolUse Skill hook.
# Blocks auto-invocation of superpowers chain-forward skills.
# Two escape hatches for explicit invocation:
#   1. env SUPERPOWERS_ALLOW=<skill> claude   (session-wide)
#   2. touch ~/.claude/tmp/allow-<skill>      (mid-session, one-shot)

set -uo pipefail

INPUT=$(cat)
SKILL=$(printf '%s' "$INPUT" | jq -r '.tool_input.skill // empty')

[ -z "$SKILL" ] && exit 0

BLOCKED=(
  "superpowers:brainstorming"
)

is_blocked=0
for b in "${BLOCKED[@]}"; do
  if [ "$SKILL" = "$b" ]; then
    is_blocked=1
    break
  fi
done

[ $is_blocked -eq 0 ] && exit 0

SKILL_BARE="${SKILL##*:}"

IFS=',' read -ra ALLOW <<< "${SUPERPOWERS_ALLOW:-}"
for a in "${ALLOW[@]}"; do
  if [ "$SKILL" = "$a" ] || [ "$SKILL_BARE" = "$a" ]; then
    exit 0
  fi
done

MARKER_DIR="${HOME}/.claude/tmp"
mkdir -p "$MARKER_DIR"
MARKER="${MARKER_DIR}/allow-${SKILL_BARE}"
if [ -f "$MARKER" ]; then
  rm -f "$MARKER"
  exit 0
fi

cat >&2 <<MSG
BLOCK: auto-invocation of skill '$SKILL' is disabled.
To invoke it explicitly, use one of:
  1. touch $MARKER  (one-shot)
  2. env SUPERPOWERS_ALLOW=$SKILL_BARE claude  (session-wide)
MSG
exit 2
