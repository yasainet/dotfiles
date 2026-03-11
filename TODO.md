# TODO: tmux × Ghostty 責務整理

## 結論

pane / window / session すべて tmux に任せる（現状維持）。

Ghostty は純粋なターミナルエミュレータ + キーバインドプロキシとして使う。

## 理由

- Ghostty pane で分割すると、tmux の status line が片側にしか表示されない
- tmux session の中に Ghostty pane が混在すると管理が破綻する
- Ghostty の Cmd+D 等は tmux コマンドへのプロキシで十分機能している
- macOS キーバインド感は Ghostty のキーバインド設定で実現済み

## 現状の責務マップ

| 機能 | 担当 | 備考 |
|---|---|---|
| session | tmux | prefix s で切り替え |
| window(tab) | tmux | Cmd+T / Cmd+1~9 → tmux へプロキシ |
| pane | tmux | Cmd+D / Cmd+[/] → tmux へプロキシ |
| ターミナル描画 | Ghostty | キーバインドを tmux に中継 |

## 将来の検討: tmux Control Mode（Issue #1935）

mitchellh が積極的に開発中。tmux をバックエンド、Ghostty を GUI フロントエンドにする統合。

進捗（2026-03 時点）:
- [x] Control Mode DCS パーサー
- [x] tmux コマンド出力パーサー
- [x] 状態同期の協調ループ
- [ ] Termio のサブプロセス非実行対応
- [ ] API の変更
- [ ] GUI との接続

これが実装されれば:
- tmux session 管理はそのまま使える
- pane/tab は Ghostty ネイティブ UI で描画
- status line 問題が解消（Ghostty が tmux 状態を直接描画）
- 現状のキーバインドプロキシ構成がネイティブ統合に進化

→ 実装されるまでは現状維持がベスト

## その他メモ

- Ghostty pane は tmux と併用すると status line 問題が発生するため、all or nothing
- Session Manager（Discussion #3358）は 519 upvote だが公式回答なし

## 参考

- Ghostty 1.3 AppleScript: https://zenn.dev/meijin/articles/ghostty-1_3-apple-script
- Ghostty `window-save-state = always` でレイアウト復元可能（macOS のみ）
- tmux Control Mode: https://github.com/ghostty-org/ghostty/issues/1935
- Session Manager: https://github.com/ghostty-org/ghostty/discussions/3358
- tmux 代替議論: https://github.com/ghostty-org/ghostty/discussions/9007
