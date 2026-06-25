# Decisions

不可逆な技術選定と包括判断のみを 1 行で残す。
詳細は spec / commit / コードを参照する。

## 2026-06-26 cross-session indicator は theme ファイルに直接組み込む

- 決定: `.config/tmux/themes/tokyonight_night.tmux` の `set -g status-right` 先頭に `#(.../cross-session.sh '#{client_session}')` を差し込む。
- 理由: 「時計の左に prepend する」UX を実現する手段として、tmux に prepend syntax がないため theme の status-right を直接書き換える方式を採る。
- 詳細: tmux.conf の `set -ag` 経由では右端 append にしかならないため、placement 制御のために theme を一次ソースとする。`#{client_session}` は session 名に空白が含まれる場合に備えて single-quote で囲む。

## 2026-06-26 status-right を hostname 削除 + 日時短縮 + dot を時計 chip に統合

- 決定: machine 名 chip を削除し、日時から年を削除して `MM-dd (Day) HH:mm` に短縮、claude state dot を時計 chip 内 (時計の左) に統合する。
- 理由: ssh 先 terminal を開かない運用 (Vercel メイン) のため hostname は不要。年情報も冗長。chip 統合で視覚密度を下げつつ気付き性は保つ。
- 詳細: theme 内で `#(.../cross-session.sh '#{client_session}')` を時計 chip 先頭に挿入、script は `#[fg=...]● ` の fg-only セグメントを連続出力、bg は chip の `#3b4261` を inherit する。script 呼出後に theme 側で `#[fg=#7aa2f7]` を再設定して時計の fg を復元する。
