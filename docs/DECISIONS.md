# Decisions

不可逆な技術選定と包括判断のみを 1 行で残す。
詳細は spec / commit / コードを参照する。

## 2026-06-26 cross-session indicator は theme ファイルに直接組み込む

- 決定: `.config/tmux/themes/tokyonight_night.tmux` の `set -g status-right` 先頭に `#(.../cross-session.sh '#{client_session}')` を差し込む。
- 理由: 「時計の左に prepend する」UX を実現する手段として、tmux に prepend syntax がないため theme の status-right を直接書き換える方式を採る。
- 詳細: tmux.conf の `set -ag` 経由では右端 append にしかならないため、placement 制御のために theme を一次ソースとする。`#{client_session}` は session 名に空白が含まれる場合に備えて single-quote で囲む。
