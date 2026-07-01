# tmux → herdr 移行 実装計画

> [!NOTE]
> For agentic workers: REQUIRED SUB-SKILL — superpowers:subagent-driven-development (推奨) または superpowers:executing-plans でタスク単位に実装する。
> ステップは `- [ ]` / `- [x]` 記法で追跡する。

## Goal

dotfiles の端末マルチプレクサを tmux から herdr へ、日常環境を壊さず段階的に移行する。

## Architecture

`main` を動く tmux 環境として温存したまま `herdr-migration` ブランチで作業する。
移行中は日常起動を tmux に据え置き、herdr は `open -na Ghostty.app --args -e herdr` の別ウィンドウで並行運用する。
tmux 固有の作り込み（signal プラグイン・popup・resurrect・smart-splits 連携）を herdr のネイティブ機能と CLI API に置き換える。
最後に Ghostty の既定起動を herdr へ切り替える。
tmux/* の設定は削除せず inert なフォールバックとして残す。

## Tech Stack

herdr 0.7.1（homebrew-core, AGPL-3.0）, Ghostty, zsh（ZDOTDIR=~/.config/zsh）, Neovim（lazy.nvim）, Claude Code hooks, jq。

## Global Constraints

- 作業ブランチは `herdr-migration` とする。`main` は常に動く tmux フォールバックとして保持する。
- `.org` バックアップコピーは作らない。git が履歴付きバックアップである。
- tmux 設定（`.config/tmux/**`）は本移行で削除しない。起動されなくなり inert 化するだけである。
- herdr のバージョン基準は `0.7.1` とする。CLI 出力は JSON で、`jq` でパースする。
- herdr 設定ファイルは `~/.config/herdr/config.toml` とする。dotfiles では `.config/herdr/config.toml` で管理し、既存の `create_symlinks()` のディレクトリループでリンクされる。
- 検証は手動とする。herdr ウィンドウ（`open -na Ghostty.app --args -e herdr`）内で当該コマンドとキーを実行し、記載の期待挙動を目視確認する。
- コミットは各タスク末尾で行う。メッセージ末尾に `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>` を付す。
- コミットとプッシュはユーザー指示時のみ行う。

## Phase 0: ブランチと herdr 設定ディレクトリの雛形

### Task 0: 作業ブランチと config ディレクトリの用意、runtime 除外

Files:

- Create: `.config/herdr/config.toml`（空の雛形。中身は Task 1 で作る）
- Modify: `.gitignore`（herdr の runtime 生成物を除外）

Interfaces:

- Produces: dotfiles 管理下の `~/.config/herdr/config.toml`（Task 1 以降が編集する）

- [ ] Step 1: `herdr-migration` ブランチを作成する

```bash
cd ~/ghq/github.com/yasainet/dotfiles
git checkout -b herdr-migration
```

- [ ] Step 2: 現状の実 `~/.config/herdr` を確認する

```bash
ls -la ~/.config/herdr
```

Expected: `herdr.sock` / `herdr-client.sock` / `agent-detection/` が存在し、`config.toml` は無い。
`~/.config/herdr` は実ディレクトリ（シンボリックリンクではない）である。

- [ ] Step 3: 稼働中 herdr サーバを停止し、実ディレクトリを退避する

```bash
herdr server stop 2>/dev/null || true
pkill -f 'herdr server' 2>/dev/null || true
mv ~/.config/herdr ~/.config/herdr.pre-migration
```

理由: 次段で dotfiles 側 `.config/herdr` をここへリンクするため、既存の実ディレクトリを空ける。
sockets は再生成されるので退避で十分である。

- [ ] Step 4: dotfiles に `.config/herdr/` を作り雛形 config を置く

```bash
mkdir -p ~/ghq/github.com/yasainet/dotfiles/.config/herdr
printf '# herdr configuration (managed in dotfiles)\n' \
  > ~/ghq/github.com/yasainet/dotfiles/.config/herdr/config.toml
```

- [ ] Step 5: `.gitignore` に herdr runtime を追記する

`.gitignore` の末尾へ以下を追加する。`config.toml` だけ追跡し、sockets とログは除外する。

```gitignore
# herdr runtime artifacts (config.toml のみ追跡)
.config/herdr/*.sock
.config/herdr/agent-detection/
.config/herdr/*.log
.config/herdr/sessions/
```

- [ ] Step 6: シンボリックリンクを張り直す

```bash
ln -sfn ~/ghq/github.com/yasainet/dotfiles/.config/herdr ~/.config/herdr
ls -la ~/.config/herdr/config.toml
```

Expected: `~/.config/herdr` が dotfiles 配下へのシンボリックリンクになり、`config.toml` が見える。

- [ ] Step 7: herdr が新 config パスを読むことを確認する

```bash
herdr --default-config >/dev/null && herdr status 2>&1 | head -5
open -na Ghostty.app --args -e /opt/homebrew/bin/herdr
```

Expected: herdr ウィンドウが起動し、雛形 config を読んでも異常なし。
sockets が dotfiles 配下に再生成される（gitignore 済みで `git status` に出ない）。

- [ ] Step 8: Commit する

```bash
git add .config/herdr/config.toml .gitignore
git commit -m "chore(herdr): dotfiles 管理下に herdr 設定ディレクトリを用意"
```

## Phase 1: herdr ベース設定

### Task 1: config.toml に現状 tmux/ghostty 相当の基盤設定を書く

Files:

- Modify: `.config/herdr/config.toml`

Interfaces:

- Consumes: Phase 0 のシンボリックリンク済み config パス
- Produces: prefix `ctrl+b` / tokyo-night / `new_cwd=follow` / IME 対応 / 通知 が効いた herdr 基盤

- [ ] Step 1: config.toml を以下で置き換える

`.config/herdr/config.toml`:

```toml
# herdr configuration (managed in dotfiles: ~/.config/herdr/config.toml)

[theme]
# Ghostty の固定 "TokyoNight Night" に合わせ暗色固定（auto_switch はしない）
name = "tokyo-night"

[terminal]
shell_mode = "auto"   # macOS = login shell（現状維持）
new_cwd = "follow"    # tmux の split/new-window の -c "#{pane_current_path}" 相当

[keys]
prefix = "ctrl+b"     # tmux と同一。既定バインドは現状の Cmd リマップとほぼ一致するため据え置き
# 参考（既定のまま使う）: new_tab=prefix+c, switch_tab=prefix+1..9,
#   previous_tab=prefix+p, next_tab=prefix+n, split_vertical=prefix+v,
#   split_horizontal=prefix+minus, detach=prefix+q, zoom=prefix+z,
#   focus_pane_left/down/up/right=prefix+h/j/k/l

[ui]
accent = "cyan"

[ui.toast]
delivery = "terminal"  # Ghostty のデスクトップ通知へ流す（claude-notify 相当）

[ui.sound]
enabled = true

[session]
resume_agents_on_restore = true  # サーバ再起動後に Claude 会話ペインを復帰

[experimental]
# macism ハック（copy-mode/popup 突入時の ABC 切替）の置き換え:
#   prefix モード中だけ macOS 入力ソースを ASCII に切替、抜けたら復帰
switch_ascii_input_source_in_prefix = true
# Claude Code / codex / opencode 等の TUI で CJK IME 候補ウィンドウを追従
reveal_hidden_cursor_for_cjk_ime = true
cjk_ime_agents = ["claude", "codex", "opencode"]
```

- [ ] Step 2: 設定の妥当性を確認する

```bash
herdr server reload-config 2>/dev/null || true
herdr status 2>&1 | head -5
```

Expected: エラー無し。config.toml のパースに失敗すれば herdr が警告を出す。

- [ ] Step 3: herdr ウィンドウで目視検証する

```bash
open -na Ghostty.app --args -e /opt/homebrew/bin/herdr
```

herdr ウィンドウで以下を確認する。

- 配色が TokyoNight（暗色）である
- `C-b -` / `C-b v` で分割し、新ペインの cwd が分割元と同じである
- `C-b c` で新タブ、`C-b 1`..`C-b 3` でタブ切替できる
- 日本語入力中に `C-b` を押すと prefix が効く（ASCII 切替が働く）

- [ ] Step 4: Commit する

```bash
git add .config/herdr/config.toml
git commit -m "feat(herdr): tmux/ghostty 相当の基盤設定（theme/prefix/cwd/IME/通知）"
```

## Phase 2: Claude Code ネイティブ化（tmux-claude-signal 退役）

### Task 2: herdr ネイティブ agent 検出へ切替え、signal hooks を撤去する

Files:

- Modify: `dot-claude/settings.json`（`state.sh` を呼ぶ hook を除去）
- 参照/退役対象: `.config/tmux/plugins/tmux-claude-signal/**`, `.config/tmux/scripts/claude-notify.sh`

Interfaces:

- Consumes: `~/.claude/settings.json`（= dotfiles `dot-claude/settings.json` へのシンボリックリンク）
- Produces: herdr サイドバーの agent 状態と `[ui.toast]`/`[ui.sound]` 通知。tmux-claude-signal 非依存

- [ ] Step 1: herdr の Claude 連携を導入する

```bash
herdr integration install claude
herdr integration status
```

Expected: claude integration が installed 表示。
このコマンドは `~/.claude/settings.json`（= dotfiles 管理ファイル）を編集する可能性がある。
次段で差分を確認する。

- [ ] Step 2: integration が settings.json に加えた差分を確認する

```bash
cd ~/ghq/github.com/yasainet/dotfiles
git diff dot-claude/settings.json
```

Expected: herdr 用 hook が追加されていれば内容を把握する。
無ければ herdr は agent 検出を manifest（`agent-detection/`）経由で行うのみである。

- [ ] Step 3: tmux-claude-signal の `state.sh` を呼ぶ hook を除去する

`dot-claude/settings.json` から、以下4箇所の `state.sh` 呼び出し hook エントリを削除する。
他の hook（`inject-path-rule.mjs` / `on-prompt.sh` / `on-stop.sh` / `on-needs-input.sh` / `on-notification.sh`）は残す。

- `PreToolUse` の `matcher: ""` エントリ（`state.sh --state off`）
- `UserPromptSubmit` の2つ目の hook（`state.sh --state off`）
- `Stop` の2つ目の hook（`state.sh --state done`）
- `PermissionRequest` の2つ目の hook（`state.sh --state needs-input`）

削除後、JSON が妥当であることを確認する。

```bash
jq . dot-claude/settings.json >/dev/null && echo "JSON OK"
```

Expected: `JSON OK`。

- [ ] Step 4: `on-*.sh` 通知 hook が tmux 依存でないか確認する

```bash
grep -n 'tmux' dot-claude/hooks/on-stop.sh dot-claude/hooks/on-needs-input.sh \
  dot-claude/hooks/on-notification.sh dot-claude/hooks/on-prompt.sh
```

Expected: 出力なし（tmux 非依存）。
tmux 参照があれば、その hook も herdr 通知（`herdr notification show`）へ置換対象として記録する。

- [ ] Step 5: tmux.conf から signal プラグイン行を無効化する

`.config/tmux/tmux.conf` の `set -g @plugin 'yasainet/tmux-claude-signal'`（114行目付近）をコメントアウトする。
status-right の cross-session chip 埋め込みがあれば併せてコメントアウトする。
tmux フォールバック起動時に退役プラグインを読ませないためである。

- [ ] Step 6: herdr で Claude 状態表示を目視検証する

```bash
open -na Ghostty.app --args -e /opt/homebrew/bin/herdr
```

herdr ウィンドウで Claude Code を2ペイン起動し確認する。

- サイドバーに各 Claude ペインの状態（working/idle/blocked）が出る
- 権限プロンプト待ちで blocked、応答完了で done 相当に変化する
- バックグラウンドペインの状態遷移で通知音またはトースト（Ghostty 通知）が出る

- [ ] Step 7: Commit する

```bash
git add dot-claude/settings.json .config/tmux/tmux.conf
git commit -m "feat(herdr): Claude 状態表示をネイティブ化し tmux-claude-signal を退役"
```

## Phase 3: zsh `ts()` を herdr workspace API へ移植

### Task 3: ghq リポジトリ切替関数 `ts()` を herdr 対応に書き換える

Files:

- Modify: `.config/zsh/.zshrc:77-108`（`ts()` 関数）

Interfaces:

- Consumes: `herdr workspace list`（JSON: `.result.workspaces[].{workspace_id,label}`）
- Consumes: `herdr workspace focus <id>`, `herdr workspace create --cwd PATH --label TEXT --focus`
- Produces: ghq リポジトリを fzf で選び、同名 herdr workspace を focus / 無ければ作成する `ts()`

- [ ] Step 1: `ts()` を以下で置き換える

`.config/zsh/.zshrc` の現行 `ts()`（77-108行, tmux 依存の後始末ブロック含む全体）を次に差し替える。

```zsh
ts() {
  local repo dir session ws_id
  repo=$(ghq list | fzf --height 40% --reverse --border --prompt='Repo> ') || return
  session=$(basename "$repo" | tr '.' '_')
  dir=$(ghq list -p --exact "$repo")

  # 同名 label の herdr workspace を探し、あれば focus・無ければ作成
  ws_id=$(herdr workspace list 2>/dev/null \
    | jq -r --arg l "$session" \
        '.result.workspaces[] | select(.label==$l) | .workspace_id' \
    | head -n1)

  if [[ -n "$ws_id" ]]; then
    herdr workspace focus "$ws_id" >/dev/null
  else
    herdr workspace create --cwd "$dir" --label "$session" --focus >/dev/null
  fi
}
```

旧コードの `$TMUX_POPUP`/`$TMUX_PANE` 後始末ブロックは herdr では不要（該当 env が存在しない）なので削除する。

- [ ] Step 2: 構文チェックする

```bash
zsh -n ~/ghq/github.com/yasainet/dotfiles/.config/zsh/.zshrc && echo "zsh syntax OK"
```

Expected: `zsh syntax OK`。

- [ ] Step 3: herdr ウィンドウで動作検証する

herdr ウィンドウのシェルで以下を実行する。

```bash
exec zsh   # 新 .zshrc を読み込む
ts         # 既存リポジトリを選ぶ → 既存 workspace なら focus
ts         # 別リポジトリを選ぶ → 新規 workspace が作成され focus
```

Expected: 選んだリポジトリの workspace に切り替わる。
`herdr workspace list | jq '.result.workspaces[].label'` に選んだ session 名が出る。
野良 tmux server が湧かない（`pgrep -fl tmux` が migration 前と変わらない）。

- [ ] Step 4: Commit する

```bash
git add .config/zsh/.zshrc
git commit -m "feat(herdr): ts() を herdr workspace API へ移植"
```

## Phase 4: nvim `<leader>cc` を herdr pane API へ移植（日常運用可能マイルストーン）

### Task 4: Claude ペイン toggle を herdr の split/close へ書き換える

Files:

- Modify: `.config/nvim/lua/config/keymaps.lua:198-228`（`toggle_claude()`）

Interfaces:

- Consumes: `herdr pane current`（JSON: `.result.pane.pane_id`）
- Consumes: `herdr pane split <pane_id> --direction right --ratio 0.5 --focus`（JSON: 新ペインの `pane_id`）
- Consumes: `herdr pane run <pane_id> <cmd>`, `herdr pane get <pane_id>`, `herdr pane close <pane_id>`
- Produces: `<leader>cc` で nvim ペインの右に Claude ペインを開閉するトグル

- [ ] Step 1: `herdr pane current` が nvim ペインを返すことを確認する（discovery）

herdr ウィンドウで nvim を開き、nvim 内で `:!herdr pane current` を実行する。

Expected: JSON の `.result.pane.pane_id` が nvim の走るペイン ID（例 `w1:p2`）。
フォーカス中ペイン＝nvim なので一致するはずである。
異なる場合は Step 3 のコードで `current` の解決方法を見直す。

- [ ] Step 2: `toggle_claude()`（198-228行）を以下で置き換える

`.config/nvim/lua/config/keymaps.lua`:

```lua
local function herdr_pane_id(out)
	return out:match('"pane_id":"([^"]+)"')
end

local function toggle_claude()
	-- 既存 Claude ペインがあれば閉じる
	if _G._claude_pane_id then
		local info = vim.fn.system("herdr pane get " .. _G._claude_pane_id .. " 2>/dev/null")
		if vim.v.shell_error == 0 and info:match('"pane_id"') then
			vim.fn.system("herdr pane close " .. _G._claude_pane_id)
			_G._claude_pane_id = nil
			return
		end
		_G._claude_pane_id = nil
	end
	-- 現在（nvim）ペインを右に 50% 分割し、Claude を起動
	local cur = herdr_pane_id(vim.fn.system("herdr pane current"))
	if not cur then
		vim.notify("herdr: current pane 取得失敗", vim.log.levels.ERROR)
		return
	end
	local out = vim.fn.system(
		"herdr pane split " .. cur .. " --direction right --ratio 0.5 --focus"
	)
	local pid = herdr_pane_id(out)
	if not pid then
		vim.notify("herdr: split 失敗: " .. out, vim.log.levels.ERROR)
		return
	end
	_G._claude_pane_id = pid
	vim.fn.system("herdr pane run " .. pid .. " claude")
end
```

`vim.keymap.set("n", "<leader>cc", ...)` のバインド（226-228行）はそのまま維持する。
旧コード（`pick_size` のコメント198-201含む tmux 版）は全て削除する。

- [ ] Step 3: Lua 構文チェックする

```bash
luajit -bl ~/ghq/github.com/yasainet/dotfiles/.config/nvim/lua/config/keymaps.lua >/dev/null \
  && echo "lua syntax OK" || echo "check with :luafile in nvim"
```

Expected: `lua syntax OK`。luajit 無ければ nvim 起動時のエラー有無で判断する。

- [ ] Step 4: herdr ウィンドウで動作検証する

herdr ウィンドウで nvim を開き確認する。

- `<leader>cc` で右に Claude ペインが開く
- もう一度 `<leader>cc` でその Claude ペインが閉じる
- Claude ペインを手で閉じた後の `<leader>cc` で新規に開き直る（stale id を掴まない）

- [ ] Step 5: Commit する

```bash
git add .config/nvim/lua/config/keymaps.lua
git commit -m "feat(herdr): <leader>cc の Claude ペイン toggle を herdr pane API へ移植"
```

> [!NOTE]
> ここまでで herdr を日常運用できる。
> 起動・分割・タブ・cwd 追従・Claude 状態表示・リポ切替・Claude ペインが揃う。
> 以降 Phase 5-7 は作り込みの移植、Phase 8 でカットオーバーである。

## Phase 5: Claude popup（C-r 履歴 / C-f ファイルピッカー）の移植（探索的）

### Task 5: popup を herdr custom command と pane API へ移植する

Files:

- Create: `.config/herdr/scripts/chathist-popup.sh`（tmux 版を herdr 向けに移植）
- Create: `.config/herdr/scripts/file-picker.sh`（tmux 版を移植）
- Modify: `.config/herdr/config.toml`（`[[keys.command]]` を追加）

Interfaces:

- Consumes: `herdr pane list`（JSON, 注入先ペインの解決）
- Consumes: `herdr pane send-text <pane_id> <text>`, `[[keys.command]] type="pane"`
- Produces: herdr で Claude ペインへ履歴 resume / ファイルパスを注入する popup 相当

- [ ] Step 1: 注入先ペインの解決方法を調査する（discovery）

tmux 版は `$TMUX_PANE`（起動元ペイン）へ `send-keys` していた。
herdr の `type="pane"` コマンドは一時ペインで走るため、直前にフォーカスしていた Claude ペインを特定する必要がある。
以下で解決策を確認する。

```bash
herdr pane list | jq '.result.panes[] | {pane_id, agent, focused}'
```

検討: (a) `agent=="claude"` のペインが1つなら自動特定、(b) 直前フォーカスを herdr が公開しているか `herdr pane` サブコマンドを再確認する。
解決策が無ければ本 Phase は「Claude ペインが単一の場合のみ対応」に縮小し、その旨をコミットメッセージに明記する。

- [ ] Step 2: `chathist-popup.sh` を移植する

`.config/herdr/scripts/chathist-popup.sh`（tmux 版の fzf 部分はそのまま、注入だけ差し替え）:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 注入先: agent=claude のペイン（複数時は最初の claude ペイン）
TARGET_PANE=$(herdr pane list \
  | jq -r '.result.panes[] | select(.agent=="claude") | .pane_id' | head -n1)
[ -z "$TARGET_PANE" ] && exit 0

preview='chathist pick {1} --stdout | CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
preview_w='chathist pick -w {1} --stdout | CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
preview_a='chathist pick --all {1} --stdout | CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80}'
h='mode: project | C-s:worktree / C-a:all / C-r:project'

selection=$(chathist list \
  | fzf --reverse --delimiter=$'\t' --with-nth=2.. \
        --header "$h" \
        --preview "$preview" --preview-window 'right:60%:wrap' \
        --bind "ctrl-s:reload(chathist list -w)+change-preview($preview_w)+change-header(mode: worktree | C-a:all / C-r:project)" \
        --bind "ctrl-a:reload(chathist list --all)+change-preview($preview_a)+change-header(mode: all-repos | C-s:worktree / C-r:project)" \
        --bind "ctrl-r:reload(chathist list)+change-preview($preview)+change-header($h)" \
        --bind 'shift-up:preview-up,shift-down:preview-down' \
        --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down' \
  | cut -f1 || true)

[ -z "$selection" ] && exit 0
chathist insert --all "$selection" 2>/dev/null || true
herdr pane send-text "$TARGET_PANE" "/resume $selection"
```

macism 呼び出しは削除する。herdr の `switch_ascii_input_source_in_prefix` が担当する。

- [ ] Step 3: `file-picker.sh` を移植する

`.config/herdr/scripts/file-picker.sh`（tmux 版の fzf/fd 部分維持、末尾注入のみ差し替え）:

```bash
#!/usr/bin/env bash
set -euo pipefail

TARGET_PANE=$(herdr pane list \
  | jq -r '.result.panes[] | select(.agent=="claude") | .pane_id' | head -n1)
[ -z "$TARGET_PANE" ] && exit 0

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
fd_flags='-H --follow --type f --type d --exclude .git --exclude .DS_Store'
preview_files='[[ -d {} ]] && tree -C {} | head -n 30 || bat --style=numbers --color=always {}'

selection=$(fd $fd_flags \
  | fzf --multi --reverse --freeze-right=1 \
        --prompt 'Files> ' \
        --header 'tab: multi-select / C-s: toggle grep mode' \
        --bind 'tab:toggle' \
        --preview "if [[ \$FZF_PROMPT == Grep* ]]; then $SCRIPT_DIR/grep-preview.sh {q} {}; else $preview_files; fi" \
        --preview-window 'right:60%:wrap' \
        --bind 'start:unbind(change)' \
        --bind "change:reload:rg --files-with-matches --hidden --glob '!.git' --color=never -- {q} 2>/dev/null || true" \
        --bind "ctrl-s:transform:[[ \$FZF_PROMPT == \"Files> \" ]] && echo \"change-prompt(Grep> )+disable-search+clear-query+reload(: || true)+rebind(change)\" || echo \"change-prompt(Files> )+enable-search+clear-query+unbind(change)+reload(fd $fd_flags)\"" \
  || true)

[ -z "$selection" ] && exit 0

paths=()
while IFS= read -r line; do
  [[ -n $line ]] && paths+=("@$line")
done <<<"$selection"
printf -v output '%s ' "${paths[@]}"
herdr pane send-text "$TARGET_PANE" "$output"
```

注: `grep-preview.sh` は tmux 版から `.config/herdr/scripts/` へコピーする（`cp .config/tmux/scripts/grep-preview.sh .config/herdr/scripts/`）。
tmux 版の agent 判定（claude/gemini/codex で @接頭辞切替）は Claude 前提に単純化し、@接頭辞固定とする。

- [ ] Step 4: 実行権限付与と config へのバインド追加をする

```bash
chmod +x .config/herdr/scripts/*.sh
```

`.config/herdr/config.toml` の `[keys]` セクション以降に追記する。

```toml
[[keys.command]]
key = "prefix+r"
type = "pane"
command = "~/.config/herdr/scripts/chathist-popup.sh"

[[keys.command]]
key = "prefix+f"
type = "pane"
command = "~/.config/herdr/scripts/file-picker.sh"
```

- [ ] Step 5: herdr で検証する

herdr ウィンドウで Claude ペインを1つ開き確認する。

- `C-b r` でチャット履歴 fzf が一時ペインで開き、選択で Claude ペインに `/resume <id>` が入る
- `C-b f` でファイルピッカーが開き、選択で `@path` が Claude ペインに入る

- [ ] Step 6: Commit する

```bash
git add .config/herdr/config.toml .config/herdr/scripts/
git commit -m "feat(herdr): Claude popup（履歴/ファイルピッカー）を herdr へ移植"
```

## Phase 6: split ナビゲーションの思想転換（smart-splits）

### Task 6: nvim↔pane シームレス移動を役割分離方針で確定する

Files:

- Modify: `.config/nvim/lua/plugins/smart-splits.lua`（コメントで方針を明記）
- 参照: `.config/nvim/lua/config/keymaps.lua:74-86`

Interfaces:

- Consumes: herdr の `focus_pane_left/down/up/right = prefix+h/j/k/l`（既定）
- Produces: nvim 内分割は `C-h/j/k/l`、herdr ペイン間は `prefix+h/j/k/l` という役割分担

- [ ] Step 1: 方針を確定する（decision）

herdr には smart-splits のバックエンドが存在せず、`@pane-is-vim` 相当のシームレス移動は再現できない。
方針は以下とする。

- nvim 内の分割移動は `C-h/j/k/l`（現行 keymaps.lua:74-86 のまま、nvim 内で完結）
- herdr ペイン間移動は `C-b h/j/k/l`（herdr 既定 `focus_pane_*`）
- herdr は「1 ペイン = 1 用途（agent / エディタ / シェル）」が基本のため役割分離で運用する

- [ ] Step 2: smart-splits.lua に方針コメントを追記する

`.config/nvim/lua/plugins/smart-splits.lua`:

```lua
return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	-- herdr 運用: mux バックエンドは無い。C-h/j/k/l は nvim 内分割専用、
	-- herdr ペイン間移動は prefix+h/j/k/l（herdr focus_pane_*）を使う。
	-- at_edge=stop で端では nvim 側は動かさない（herdr 側 prefix ナビへ委譲）。
	opts = { at_edge = "stop" },
}
```

- [ ] Step 3: herdr で検証する

herdr ウィンドウで確認する。

- nvim を分割し `C-h/j/k/l` で nvim 分割間を移動できる
- nvim ペインの隣に別ペインを置き `C-b h/l` で herdr ペイン間を移動できる

- [ ] Step 4: Commit する

```bash
git add .config/nvim/lua/plugins/smart-splits.lua
git commit -m "docs(herdr): split ナビを役割分離方針に確定（nvim内=C-hjkl / pane間=prefix）"
```

## Phase 7: 画像（snacks kitty graphics）の passthrough 検証

### Task 7: herdr 越しの kitty graphics を検証し config を確定する

Files:

- Modify: `.config/herdr/config.toml`（`[experimental] kitty_graphics` の有効化または見送り）

Interfaces:

- Consumes: herdr `[experimental] kitty_graphics`, Ghostty（Kitty graphics 対応）
- Produces: nvim の snacks 画像プレビュー可否の確定

- [ ] Step 1: 既定（kitty_graphics 無効）での挙動を確認する

herdr ウィンドウで nvim を開き、画像プレビューが出る操作を実行する。
Expected は以下の分岐となる。

- 正常表示なら herdr が既定で kitty graphics を通す。Step 2 は不要、Step 3 へ進む
- 崩れまたは無表示なら Step 2 で `kitty_graphics` を試す

- [ ] Step 2: `kitty_graphics` を有効化して再検証する（必要時のみ）

`.config/herdr/config.toml` の `[experimental]` に追記する。

```toml
kitty_graphics = true
```

```bash
herdr server reload-config 2>/dev/null || true
open -na Ghostty.app --args -e /opt/homebrew/bin/herdr
```

herdr ウィンドウで再度画像プレビューを確認する。
改善しなければ herdr 越しの画像は非対応と結論し、`kitty_graphics` 行は削除する。
画像が要る作業はカットオーバー後も tmux フォールバックで対応する旨をコミットに記録する。

- [ ] Step 3: Commit する

```bash
git add .config/herdr/config.toml
git commit -m "feat(herdr): kitty graphics 検証結果を config に反映"
```

## Phase 8: カットオーバーとクリーンアップ

### Task 8: Ghostty 既定を herdr へ、install.sh とドキュメントを更新する

Files:

- Modify: `.config/ghostty/config:8`（既定起動を herdr へ）、必要なら `:57+` の Cmd リマップ差分
- Modify: `scripts/darwin.sh`（`brew install herdr` を追加）
- Modify: `install.sh`（`install_tmux_plugins` の扱い）
- Modify: `.config/zsh/.zshrc:129-137`（`claude()` の tmux ブロック削除）
- Modify: `CLAUDE.md`（Stack 行を更新）

Interfaces:

- Consumes: これまでの Phase 成果一式
- Produces: 新規シェル/ウィンドウが既定で herdr 起動。tmux は明示フォールバック

- [ ] Step 1: Ghostty 既定を herdr に切替える（tmux は -e で残す）

`.config/ghostty/config:8` を置き換える。

```
# herdr を既定起動（tmux フォールバックは: open -na Ghostty.app --args -e tmux）
command = /opt/homebrew/bin/herdr
```

- [ ] Step 2: Cmd リマップの差分だけ herdr 既定に合わせる

`.config/ghostty/config:99-105` の split リマップは tmux の `%`/`"` を送る。
herdr の split は `C-b v`/`C-b -` なので herdr 用に更新する。

```
# Cmd+d -> split right (herdr: prefix+v)
keybind = cmd+d=unbind
keybind = cmd+d=text:\x02v
# Cmd+Shift+d -> split down (herdr: prefix+minus)
keybind = cmd+shift+d=unbind
keybind = cmd+shift+d=text:\x02-
```

他の Cmd リマップ（`Cmd+t`→`\x02c`, `Cmd+1..9`→`\x02`+数字, `Cmd+Shift+[]`→`\x02p/n`）は herdr 既定と一致するため変更不要である。
`Cmd+b`→`\x02v`（tmux copy-mode）は herdr に copy-mode 相当が無いため、`Cmd+b` 行は削除するか `prefix+e`（edit_scrollback=`\x02e`）へ変更する。

- [ ] Step 3: install.sh に herdr 導入を追加し、tmux プラグイン導入を任意化する

`scripts/darwin.sh` の `install_cli_tools()` 内、`brew install tmux` の直後に追加する。

```bash
  brew install herdr
```

`install.sh:34` の `install_tmux_plugins` は、tmux をフォールバックとして残す方針なら残置する。
tmux を将来完全撤去する場合はここを削除する（本移行では残置）。

- [ ] Step 4: `claude()` の死んだ tmux ブロックを削除する

`.config/zsh/.zshrc:129-137` を簡素化する。
herdr がネイティブに claude ペインを検出・ラベルするため rename は不要である。

```zsh
# claude
claude() {
  command claude "$@"
}
```

`DISABLE_AUTO_TITLE="true"`（9行目）は無害だが herdr 下では意味を持たない。
残置理由をコメントで付すか削除する（任意）。

- [ ] Step 5: CLAUDE.md の Stack 行を更新する

`CLAUDE.md` の `Stack: Ghostty → tmux → {nvim, zsh, Claude Code...}` を次に更新する。

```
Stack: Ghostty → herdr → {nvim, zsh, Claude Code...}（tmux は inert なフォールバックとして残置）
```

- [ ] Step 6: 新規 Ghostty ウィンドウで最終検証する

Ghostty を通常起動（Cmd+N 等）し、既定で herdr が立ち上がることを確認する。

- `Cmd+t` 新タブ / `Cmd+d` 右分割 / `Cmd+1..9` タブ切替 / `Cmd+Shift+[]` タブ前後
- `ts` でリポ切替 / nvim の `<leader>cc` / `C-b r`・`C-b f` popup / Claude 状態表示
- tmux フォールバック `open -na Ghostty.app --args -e tmux` で従来 tmux 環境が起動する

- [ ] Step 7: Commit する

```bash
git add .config/ghostty/config scripts/darwin.sh .config/zsh/.zshrc CLAUDE.md
git commit -m "feat(herdr): Ghostty 既定を herdr へカットオーバー、tmux をフォールバック化"
```

- [ ] Step 8: マージ判断する（finishing-a-development-branch）

全 Phase 検証後、`superpowers:finishing-a-development-branch` に従い `herdr-migration` を `main` へ統合するか決める。
統合後も tmux/* は inert フォールバックとして残る。
撤退する場合は `git checkout main` で即座に tmux 環境へ戻る。

## Self-Review メモ

- Spec coverage: 洗い出した結合点は全て対応タスクに割り当てた。
  - ghostty command は Phase 8、Cmd リマップは Phase 8
  - tmux.conf inert 化は Phase 2 と Phase 8
  - zsh ts() は Phase 3、zsh claude() は Phase 8
  - nvim cc は Phase 4、smart-splits は Phase 6、snacks 画像は Phase 7
  - tmux-claude-signal は Phase 2、popup は Phase 5
  - IME macism は Phase 1、通知は Phase 1 と Phase 2
  - resurrect/continuum は herdr `resume_agents_on_restore`（Phase 1）と tmux フォールバック残置で許容
- 未確定（実行時 discovery 必須）
  - Phase 4 の `herdr pane current` の nvim ペイン解決
  - Phase 5 の注入先ペイン解決
  - Phase 7 の kitty graphics 可否
- 型/コマンド整合: JSON パースは全て `.result.*` で統一した。
  - `workspace list` は `.result.workspaces[]`
  - `pane current` は `.result.pane.pane_id`
  - `pane split` は出力の `"pane_id"`
