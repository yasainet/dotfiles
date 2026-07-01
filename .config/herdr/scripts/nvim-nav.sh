#!/usr/bin/env bash
set -euo pipefail

dir="${1:-}"
case "$dir" in
	h) dir_name=left ;;
	j) dir_name=down ;;
	k) dir_name=up ;;
	l) dir_name=right ;;
	*)
		echo "usage: nvim-nav.sh h|j|k|l" >&2
		exit 2
		;;
esac

herdr_bin="${HERDR_BIN_PATH:-herdr}"

pane_id="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
if [ -z "$pane_id" ] && [ -n "${HERDR_PLUGIN_CONTEXT_JSON:-}" ]; then
	pane_id="$(printf '%s' "$HERDR_PLUGIN_CONTEXT_JSON" \
		| sed -n 's/.*"focused_pane_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
		| head -1)"
fi
if [ -z "$pane_id" ]; then
	pane_id="$("$herdr_bin" pane current 2>/dev/null \
		| sed -n 's/.*"pane_id":"\([^"]*\)".*/\1/p' | head -1)"
fi
[ -z "$pane_id" ] && exit 1

marker="${XDG_CACHE_HOME:-$HOME/.cache}/nvim-herdr/$pane_id"

if [ -f "$marker" ]; then
	pid=$(sed -n 's/^pid=//p' "$marker" | head -1)
	server=$(sed -n 's/^server=//p' "$marker" | head -1)
	if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null && [ -n "$server" ]; then
		if nvim --server "$server" --remote-send "<C-$dir>" 2>/dev/null; then
			exit 0
		fi
	fi
fi

"$herdr_bin" pane focus --pane "$pane_id" --direction "$dir_name" >/dev/null
