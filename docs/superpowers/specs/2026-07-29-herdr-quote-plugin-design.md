# herdr-quote — 選択テキストを引用してエージェントに渡す herdr プラグイン

- 日付: 2026-07-29
- ステータス: 設計承認済み
- 配布形態: 独立した OSS リポジトリ `github.com/yasainet/herdr-quote` (MIT)

## 背景

herdr のペインで動くコーディングエージェント（Claude Code など）の出力を、そのエージェント自身に引用して渡したい場面がある。「この部分について」と特定箇所を指したいとき、現状は手作業でコピーして貼り直すしかない。

このとき markdown の引用記法 `>` を付けると、次の2つが同時に得られる。

1. **指示と引用の区別** — 貼り付けた内容に命令文（「〜してください」「TODO: 〜」）が含まれるとき、`>` がないと新しい指示なのか参照なのか曖昧になる。`>` があれば「これは引用であって指示ではない」が明確に伝わる。
2. **人間側の可読性** — 送信前に自分でも引用部分を一目で識別できる。

同じ要望は Claude Code 本体にも複数寄せられているが未実装である。

- [#26716 Native quote/citation UI](https://github.com/anthropics/claude-code/issues/26716) — 「ユーザーは過去メッセージを参照するのに markdown 記法を手打ちしていて非効率かつエラーが起きやすい」
- [#58691 右クリック →「Reply to this / Quote and respond」](https://github.com/anthropics/claude-code/issues/58691)
- [#48099 REPL の選択範囲からサイドチャットを開く](https://github.com/anthropics/claude-code/issues/48099)

tmux では `copy-pipe` にコマンドを挟む定番イディオムでこれを実現できる。

```tmux
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "sed 's/^/> /'"
```

herdr には `copy-pipe` 相当がないが、プラグイン API に同等の穴が空いている。本プラグインはそこを使う。

## 調査で確定した事実

herdr 0.7.5 / protocol 17 のバンドル API スキーマ（`herdr api schema --json`）を直接確認した。

- プラグイン機構は実在する（`plugin.link` / `plugin.list` / `plugin.enable` / `plugin.disable` / `plugin.unlink`）
- アクションは `selection` コンテキストを宣言できる
  ```
  PluginActionContext = ["global", "workspace", "tab", "pane", "selection"]
  ```
- 起動時に渡る context に選択テキストとフォーカス中ペインが含まれる
  ```
  PluginInvocationContext = { selected_text, focused_pane_id, focused_pane_agent,
                              focused_pane_cwd, tab_id, workspace_id, ... }
  ```
- プラグインは任意の言語で書け、`herdr-plugin.toml` で宣言し、GitHub の `owner/repo` 形式で配布できる
- `HERDR_BIN_PATH` 経由で herdr 本体を呼び戻せる

### 実機検証（済）

Claude Code v2.1.220 を herdr のペインで起動し、`herdr pane send-text` の挙動を確認した。

| 送信方法 | 結果 |
| --- | --- |
| 行を `\x1b\r` で連結 | 送信されず、複数行として入力欄に残る。`> ` がそのまま表示される |
| 行を `\n` で連結 | 同上 |

重要な副次的発見として、**`send-text` 経由の複数行は `[Pasted text #1 +N lines]` に畳まれない**。通常の貼り付け（bracketed paste）は2行超で畳まれるが、この経路では畳まれず `> ` が可視のまま残る。したがって「LLM に伝わる」だけでなく「人間にも見える」引用になる。

両方式とも動作したが、`\x1b\r` を採用する。Claude Code が明示的に「入力欄内の改行」として解釈するシーケンスであり（Ghostty の `keybind = shift+enter=text:\x1b\r` と同じもの）、バイトの到着タイミングに依存しないため。

## スコープ

**やること** — herdr 上で選択したテキストを markdown 引用に変換し、選択したペイン自身のエージェント入力欄へ挿入する。

**やらないこと**（初版では意図的に外す）

- 送り先ペインの選択 UI（選択元のペインに固定する）
- 引用記号やテンプレートの設定機能
- クリップボードへの書き戻し
- 「ファイルパスとして渡す」「別エージェントに送る」等の追加アクション

## 設計

### リポジトリ構成

```
herdr-quote/
├── herdr-plugin.toml
├── quote.sh            # 本体（変換 + 注入）
├── test/quote_test.sh  # 変換ロジックのテスト
├── .github/workflows/test.yml
├── README.md
└── LICENSE
```

### マニフェスト

```toml
id = "yasainet.quote"
name = "Quote"
version = "0.1.0"
min_herdr_version = "0.7.0"
description = "Quote the selected text into the agent prompt of the same pane"

[[actions]]
id = "quote-selection"
title = "Quote selection into prompt"
contexts = ["selection"]
command = ["bash", "quote.sh"]
platforms = ["macos", "linux"]
```

`platforms` に `windows` を含めないのは本体を bash で書くため。将来必要になれば移植を検討する。

### 利用者側の設定

```toml
[[keys.command]]
key = "prefix+shift+y"
type = "plugin_action"
command = "yasainet.quote.quote-selection"
```

### データフロー

1. ユーザーが herdr のペインでテキストを選択し、割り当てたキーを押す
2. herdr が `quote.sh` を起動し、context を渡す
3. `quote.sh` が `selected_text` と `focused_pane_id` を読む
4. `quote_lines()` が変換する
   - 各行頭に `> ` を付ける
   - 空行にも `> ` を付ける（引用ブロックを途切れさせないため）
   - 末尾に空行を1つ足す（ユーザーが続けて自分の言葉を書けるように）
5. 変換後の行を `\x1b\r` で連結する
6. `"$HERDR_BIN_PATH" pane send-text "$focused_pane_id" "$payload"` で注入する

クリップボードを経由しないため、コピー内容を壊さない。`pbpaste` / `wl-paste` の OS 分岐も不要。

### 変換の例

入力（選択テキスト）

```
テストは全件通過しました。

ただし flaky なものが1件あります。
```

出力（入力欄に挿入されるもの）

```
> テストは全件通過しました。
>
> ただし flaky なものが1件あります。

```

### モジュール境界

`quote.sh` は2つの責務に分ける。

| 関数 | 責務 | 依存 |
| --- | --- | --- |
| `quote_lines()` | 文字列 → 引用形式の文字列。副作用なし | なし |
| `main()` | context の読み取り、`quote_lines()` の呼び出し、`send-text` の実行 | herdr, 環境変数 |

テスト対象は `quote_lines()` のみとする。`main()` は herdr が動いている環境でしか動かないため、手動確認に委ねる。

### エラー処理

| 条件 | 挙動 |
| --- | --- |
| `selected_text` が空 or 未設定 | 何もせず exit 0（無言。誤爆時にノイズを出さない） |
| `focused_pane_id` が未設定 | stderr にメッセージを出して exit 1（herdr の plugin log に残る） |
| `send-text` が失敗 | herdr の終了コードをそのまま返す |
| 巨大な選択 | 上限を設けず素通しする |

### テスト

`test/quote_test.sh` で `quote.sh` を source し、`quote_lines()` を検証する。

- 1行
- 複数行
- 空行を含む
- 末尾が改行で終わる入力 / 終わらない入力
- 既に `>` で始まる行（二重に付けてネストさせる。markdown の意味論として正しい）
- 空文字列

CI は GitHub Actions で `bash test/quote_test.sh` を macOS と Ubuntu の両方で走らせる。

## 未確定リスク

`selected_text` にターミナルの折り返し（soft wrap）由来の改行が含まれるかは未確認である。含まれる場合、見た目の行ごとに `> ` が付き、本来1つの段落が複数行の引用に割れる。

実装の最初のステップで実データを確認し、折り返しが混入するなら unwrap 処理を足す。混入しないなら何もしない。この判断は実装計画の Step 1 に置く。

## OSS 化の見立て

公開する価値があると判断した。

1. **需要が実在する** — 上記の Claude Code issue 群のとおり、同じことをしたい人が複数いて、本体には未実装
2. **agent-agnostic である** — herdr は 14 種のエージェント（claude, codex, opencode, droid, cursor 等）に対応しており、Claude Code 本体に quote 機能が入っても他エージェントでの価値が残る
3. **リファレンス実装になる** — herdr のプラグイン API は "early host surface" と位置づけられた新しい機構で、`selection` コンテキストを使う小さな実例は読まれる価値がある

機能が小さいことは欠点ではなく、この文脈では利点として働く。

配布は GitHub リポジトリに `herdr-plugin` トピックを付ける。README には動作を示す GIF を置く。
