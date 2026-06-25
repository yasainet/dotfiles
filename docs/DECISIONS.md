# Decisions

不可逆な技術選定と包括判断のみを 1 行で残す。
詳細は spec / commit / コードを参照する。

## 2026-06-26 cross-session indicator は tmux.conf で手動ワイヤリング

- cross-session indicator は plugin が自動 prepend するのではなく、dotfiles の `.config/tmux/tmux.conf` で status-right に手動で 1 行追加する。
- 理由: plugin はコア状態管理に注力し、統合端点の選択肢 (status-right 以外の UI も検討可能) を open に保つため。
- 実装: theme source 後に `set -ag status-right "#(#{TMUX_CLAUDE_SIGNAL_DIR}/scripts/cross-session.sh #{client_session})"` を追加。
