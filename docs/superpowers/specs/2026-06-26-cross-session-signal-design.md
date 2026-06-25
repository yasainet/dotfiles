# tmux-claude-signal cross-session status indicator

Date: 2026-06-26

他 tmux session の claude 状態を attached client の status-right に最小サイン (`●`) で集約表示する。

## 背景

現状の tmux-claude-signal は同一 session 内 window に対して claude 状態 (needs-input / done / off) を window-status の色で表示する。
これにより 1 session 内の並列 claude の状態管理 UX は確立した。

一方、ユーザーは 1〜3 session を日常的に並行運用しており、別 session の claude 状態は `C-q` (choose-tree) を開かないと把握できない。
Ghostty がアクティブな間は OS 通知も来ないため、別 session に対応すべき変化が起きても気付けない。

世間の解決策 (menubar 常駐、dashboard 化) はユーザーの less is more 方針に対して過剰である。
tmux default の status bar を活かしつつ、最小情報追加で「他 session に対応すべき何かがあるか」だけ気付ける状態を作る。

## 非目標

- 件数の正確把握。気付ければ十分。
- どの session か特定。`C-q` で確認すれば足りる。
- OS 通知や音、menubar 連携。tmux 内で完結させる。

## ゴール

attached client の status bar を見ていれば、他 session のどこかに `needs-input` または `done` の window があるかが視界に入る。

## UI 仕様

### 表示位置

`status-right` の左側に prepend する 1 ブロック。
`status-left` (session 名) と `window-status` (現 session の window 列) は変更しない。

### 表示形式

記号は `●` (Unicode U+25CF) のみ。
Nerd Font 非依存で SSH 先 fallback も担保する。

色は `needs-input` = 黄、`done` = 赤とする。
これは tmux-claude-signal の既存 default 配色 (`@claude-signal-needs-input-bg=yellow`, `@claude-signal-done-bg=red`) を fg として再利用する。

数字は出さない。
同 state の window が複数あっても `●` は 1 個。

並び順は needs-input (黄) → done (赤) の順で左から。
該当ゼロの state は表示しない。
両方ゼロなら status-right に何も追加しない。

### ケース別の見え方

attach 中 = `anglers-docs`、他 session = `replace` の状態に応じた表示。

| 他 session の状態 | status-right prepend 部 |
|---|---|
| 何もなし | (空) |
| needs-input のみ | 黄 `●` |
| done のみ | 赤 `●` |
| 両方あり | 黄 `●` 赤 `●` |

## 内部仕様

### state marker (window option)

tmux-claude-signal の `state.sh` が `apply_style` / `clear_style` するタイミングで、同一 window option として `@claude-signal-state` を set / unset する。
値は `needs-input` または `done`。
off の場合は unset。

| state | window-status-style (既存) | `@claude-signal-state` (新規) |
|---|---|---|
| needs-input | `bg=yellow,fg=black` | `needs-input` |
| done | `bg=red,fg=black` | `done` |
| off | (unset) | (unset) |

この option は read-only な状態 marker として公開する。
集約スクリプトおよび将来の外部監視ツールが参照する。

### 集約スクリプト

新規ファイル `scripts/cross-session.sh` を追加する。

引数は `$1` に attached client の session 名 (`#{client_session}` 由来)。

処理は次の順序で実行する。

- [ ] `tmux list-windows -a -F '#{session_name}|#{@claude-signal-state}'` で全 window の state marker を取得
- [ ] 自 session (`$1` と一致) を除外
- [ ] needs-input の存在有無、done の存在有無を判定
- [ ] tmux format 文字列を stdout に出力、0 件なら空文字

出力例。

- 両方なし: (空文字)
- needs-input のみ: `#[fg=yellow]●#[default] `
- done のみ: `#[fg=red]●#[default] `
- 両方: `#[fg=yellow]●#[default] #[fg=red]●#[default] `

末尾に半角空白 1 つを付け、status-right 既存ブロックとの間隔を作る。

### 更新トリガー

既存の `state.sh` 末尾の `tmux refresh-client -S` をそのまま流用する。

ユーザー環境は 1 ghostty ウィンドウ = tmux client 1 つの運用が常態である。
`refresh-client -S` が唯一の attached client を即時再描画する。
status-right の `#(...)` も同タイミングで再評価される。
追加の polling や `status-interval` 短縮は不要。

### status-right への組み込み

dotfiles の `.config/tmux/tmux.conf` で theme source の後に 1 行追加する。

```sh
set -ag status-right "#(#{TMUX_CLAUDE_SIGNAL_DIR}/scripts/cross-session.sh #{client_session})"
```

`TMUX_CLAUDE_SIGNAL_DIR` は plugin 本体が `tmux-claude-signal.tmux` で global env として export 済み。
絶対パス埋め込みは不要。

`#{client_session}` は tmux 3.0+ で `#(...)` 引数として format 展開される。
`set -ag` で既存 status-right に append する。
位置は status-right の末尾になるが、format 評価順は左→右で `cross-session.sh` の出力が時計・hostname の左に並ぶ。

## 実装変更点

### tmux-claude-signal (plugin) 側

- [ ] `scripts/state.sh` の `apply_style` に 1 行追加: `tmux set-window-option -qt "$window_id" "@claude-signal-state" "$state"`
- [ ] `scripts/state.sh` の `clear_style` に 1 行追加: `tmux set-window-option -qut "$window_id" "@claude-signal-state" || true`
- [ ] `scripts/focus-ack.sh` の clear ブロックに 1 行追加: `tmux set-window-option -qut "$window_id" "@claude-signal-state" || true`
- [ ] `scripts/cross-session.sh` を新規作成 (上記「集約スクリプト」の挙動)
- [ ] `tests/lib/test-lib.sh` に新規 helper `get_state_marker` を追加
- [ ] `tests/test-state-transitions.sh` / `tests/test-focus-ack.sh` に `@claude-signal-state` set/unset 検証を追加
- [ ] `tests/test-cross-session.sh` を新規作成 (5 ケース)
- [ ] `README.md` / `CLAUDE.md` の Scope 記述更新と Glossary 追記、設定例の追加

### dotfiles 側

- [ ] `.config/tmux/tmux.conf` の theme source 後に `set -ag status-right "#(#{TMUX_CLAUDE_SIGNAL_DIR}/scripts/cross-session.sh #{client_session})"` を追加

## scope 拡張の正当化

tmux-claude-signal の CLAUDE.md は「Scope is intentionally narrow (single session, single agent, window-status only)」と明記している。
本変更はこのうち "single session" 制約を緩める。

元の narrow scope は「着色対象の範囲」 = どの window を色変えするかを限定する宣言である。
本変更は着色対象は同 session 内 window のみで不変。
「他 session の状態を読み取って status-right に集約表示する」のは別レイヤであり、着色対象は拡張していない。

state marker (`@claude-signal-state`) の公開は scope を一切汚さず、純粋に API surface 追加である。

CLAUDE.md の Scope 記述は「着色は同 session 内 window のみ、state marker は全 session の集約に利用可能」と更新する。

## 副作用

全 window が `@claude-signal-state` option を持ち得る。
state が走った window のみ set される。
`tmux list-windows -F` で常に空文字 fallback されるので副作用はない。

`cross-session.sh` は status update のたびに実行される (`refresh-client -S` 経由)。
`tmux list-windows -a` は session 数 × 平均 window 数に比例する I/O だが、常用規模 (1〜3 session × 数 window) では無視できる。

## 検証

- [ ] `bash tests/run-all.sh` が全 pass
- [ ] 2 session 構成で片方を attach、もう片方の claude を needs-input / done に駆動
- [ ] 自 session の window-status が色付くこと (既存挙動の維持)
- [ ] 同時に attached client の status-right に黄 `●` が現れること (新挙動)
- [ ] state を off にすると status-right から消えること
- [ ] ghostty 再起動後、tmux-resurrect 復帰時に `@claude-signal-state` が復元されないこと (option は揮発が正)

## DECISIONS.md に流す事項

実装完了後、次の判断を流す。
判断主体に応じて plugin / dotfiles の DECISIONS.md を使い分ける。

plugin 側 (`.config/tmux/plugins/tmux-claude-signal/docs/DECISIONS.md`) に流す。

- [ ] 2026-06-26: scope を「同 session 着色 + 全 session state marker 公開」に拡張
- [ ] 2026-06-26: state marker は window option `@claude-signal-state` で公開、値は needs-input / done / (unset)
- [ ] 2026-06-26: cross-session indicator の記号は `●` (Unicode) 単一、色 (黄/赤) で done/needs-input を区別、件数は出さない

dotfiles 側 (`docs/DECISIONS.md` を新規作成) に流す。

- [ ] 2026-06-26: status-right の cross-session indicator は plugin 自動 prepend ではなく `tmux.conf` で手動 1 行追加とする

## 未決事項

なし。
