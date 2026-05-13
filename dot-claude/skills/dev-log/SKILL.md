---
name: dev-log
description: Capture logs from dev servers or background processes (npm run dev, supabase, storybook, etc.) running in another tmux window. Use for debugging errors, HMR issues, request logs, and build failures.
allowed-tools: Bash(tmux *)
---

# dev-log

## 前提環境

ユーザーは 常に tmux セッション内で nvim / claude code を起動している。
長時間プロセス（dev サーバー、Supabase、Storybook 等）は
**claude code が動いている window とは別の window** で起動されている。

つまり claude code 自身からはそのプロセスの stdout を直接見られない。代わりに
`tmux capture-pane` で他 window のスクロールバックを吸い出す。

## 手順

1. `$TMUX` が未設定なら tmux 環境ではない。本スキルは適用できないため、ユーザーに
   ログの所在を確認する
2. `tmux list-windows` で window 一覧と名前を確認する
3. 対象 window を特定する。tmux の `automatic-rename` により window 名は
   フォアグラウンドプロセス名になる点に注意。判別ロジック:
   - `node` / `next` / `npm` / `supabase` / `deno` / `bun` 等のプロセス名であれば
     dev サーバー候補として優先
   - claude code が動く window は `claude` / `claude-` と表示されるため除外する
   - 候補が複数ある場合や不明な場合は window 1 を第一候補とする
     （ユーザーの慣習: window 1 を dev 用に使う）
   - それでも自信がなければユーザーに尋ねる
4. ログを取得する:

   ```bash
   # 直近 500 行（デフォルト）
   tmux capture-pane -t :1 -p -S -500

   # window 名で指定する場合
   tmux capture-pane -t dev -p -S -500

   # スクロールバック全体（history-limit 50000）
   tmux capture-pane -t :1 -p -S -
   ```

5. 出力が大きすぎる場合は `-S` の遡及行数を絞るか、grep でフィルタする:

   ```bash
   tmux capture-pane -t :1 -p -S - | grep -iE "error|warn|failed" | tail -50
   ```

## 注意

- `capture-pane` はあくまでスナップショット取得。継続的な監視（tail -f 相当）は
  できない。再度ログを見たいなら都度実行する
- ANSI エスケープが含まれる場合は `-e` フラグで色付き、無印で平文
- pane が分割されている window で特定 pane を狙うなら `-t :1.0` のように
  `window.pane` 形式で指定する
