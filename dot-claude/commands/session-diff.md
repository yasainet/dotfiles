---
description: session 開始時の HEAD からの累積 diff を hunk で開く
---

`~/ghq/github.com/yasainet/dotfiles/dot-claude/scripts/session-diff.sh` を Bash で実行してください。
標準出力と標準エラーの内容をそのまま提示してください。

- reload できた場合はその旨を 1 文で伝える
- fallback コマンドが印字された場合は fenced code block でそのまま示す
- ユーザーが別窓で叩けるように整形する
- git repo 外や base 未記録のエラーが返った場合はエラー本文と対処を淡々と伝える

対処は「session 再起動」または「手動 base 設定」を提示する。
追加の分析や解釈は不要。
スクリプトの出力を通す係に徹する。
