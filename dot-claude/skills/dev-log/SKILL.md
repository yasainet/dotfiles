---
name: dev-log
description: [Skills] Capture logs from development servers in another tmux window.
allowed-tools: Bash(tmux *)
---

# Dev-log skill

## Steps

1. window 一覧と名前を確認する
   - 基本的に `window 1` に development server を起動している、`automatic-rename` の適用に留保せよ

```bash
tmux list-windows
```

2. `tmux capture-pane` を利用して、取得せよ

```bash
# 直近 500 行を取得
tmux capture-pane -t :1 -p -S -500

# スクロールバック全体を取得
tmux capture-pane -t :1 -p -S -

# grep でフィルタする例
tmux capture-pane -t :1 -p -S - | grep -iE "error|warn|failed" | tail -50
```
