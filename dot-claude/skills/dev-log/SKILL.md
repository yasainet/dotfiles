---
name: dev-log
description: [Skills] Capture logs from development servers in another tmux window.
allowed-tools: Bash(tmux *)
---

# dev-log

## 前提

- User は常に tmux session で nvim or nvim / claude code を起動している
- `npm run dev`, `stripe`, `cloudflare`, `ngrok` など、claude code とは別の tmux window で起動している
- `stdout` を確認するために `tmux capture-pane` を利用せよ

## 手順

1. window 一覧と名前を確認する (基本的に `window 1` に development server を起動している、`automatic-rename` の適用に留保せよ）

```bash
tmux list-windows
```

2. 直近 500 行を取得

```bash
tmux capture-pane -t :1 -p -S -500
```

3. スクロールバック全体を取得 (`history-limit 50000`)

```bash
tmux capture-pane -t :1 -p -S -
```

4. grep でフィルタする例

```bash
tmux capture-pane -t :1 -p -S - | grep -iE "error|warn|failed" | tail -50
```

## 注意

- `capture-pane` はあくまでスナップショット取得である
  - 継続的な監視（tail -f 相当）はできないため、再度ログを見たいなら都度実行する
- ANSI エスケープが含まれる場合は `-e` フラグで色付き、無印で平文
- pane が分割されている window で特定 pane を狙うなら `-t :1.0` のように `window.pane` 形式で指定する
