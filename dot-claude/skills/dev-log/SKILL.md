---
name: dev-log
description: [Skills] Capture logs from development servers in another tmux window.
allowed-tools: Bash(tmux *)
---

# Dev-log skill

## Steps

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
