#!/usr/bin/env bash
set -euo pipefail

# HACK: Cmd+Backspace の行頭削除を Ghostty + herdr の 3 層で再現する
#
# 本来は Claude Code 側で完結すべき。upstream が以下のどちらかを入れれば
# この script ごと消せる。
#   - 行編集を keybinding action として公開する (現状 schema に存在しない)
#   - vim mode を意識した context 分離 (anthropics/claude-code#61389, #64992)
#
# Ghostty が Cmd+Backspace を alt+u として送ってくる。
#
# 既定では Cmd+Backspace は Ctrl+U と同じ 0x15 を送るため、Claude Code 側で
# Ctrl+U を scroll に割り当てると行頭削除が消える。Claude Code の keybinding
# schema に削除系 action は存在せず、行編集は再割り当てできない。
#
# そこで pane が claude なら Ctrl+A (行頭へ) + Ctrl+K (行末まで削除) を
# 直接 PTY へ注入する。send-keys は herdr の keybinding 層を通らないため、
# Ctrl+K が pane 移動に奪われない。
# Ctrl+K は行を空にするだけで改行を残すため、連続押下が空振りする。
# Backspace を続けて改行ごと詰め、上の行へ食い込ませる。
# claude 以外の pane へは本来の Ctrl+U をそのまま送る。

herdr_bin="${HERDR_BIN_PATH:-herdr}"

# 押下ごとに走るため process 起動を最小化する。jq を挟むと 1 回あたり
# 90ms 以上かかり体感できるラグになるので、bash の正規表現で済ませる。
pane="$("$herdr_bin" pane current 2>/dev/null || true)"

[[ "$pane" =~ \"pane_id\":\"([^\"]+)\" ]] || exit 0
pane_id="${BASH_REMATCH[1]}"

agent=""
[[ "$pane" =~ \"agent\":\"([^\"]+)\" ]] && agent="${BASH_REMATCH[1]}"

if [ "$agent" = "claude" ]; then
	exec "$herdr_bin" pane send-keys "$pane_id" ctrl+a ctrl+k backspace
fi

exec "$herdr_bin" pane send-keys "$pane_id" ctrl+u
