# Cross-Session Signal Implementation Plan

> For agentic workers: REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

Goal: 他 tmux session の claude 状態 (needs-input / done) を attached client の status-right に最小サイン `●` で集約表示する。

Architecture: tmux-claude-signal の state.sh が window option `@claude-signal-state` を marker として set/unset する。新規 `scripts/cross-session.sh` が全 window の marker を集約し、tmux format 文字列を返す。dotfiles の tmux.conf がこのスクリプトを status-right で呼び出す。

Tech Stack: bash, tmux 3.0+, 既存 tmux-claude-signal 構造 (TPM plugin)

## Global Constraints

- Format rules: 見出し上下の `---` 禁止、`**Bold**` 禁止、1 文 1 行 (日本語 60 字以内)、装飾引用禁止、task list は `- [ ]`/`- [x]`、table は 80 桁以内
- README は人間向け、AI 向け制約は CLAUDE.md に寄せる
- 既存テスト構造を継承: `tests/lib/test-lib.sh` の helper を使い、新規 helper は同ファイルに追加
- DECISIONS.md への流し込みは spec の「DECISIONS.md に流す事項」を 1 行ずつ転記
- spec: `docs/superpowers/specs/2026-06-26-cross-session-signal-design.md`

## File Structure

plugin 側 (`.config/tmux/plugins/tmux-claude-signal/`)

- Modify `scripts/state.sh:51-63`: apply_style / clear_style に `@claude-signal-state` set/unset を追加
- Modify `scripts/focus-ack.sh:30-32`: clear ブロックに `@claude-signal-state` unset を追加
- Create `scripts/cross-session.sh`: 全 window の marker を集約して tmux format 文字列を出力
- Modify `tests/lib/test-lib.sh`: `get_state_marker` helper を追加
- Modify `tests/test-state-transitions.sh`: marker set/unset 検証を追加
- Modify `tests/test-focus-ack.sh`: focus 時 marker unset 検証を追加
- Create `tests/test-cross-session.sh`: 集約スクリプトの 5 ケース検証
- Modify `README.md`: Usage に cross-session indicator の設定例を追加、表に marker 行を追加
- Modify `CLAUDE.md`: Scope 記述更新、Glossary に `@claude-signal-state` 追記
- Create or Modify `docs/DECISIONS.md`: 3 行追記

dotfiles 側 (リポジトリルート)

- Modify `.config/tmux/tmux.conf`: theme source 後に status-right append 1 行
- Create `docs/DECISIONS.md`: 1 行追記

## Tasks

### Task 1: state.sh で @claude-signal-state marker を set/unset

Files:

- Modify: `.config/tmux/plugins/tmux-claude-signal/scripts/state.sh:51-63`
- Modify: `.config/tmux/plugins/tmux-claude-signal/tests/lib/test-lib.sh:45-46`
- Modify: `.config/tmux/plugins/tmux-claude-signal/tests/test-state-transitions.sh`

Interfaces:

- Produces: window option `@claude-signal-state` に `needs-input` / `done` を値として set、off で unset
- Produces: shell helper `get_state_marker <window_id>` を test-lib.sh に追加

- [ ] Step 1: test-lib.sh に `get_state_marker` helper を追加

`.config/tmux/plugins/tmux-claude-signal/tests/lib/test-lib.sh` の `get_current_style()` 直後に追記する。

```bash
get_state_marker() {
  local window_id="$1"
  _tmux show-options -wqv -t "$window_id" @claude-signal-state 2>/dev/null || true
}
```

- [ ] Step 2: test-state-transitions.sh に失敗テストを追加

`tests/test-state-transitions.sh` の各 state 検証ブロック末尾に marker 検証を追加する。

`needs-input paints yellow` ケース末尾に追加。

```bash
assert_eq "needs-input" "$(get_state_marker "$window_id")" "needs-input marker"
```

`off clears needs-input` ケース末尾に追加。

```bash
assert_empty "$(get_state_marker "$window_id")" "off clears marker"
```

`done paints red` ケース末尾に追加。

```bash
assert_eq "done" "$(get_state_marker "$window_id")" "done marker"
```

`off clears done` ケース末尾に追加。

```bash
assert_empty "$(get_state_marker "$window_id")" "off clears marker"
```

- [ ] Step 3: テストを走らせて FAIL を確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/test-state-transitions.sh`
Expected: FAIL (4 assertions、`get_state_marker` が空文字を返すため)

- [ ] Step 4: state.sh に marker set/unset を実装

`.config/tmux/plugins/tmux-claude-signal/scripts/state.sh` の `apply_style` と `clear_style` を編集する。

apply_style (line 51-56) を次に置き換える。

```bash
apply_style() {
  local window_id="$1" bg="$2" fg="$3"
  sig_log "APPLY window=$window_id bg=$bg fg=$fg"
  tmux set-window-option -qt "$window_id" "window-status-style" "bg=$bg,fg=$fg"
  tmux set-window-option -qt "$window_id" "window-status-current-style" "bg=$bg,fg=$fg"
  tmux set-window-option -qt "$window_id" "@claude-signal-state" "$state"
}
```

clear_style (line 58-63) を次に置き換える。

```bash
clear_style() {
  local window_id="$1"
  sig_log "CLEAR window=$window_id"
  tmux set-window-option -qut "$window_id" "window-status-style" || true
  tmux set-window-option -qut "$window_id" "window-status-current-style" || true
  tmux set-window-option -qut "$window_id" "@claude-signal-state" || true
}
```

`apply_style` から `$state` を参照するため、グローバル変数として可視である必要がある。`state.sh` の line 23 で `state=""` と宣言され while ループで上書きされたあと、line 73 の case 分岐内で apply_style が呼ばれるため、`$state` はそのスコープで生きている。問題なし。

- [ ] Step 5: テストを走らせて PASS を確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/test-state-transitions.sh`
Expected: `ok`

- [ ] Step 6: 全テストを走らせて regression がないことを確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/run-all.sh`
Expected: `all tests passed`

- [ ] Step 7: commit

```bash
cd .config/tmux/plugins/tmux-claude-signal
git add scripts/state.sh tests/lib/test-lib.sh tests/test-state-transitions.sh
git commit -m "feat(state): @claude-signal-state window option を marker として set/unset"
```

### Task 2: focus-ack.sh で @claude-signal-state を unset

Files:

- Modify: `.config/tmux/plugins/tmux-claude-signal/scripts/focus-ack.sh:30-32`
- Modify: `.config/tmux/plugins/tmux-claude-signal/tests/test-focus-ack.sh`

Interfaces:

- Consumes: Task 1 で追加した `get_state_marker` helper
- Produces: focus 時に `@claude-signal-state` も unset される

- [ ] Step 1: test-focus-ack.sh に失敗テストを追加

`tests/test-focus-ack.sh` の各 focus-clear ケース末尾に marker 検証を追加する。

`switching to the window clears red` ケース末尾に追加 (line 27 の `assert_empty` 直後)。

```bash
assert_empty "$(get_state_marker "$window_id")" "focus clears done marker"
```

`needs-input clears on focus too` ケース末尾に追加 (line 34 の `assert_empty` 直後)。

```bash
assert_empty "$(get_state_marker "$window_id")" "focus clears needs-input marker"
```

- [ ] Step 2: テストを走らせて FAIL を確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/test-focus-ack.sh`
Expected: FAIL (2 assertions、focus-ack.sh が marker を unset していないため)

- [ ] Step 3: focus-ack.sh に marker unset を実装

`.config/tmux/plugins/tmux-claude-signal/scripts/focus-ack.sh` の line 30-32 のクリアブロックを次に置き換える。

```bash
sig_log "focus-ack CLEAR window=$window_id"
tmux set-window-option -qut "$window_id" "window-status-style" || true
tmux set-window-option -qut "$window_id" "window-status-current-style" || true
tmux set-window-option -qut "$window_id" "@claude-signal-state" || true
```

- [ ] Step 4: テストを走らせて PASS を確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/test-focus-ack.sh`
Expected: `ok`

- [ ] Step 5: 全テストを走らせて regression がないことを確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/run-all.sh`
Expected: `all tests passed`

- [ ] Step 6: commit

```bash
cd .config/tmux/plugins/tmux-claude-signal
git add scripts/focus-ack.sh tests/test-focus-ack.sh
git commit -m "feat(focus-ack): focus 時に @claude-signal-state も unset する"
```

### Task 3: cross-session.sh を新規作成

Files:

- Create: `.config/tmux/plugins/tmux-claude-signal/scripts/cross-session.sh`
- Create: `.config/tmux/plugins/tmux-claude-signal/tests/test-cross-session.sh`

Interfaces:

- Consumes: window option `@claude-signal-state` (Task 1 で公開)
- Produces: stdout に tmux format 文字列 (`#[fg=yellow]●#[default] ` 等)、0 件なら空文字

- [ ] Step 1: test-cross-session.sh を新規作成 (失敗テスト)

`.config/tmux/plugins/tmux-claude-signal/tests/test-cross-session.sh` を新規作成する。

```bash
#!/usr/bin/env bash
# cross-session.sh aggregates @claude-signal-state across non-current sessions.

set -euo pipefail
source "$(dirname "$0")/lib/test-lib.sh"

cross_session_sh() {
  local current="$1"
  _tmux run-shell -t test:1 "bash '$TEST_ROOT/scripts/cross-session.sh' '$current' > /tmp/claude-signal-test-cross.$$"
  cat "/tmp/claude-signal-test-cross.$$"
  rm -f "/tmp/claude-signal-test-cross.$$"
}

setup_tmux
trap teardown_tmux EXIT

# Build a second session "other" with one window.
_tmux new-session -d -s other -x 80 -y 24
other_window=$(_tmux display-message -p -t other:1 '#{window_id}')

echo "  case: no markers anywhere -> empty"
assert_empty "$(cross_session_sh test)" "all clean"

echo "  case: needs-input in other session -> yellow dot"
_tmux set-window-option -qt "$other_window" "@claude-signal-state" "needs-input"
out=$(cross_session_sh test)
assert_eq "#[fg=yellow]●#[default] " "$out" "needs-input only"

echo "  case: done in other session -> red dot"
_tmux set-window-option -qut "$other_window" "@claude-signal-state"
_tmux set-window-option -qt "$other_window" "@claude-signal-state" "done"
out=$(cross_session_sh test)
assert_eq "#[fg=red]●#[default] " "$out" "done only"

echo "  case: both states across sessions -> yellow then red"
_tmux new-window -t other
other_window2=$(_tmux display-message -p -t other:2 '#{window_id}')
_tmux set-window-option -qt "$other_window2" "@claude-signal-state" "needs-input"
out=$(cross_session_sh test)
assert_eq "#[fg=yellow]●#[default] #[fg=red]●#[default] " "$out" "needs-input + done"

echo "  case: marker on current session is ignored"
_tmux set-window-option -qut "$other_window" "@claude-signal-state"
_tmux set-window-option -qut "$other_window2" "@claude-signal-state"
test_window=$(_tmux display-message -p -t test:1 '#{window_id}')
_tmux set-window-option -qt "$test_window" "@claude-signal-state" "needs-input"
assert_empty "$(cross_session_sh test)" "current session excluded"

report
```

- [ ] Step 2: テストを走らせて FAIL を確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/test-cross-session.sh`
Expected: FAIL (cross-session.sh が存在しないため bash 起動エラー or 空出力)

- [ ] Step 3: cross-session.sh を新規作成

`.config/tmux/plugins/tmux-claude-signal/scripts/cross-session.sh` を新規作成する。

```bash
#!/usr/bin/env bash
# Aggregate @claude-signal-state across non-current sessions.
# Output: tmux format string for status-right prepend, or empty.

set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  exit 0
fi

current="${1:-}"

has_needs=0
has_done=0

while IFS='|' read -r sess marker; do
  [ "$sess" = "$current" ] && continue
  case "$marker" in
    needs-input) has_needs=1 ;;
    done)        has_done=1 ;;
  esac
done < <(tmux list-windows -a -F '#{session_name}|#{@claude-signal-state}' 2>/dev/null)

out=""
[ "$has_needs" -eq 1 ] && out+="#[fg=yellow]●#[default] "
[ "$has_done" -eq 1 ]  && out+="#[fg=red]●#[default] "
printf '%s' "$out"
```

実行権限を付ける。

```bash
chmod +x .config/tmux/plugins/tmux-claude-signal/scripts/cross-session.sh
```

- [ ] Step 4: テストを走らせて PASS を確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/test-cross-session.sh`
Expected: `ok`

- [ ] Step 5: 全テストを走らせて regression がないことを確認

Run: `bash .config/tmux/plugins/tmux-claude-signal/tests/run-all.sh`
Expected: `all tests passed`

- [ ] Step 6: commit

```bash
cd .config/tmux/plugins/tmux-claude-signal
git add scripts/cross-session.sh tests/test-cross-session.sh
git commit -m "feat(cross-session): 他 session の state marker を集約する script を追加"
```

### Task 4: README と CLAUDE.md の更新

Files:

- Modify: `.config/tmux/plugins/tmux-claude-signal/README.md`
- Modify: `.config/tmux/plugins/tmux-claude-signal/CLAUDE.md`

Interfaces:

- なし (docs のみ)

- [ ] Step 1: README に cross-session 設定例を追加

`.config/tmux/plugins/tmux-claude-signal/README.md` の `### Sample` 段落の後、`Override colors with these options.` の前に新規段落を挿入する。

```markdown
### Cross-session indicator

Aggregate other sessions' state into the attached client's `status-right`.
Add the line below to your `tmux.conf` after the theme source.

```tmux
set -ag status-right "#(#{TMUX_CLAUDE_SIGNAL_DIR}/scripts/cross-session.sh #{client_session})"
```

A yellow `●` appears when any window in another session is `needs-input`.
A red `●` appears for `done`.
Both dots disappear when the corresponding state is cleared (focus or off).
```

(README は人間向けなので説明を端的に。CLAUDE.md と二重メンテしない)

- [ ] Step 2: CLAUDE.md の Scope を更新

`.config/tmux/plugins/tmux-claude-signal/CLAUDE.md` の `## Summary` セクションを次に置き換える。

```markdown
## Summary

- Claude Code hooks (UserPromptSubmit / PreToolUse / PermissionRequest / Stop) drive per-window color state.
- Color clears as soon as the user focuses the window so the signal acts as an unread mark.
- 着色対象は同 session 内 window のみで scope を絞る。
- state marker (`@claude-signal-state` window option) を公開し、`scripts/cross-session.sh` が全 session を集約して status-right に表示する。
```

- [ ] Step 3: CLAUDE.md の Glossaries に marker を追記

`## Glossaries` セクションに追記する。

```markdown
- `@claude-signal-state`: window option として公開される state marker。値は `needs-input` / `done` / (unset)。`state.sh` の apply/clear と `focus-ack.sh` で同期され、`scripts/cross-session.sh` が全 window を集約して読む。
```

- [ ] Step 4: commit

```bash
cd .config/tmux/plugins/tmux-claude-signal
git add README.md CLAUDE.md
git commit -m "docs: cross-session indicator と @claude-signal-state を README/CLAUDE に反映"
```

### Task 5: dotfiles の tmux.conf に status-right append

Files:

- Modify: `.config/tmux/tmux.conf:107`

Interfaces:

- Consumes: Task 3 で作成した `scripts/cross-session.sh` と Task 1 で公開した `@claude-signal-state` marker

- [ ] Step 1: tmux.conf に append 行を追加

`.config/tmux/tmux.conf` の line 107 の theme source 行の直後に 1 行追加する。

修正前 (line 106-110)

```
# Theme
source-file ~/.config/tmux/themes/tokyonight_night.tmux

# Plugins
set -g @plugin 'tmux-plugins/tpm'
```

修正後

```
# Theme
source-file ~/.config/tmux/themes/tokyonight_night.tmux

# Cross-session claude signal (prepend to status-right)
set -ag status-right "#(#{TMUX_CLAUDE_SIGNAL_DIR}/scripts/cross-session.sh #{client_session})"

# Plugins
set -g @plugin 'tmux-plugins/tpm'
```

- [ ] Step 2: tmux 設定を reload

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

- [ ] Step 3: 動作確認 (手動 smoke test)

別 session を作って marker を set する。

```bash
tmux new-session -d -s smoke -x 80 -y 24
smoke_win=$(tmux display-message -p -t smoke:1 '#{window_id}')
tmux set-window-option -qt "$smoke_win" "@claude-signal-state" "needs-input"
tmux refresh-client -S
```

attached client (現 session) の status-right の左に黄 `●` が出ることを目視確認する。

確認後にクリーンアップ。

```bash
tmux set-window-option -qut "$smoke_win" "@claude-signal-state"
tmux kill-session -t smoke
tmux refresh-client -S
```

- [ ] Step 4: commit

```bash
git add .config/tmux/tmux.conf
git commit -m "feat(tmux): cross-session claude signal を status-right に組み込み"
```

### Task 6: DECISIONS.md に判断を流す

Files:

- Create or Modify: `.config/tmux/plugins/tmux-claude-signal/docs/DECISIONS.md`
- Create: `docs/DECISIONS.md` (dotfiles 直下、新規)

Interfaces:

- なし (docs のみ)

- [ ] Step 1: plugin 側 DECISIONS.md の現状確認

`.config/tmux/plugins/tmux-claude-signal/docs/DECISIONS.md` を確認する。
存在しなければ新規作成、存在すれば末尾に追記する。

```bash
ls .config/tmux/plugins/tmux-claude-signal/docs/DECISIONS.md
```

- [ ] Step 2: plugin 側 DECISIONS.md に 3 行追記

`.config/tmux/plugins/tmux-claude-signal/docs/DECISIONS.md` の末尾に追記する。
ファイルが無ければ次の内容で新規作成する (既存があれば既存形式に合わせる)。

```markdown
- 2026-06-26: scope を「同 session 着色 + 全 session state marker 公開」に拡張。`@claude-signal-state` window option を marker として公開し `scripts/cross-session.sh` が集約する。
- 2026-06-26: state marker は window option `@claude-signal-state` で公開し、値は `needs-input` / `done` / (unset) に絞る。
- 2026-06-26: cross-session indicator の記号は `●` (Unicode U+25CF) 単一、色 (黄/赤) で `needs-input` / `done` を区別し、件数は出さない。
```

- [ ] Step 3: dotfiles 直下に DECISIONS.md を新規作成

`docs/DECISIONS.md` を新規作成する。

```markdown
# DECISIONS

不可逆 / 包括判断の 1 行ログ。

- 2026-06-26: status-right の cross-session indicator は plugin 自動 prepend ではなく `tmux.conf` で手動 1 行追加とする。理由は theme と plugin の load 順依存を避け、配置位置をユーザー側で完全に制御するため。
```

- [ ] Step 4: commit (plugin 側)

```bash
cd .config/tmux/plugins/tmux-claude-signal
git add docs/DECISIONS.md
git commit -m "docs(decisions): cross-session signal の確定判断を 3 件追記"
```

- [ ] Step 5: commit (dotfiles 側)

```bash
cd ~/ghq/github.com/yasainet/dotfiles
git add docs/DECISIONS.md
git commit -m "docs(decisions): tmux.conf 手動組み込みの判断を新規 DECISIONS.md に記録"
```

## Verification (Plan Self-Review)

spec 全項目との対応。

- [x] UI 仕様 (記号 / 色 / 数字なし / ケース別) → Task 3 の cross-session.sh と test-cross-session.sh で実装と検証
- [x] state marker (`@claude-signal-state`) → Task 1 で state.sh、Task 2 で focus-ack.sh
- [x] 集約スクリプト → Task 3
- [x] 更新トリガー (既存 refresh-client -S 流用) → 追加コードなし、Task 1 の state.sh が既存通り refresh する
- [x] status-right 組み込み → Task 5
- [x] CLAUDE.md / README 更新 → Task 4
- [x] DECISIONS.md 流し込み → Task 6
- [x] 検証手順 (run-all.sh + 手動 smoke) → Task 1-3 で run-all.sh、Task 5 Step 3 で手動 smoke
