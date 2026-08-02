#!/usr/bin/env bash
# herdr pane で動く agent の transcript を nvim で開く。
# tui = fullscreen だと herdr copy mode で過去出力を辿れないため、その代替。
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pane_id="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"

dest="${TMPDIR:-/tmp}/herdr-transcript.md"
mark="${TMPDIR:-/tmp}/herdr-transcript.mark"

python3 "$here/claude-transcript.py" ${pane_id:+--pane "$pane_id"} > "$dest" 2> "$mark"
line=$(tail -1 "$mark")

exec nvim -R "+${line:-1}" "+normal! zt" "$dest"
