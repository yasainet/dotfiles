# herdr-quote Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** herdr のペインで選択したテキストを markdown 引用に変換し、同じペインのエージェント入力欄へ挿入する herdr プラグインを作り、OSS として公開する。

**Architecture:** herdr のプラグイン API の `selection` アクションコンテキストを使う。herdr が選択テキストを `HERDR_PLUGIN_CONTEXT_JSON` に入れてプラグインプロセスを起動するので、bash スクリプトがそれを読んで各行に `> ` を付け、`herdr pane send-text` で選択元ペインへ書き戻す。クリップボードは経由しない。

**Tech Stack:** bash（本体）、jq または python3（JSON パース）、herdr 0.7+ のプラグイン API、GitHub Actions（CI）

## Global Constraints

- 作業ディレクトリは `/Users/yasainet/ghq/github.com/yasainet/herdr-quote`（新規リポジトリ。dotfiles とは別）
- bash 3.2 互換で書く。macOS 標準の `/bin/bash` は 3.2 系で、マニフェストの `command = ["bash", "quote.sh"]` は PATH 上の bash を引くため。**使用禁止:** `mapfile` / `readarray`、連想配列（`declare -A`）、`${var^^}` / `${var,,}`、`&>>`
- プラグイン ID は `yasainet.quote`、アクション ID は `quote-selection`。herdr 上での完全名は `yasainet.quote.quote-selection`
- `min_herdr_version = "0.7.0"`
- `platforms = ["macos", "linux"]`（windows は対象外）
- ライセンスは MIT、著作権者は `yasainet`
- 引用形式は「各行頭に `> `、空行は `>` 単体（末尾スペースなし）、全体の末尾に空行を1つ」
- ペインへ送る改行は `\n` ではなく `\x1b\r`（ESC + CR）を使う
- JSON パースは `jq` を優先し、無ければ `python3` にフォールバックする。どちらも無ければエラー終了する
- コミットメッセージは英語、Conventional Commits 形式

---

### Task 1: リポジトリ雛形とマニフェスト、herdr への登録疎通

herdr が実際にどんな context を渡してくるかを目視で確定させる。spec に残した唯一の未確定リスク（`selected_text` に折り返し由来の改行が混ざるか）をここで解消する。

**Files:**
- Create: `herdr-plugin.toml`
- Create: `quote.sh`
- Create: `.gitignore`

**Interfaces:**
- Consumes: なし（最初のタスク）
- Produces: プラグイン ID `yasainet.quote`、アクション ID `quote-selection`。`quote.sh` が bash スクリプトとして起動可能であること。

- [ ] **Step 1: リポジトリを作る**

```bash
mkdir -p /Users/yasainet/ghq/github.com/yasainet/herdr-quote
cd /Users/yasainet/ghq/github.com/yasainet/herdr-quote
git init
```

- [ ] **Step 2: `.gitignore` を書く**

```
*.log
.DS_Store
```

- [ ] **Step 3: `herdr-plugin.toml` を書く**

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

- [ ] **Step 4: context をダンプするだけの `quote.sh` を書く**

これは調査用の一時的な中身。Task 3 で本実装に置き換える。

```bash
#!/usr/bin/env bash
set -uo pipefail

dump="${TMPDIR:-/tmp}/herdr-quote-context.json"
{
  echo "--- env ---"
  env | grep '^HERDR_' | sort
  echo "--- context json ---"
  printf '%s\n' "${HERDR_PLUGIN_CONTEXT_JSON:-<unset>}"
} > "$dump" 2>&1
```

- [ ] **Step 5: herdr にプラグインを登録する**

```bash
cd /Users/yasainet/ghq/github.com/yasainet/herdr-quote
herdr api snapshot > /dev/null   # herdr が起きていることの確認
herdr plugin link --path "$PWD" 2>&1 || herdr api plugin.link --path "$PWD"
herdr plugin list
```

`herdr plugin` サブコマンドが CLI に無い場合は、socket API の `plugin.link` を直接叩く。`herdr api schema --json` の `PluginLinkParams` が `{ "path": "...", "enabled": true }` を取る。

期待: `plugin list` の出力に `yasainet.quote` と、その `actions` に `quote-selection` が含まれる。

- [ ] **Step 6: キーバインドを一時的に足して発火させる**

`~/.config/herdr/config.toml` に追記する。

```toml
[[keys.command]]
key = "prefix+shift+y"
type = "plugin_action"
command = "yasainet.quote.quote-selection"
```

反映する。

```bash
herdr server reload-config
```

- [ ] **Step 7: 実際に選択して発火し、ダンプを読む**

herdr のペインで **意図的に折り返しが起きる長い行を含む複数行**をドラッグ選択し、`prefix+shift+y` を押す。そのあと:

```bash
cat "${TMPDIR:-/tmp}/herdr-quote-context.json"
```

確認すること:

1. `HERDR_PLUGIN_CONTEXT_JSON` に `selected_text` が入っているか
2. `focused_pane_id` が入っているか。入っていなければ `HERDR_PANE_ID` が使えるか
3. **`selected_text` の中で、折り返した長い行が1行のままか、複数行に割れているか**

3 で割れていた場合のみ、Task 2 の `quote_lines` の前段に unwrap 処理を足す判断をする。割れていなければ何もしない。この結果を Step 8 のコミットメッセージ本文に書き残す。

- [ ] **Step 8: コミット**

```bash
git add .gitignore herdr-plugin.toml quote.sh
git commit -m "chore: scaffold plugin manifest and context probe"
```

---

### Task 2: `quote_lines` の実装（TDD）

引用変換を副作用のない純関数として作る。ここがプラグインの本体ロジックで、テスト対象はこの関数だけ。

**Files:**
- Modify: `quote.sh`
- Create: `test/quote_test.sh`

**Interfaces:**
- Consumes: Task 1 の `quote.sh`（中身は置き換える）
- Produces:
  - `quote_lines <text> [separator]` — 第1引数のテキストを引用形式に変換し、標準出力へ書く。第2引数は行の連結文字（省略時は改行 `\n`）。出力は「引用済みの各行 + 末尾の空要素」を separator で連結したもの。
  - `QUOTE_LIB_ONLY` — この環境変数が設定されているとき `quote.sh` は関数定義のみ行い `main` を実行しない（テストから source するため）。

**設計上の注意（実装前に読むこと）**

出力は「引用行の配列に空文字列を1つ足して、separator で join したもの」と定義する。

入力 `"a\nb"` の場合:
- 引用行 = `> a`, `> b`
- 空要素を足す = `> a`, `> b`, `""`
- separator が `\n` → `"> a\n> b\n"`
- separator が `\x1b\r` → `"> a\x1b\r> b\x1b\r"`

separator を引数にするのは、bash のコマンド置換 `$(...)` が**末尾の改行を捨てる**ため。separator が `\x1b\r` のときは末尾が改行ではないので `$(...)` で安全に受け取れる。テストは既定の `\n` を使うので、比較時にセンチネル文字を足して末尾を守る。

- [ ] **Step 1: 失敗するテストを書く**

`test/quote_test.sh`:

```bash
#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
QUOTE_LIB_ONLY=1 . "$SCRIPT_DIR/quote.sh"

fail_count=0
pass_count=0

# assert_quote <name> <input> <expected>
# 末尾の改行がコマンド置換で消えるのを防ぐため、両辺に "|" を足して比較する。
assert_quote() {
  local name="$1" input="$2" expected="$3"
  local actual
  actual="$(quote_lines "$input"; printf '|')"
  expected="${expected}|"
  if [ "$actual" = "$expected" ]; then
    pass_count=$((pass_count + 1))
    printf 'ok   - %s\n' "$name"
  else
    fail_count=$((fail_count + 1))
    printf 'FAIL - %s\n' "$name"
    printf '  expected: %s\n' "$(printf '%s' "$expected" | od -c | head -5)"
    printf '  actual:   %s\n' "$(printf '%s' "$actual" | od -c | head -5)"
  fi
}

assert_quote "single line" \
  "hello" \
  "> hello
"

assert_quote "multiple lines" \
  "alpha
beta" \
  "> alpha
> beta
"

assert_quote "blank line becomes bare gt" \
  "alpha

beta" \
  "> alpha
>
> beta
"

assert_quote "trailing newline does not add phantom line" \
  "alpha
" \
  "> alpha
"

assert_quote "already quoted line nests" \
  "> inner" \
  "> > inner
"

assert_quote "empty input produces nothing" \
  "" \
  ""

assert_quote "leading whitespace is preserved" \
  "    indented" \
  ">     indented
"

# separator を差し替えられること
sep_actual="$(quote_lines "a
b" $'\x1b\r')"
sep_expected="$(printf '> a\x1b\r> b\x1b\r')"
if [ "$sep_actual" = "$sep_expected" ]; then
  pass_count=$((pass_count + 1))
  printf 'ok   - custom separator\n'
else
  fail_count=$((fail_count + 1))
  printf 'FAIL - custom separator\n'
fi

printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
[ "$fail_count" -eq 0 ]
```

- [ ] **Step 2: テストを実行して落ちることを確認する**

```bash
cd /Users/yasainet/ghq/github.com/yasainet/herdr-quote
bash test/quote_test.sh
```

期待: `quote_lines: command not found` で落ちる（Task 1 の `quote.sh` にはまだ関数が無いため）。

- [ ] **Step 3: `quote_lines` を実装する**

`quote.sh` を次の内容に置き換える。

```bash
#!/usr/bin/env bash
set -uo pipefail

# quote_lines <text> [separator]
#
# text の各行頭に "> " を付ける。空行は "> " ではなく ">" にする（末尾スペースを避けるため）。
# 変換後の行の末尾に空要素を1つ足し、separator で連結して標準出力に書く。
# separator の既定値は改行。
quote_lines() {
  local input="$1"
  local sep="${2-$'\n'}"

  if [ -z "$input" ]; then
    return 0
  fi

  # 末尾の改行をちょうど1つ落とす。落とさないと空の行を1つ余計に引用してしまう。
  input="${input%$'\n'}"

  local out=""
  local line
  while IFS= read -r line; do
    if [ -z "$line" ]; then
      out="${out}>${sep}"
    else
      out="${out}> ${line}${sep}"
    fi
  done <<< "$input"

  printf '%s' "$out"
}
```

- [ ] **Step 4: テストを実行して通ることを確認する**

```bash
bash test/quote_test.sh
```

期待: `8 passed, 0 failed`

- [ ] **Step 5: コミット**

```bash
git add quote.sh test/quote_test.sh
git commit -m "feat: add quote_lines conversion with tests"
```

---

### Task 3: context の読み取りとペインへの注入

`quote_lines` を herdr に繋ぐ。ここで初めて副作用が入る。

**Files:**
- Modify: `quote.sh`

**Interfaces:**
- Consumes: Task 2 の `quote_lines <text> [separator]` と `QUOTE_LIB_ONLY`
- Produces:
  - `json_field <json> <field>` — JSON 文字列から指定したトップレベル文字列フィールドを取り出して標準出力に書く。値が無ければ何も書かずに終了コード 0 を返す。
  - `main` — context を読み、変換し、`herdr pane send-text` を呼ぶ。

- [ ] **Step 1: `json_field` と `main` を `quote.sh` の末尾に足す**

Task 2 で書いた `quote_lines` の下に追記する。

```bash
# json_field <json> <field>
#
# トップレベルの文字列フィールドを取り出す。jq を優先し、無ければ python3 を使う。
# どちらも無ければ終了コード 127 で落ちる。
json_field() {
  local json="$1" field="$2"

  if command -v jq > /dev/null 2>&1; then
    printf '%s' "$json" | jq -r --arg f "$field" '.[$f] // empty'
    return 0
  fi

  if command -v python3 > /dev/null 2>&1; then
    printf '%s' "$json" | python3 -c '
import json, sys
field = sys.argv[1]
try:
    data = json.load(sys.stdin)
except ValueError:
    sys.exit(0)
value = data.get(field)
if isinstance(value, str):
    sys.stdout.write(value)
' "$field"
    return 0
  fi

  echo "herdr-quote: neither jq nor python3 is available" >&2
  return 127
}

main() {
  local context="${HERDR_PLUGIN_CONTEXT_JSON:-}"
  if [ -z "$context" ]; then
    echo "herdr-quote: HERDR_PLUGIN_CONTEXT_JSON is not set" >&2
    return 1
  fi

  local selected
  selected="$(json_field "$context" selected_text)" || return $?

  # 選択が空なら黙って終わる。誤爆時にノイズを出さないため。
  if [ -z "$selected" ]; then
    return 0
  fi

  local pane
  pane="$(json_field "$context" focused_pane_id)" || return $?
  if [ -z "$pane" ]; then
    pane="${HERDR_PANE_ID:-}"
  fi
  if [ -z "$pane" ]; then
    echo "herdr-quote: no target pane in context" >&2
    return 1
  fi

  local herdr_bin="${HERDR_BIN_PATH:-herdr}"

  local payload
  payload="$(quote_lines "$selected" $'\x1b\r')"

  "$herdr_bin" pane send-text "$pane" "$payload"
}

if [ -z "${QUOTE_LIB_ONLY:-}" ]; then
  main "$@"
fi
```

- [ ] **Step 2: 既存のテストが壊れていないことを確認する**

```bash
bash test/quote_test.sh
```

期待: `8 passed, 0 failed`（`QUOTE_LIB_ONLY=1` により `main` は走らない）

- [ ] **Step 3: `main` のエラー経路を手で確認する**

```bash
cd /Users/yasainet/ghq/github.com/yasainet/herdr-quote

# context 無し
bash quote.sh; echo "exit=$?"
# 期待: "herdr-quote: HERDR_PLUGIN_CONTEXT_JSON is not set" / exit=1

# 選択が空
HERDR_PLUGIN_CONTEXT_JSON='{"selected_text":"","focused_pane_id":"x"}' bash quote.sh; echo "exit=$?"
# 期待: 何も出力せず exit=0
```

- [ ] **Step 4: 実際のペインへ注入して確認する**

検証用のタブとペインを立てる。

```bash
TAB_JSON="$(herdr tab create --workspace "$(herdr pane current | jq -r '.result.pane.workspace_id')" --label quote-check --no-focus)"
PANE="$(printf '%s' "$TAB_JSON" | jq -r '.result.root_pane.pane_id')"
echo "PANE=$PANE"
herdr pane run "$PANE" "claude"
sleep 12
```

そのペインを狙って注入する。

```bash
HERDR_PLUGIN_CONTEXT_JSON="$(jq -nc --arg t 'テストは全件通過しました。

ただし flaky なものが1件あります。' --arg p "$PANE" '{selected_text:$t, focused_pane_id:$p}')" \
  bash quote.sh
sleep 2
herdr pane read "$PANE" --source visible --lines 20
```

期待する見え方:

```
❯ > テストは全件通過しました。
  >
  > ただし flaky なものが1件あります。
  
```

確認すること: 送信されていないこと（Claude が応答を始めていないこと）、`[Pasted text #1]` に畳まれていないこと、空行が `>` 単体になっていること。

片付ける。

```bash
herdr tab close "$(printf '%s' "$TAB_JSON" | jq -r '.result.tab.tab_id')"
```

- [ ] **Step 5: 実際に選択して発火させる**

Task 1 で入れたキーバインドはそのまま使える。herdr のペインで Claude Code の出力を選択し、`prefix+shift+y` を押す。入力欄に引用が入ることを目視で確認する。

うまくいかない場合は herdr のプラグインログを見る。

```bash
herdr api plugin.log_list 2>/dev/null || herdr plugin log
```

- [ ] **Step 6: コミット**

```bash
git add quote.sh
git commit -m "feat: read selection from plugin context and inject into pane"
```

---

### Task 4: ドキュメント、CI、公開

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `.github/workflows/test.yml`

**Interfaces:**
- Consumes: Task 2 の `test/quote_test.sh`、Task 3 で動作確認済みの `quote.sh`
- Produces: 公開された GitHub リポジトリ

- [ ] **Step 1: `LICENSE` を書く**

MIT ライセンスの全文を置く。著作権行は次のとおり。

```
Copyright (c) 2026 yasainet
```

- [ ] **Step 2: `README.md` を書く**

```markdown
# herdr-quote

Quote the selected text into the agent prompt of the same pane.

Select any text in a [herdr](https://herdr.dev) pane, hit a key, and it comes
back into that pane's prompt as a markdown blockquote.

## Why

When you want to point a coding agent at a specific part of its own output,
you normally copy it and paste it back by hand. Marking it with `>` does two
things:

- **It separates a quote from an instruction.** If the text you paste contains
  imperative sentences, the agent cannot tell whether they are a new
  instruction or a reference. `>` makes that unambiguous.
- **You can see it too.** Text sent this way is not collapsed into
  `[Pasted text #1 +N lines]`, so the quote stays readable before you submit.

This is the herdr equivalent of the classic tmux idiom:

    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "sed 's/^/> /'"

It works with any agent herdr detects, not just one.

## Install

    herdr plugin link --path <clone path>

Then bind a key in `~/.config/herdr/config.toml`:

```toml
[[keys.command]]
key = "prefix+shift+y"
type = "plugin_action"
command = "yasainet.quote.quote-selection"
```

Reload:

    herdr server reload-config

## Usage

Select text in a pane, press your key. That's it.

Input:

    Tests all passed.

    One of them is flaky though.

Lands in the prompt as:

    > Tests all passed.
    >
    > One of them is flaky though.

with the cursor on a fresh line below, so you can add your own words.

## Requirements

- herdr 0.7.0+
- bash
- `jq` or `python3`
- macOS or Linux

## License

MIT
```

Step 3 で撮る GIF を README に貼るので、`## Usage` の直後に `![demo](docs/demo.gif)` を入れる場所を確保しておく。

- [ ] **Step 3: デモ GIF を撮って README に貼る**

herdr 上で「出力を選択 → キーを押す → 引用が入力欄に入る」までを録画し、`docs/demo.gif` として保存する。README の `## Usage` の直後に次を挿入する。

```markdown
![demo](docs/demo.gif)
```

- [ ] **Step 4: CI を書く**

`.github/workflows/test.yml`:

```yaml
name: test

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: bash test/quote_test.sh
```

- [ ] **Step 5: テストがローカルで通ることを確認する**

```bash
bash test/quote_test.sh
```

期待: `8 passed, 0 failed`

- [ ] **Step 6: コミット**

```bash
git add README.md LICENSE .github/workflows/test.yml docs/demo.gif
git commit -m "docs: add README, license and CI"
```

- [ ] **Step 7: GitHub に公開する**

```bash
cd /Users/yasainet/ghq/github.com/yasainet/herdr-quote
gh repo create yasainet/herdr-quote --public --source=. --remote=origin \
  --description "Quote the selected text into the agent prompt of the same pane (herdr plugin)"
git push -u origin main
gh repo edit yasainet/herdr-quote --add-topic herdr-plugin --add-topic herdr --add-topic terminal
```

- [ ] **Step 8: CI が緑になることを確認する**

```bash
gh run list --limit 1
gh run watch
```

- [ ] **Step 9: dotfiles 側にキーバインドを正式に入れる**

Task 1 では検証のために手で書き足した。dotfiles 管理下に入れて永続化する。

```bash
cd /Users/yasainet/ghq/github.com/yasainet/dotfiles
```

`.config/herdr/config.toml` の末尾（既存の `[[keys.command]]` 群の後ろ）に追記する。

```toml
[[keys.command]]
key = "prefix+shift+y"
type = "plugin_action"
command = "yasainet.quote.quote-selection"
description = "quote selection into prompt"
```

```bash
git add .config/herdr/config.toml
git commit -m "change(herdr): herdr-quote プラグインのキーバインドを追加"
```

---

## Self-Review

**Spec coverage:**

| spec の項目 | 対応タスク |
| --- | --- |
| マニフェスト（id / action / contexts / platforms） | Task 1 Step 3 |
| 利用者側のキーバインド | Task 1 Step 6、Task 4 Step 9 |
| データフロー 1–6 | Task 3 Step 1 |
| 変換仕様（`> `、空行は `>`、末尾に空行） | Task 2 Step 1・3 |
| `\x1b\r` での連結 | Task 2（separator 引数）、Task 3 Step 1 |
| モジュール境界（`quote_lines` は純関数） | Task 2 |
| エラー処理4件 | Task 3 Step 1・3 |
| テスト6ケース + CI | Task 2 Step 1、Task 4 Step 4 |
| 未確定リスク（soft wrap） | Task 1 Step 7 |
| リポジトリ構成 | Task 1・2・4 で全ファイル作成 |
| OSS 公開（MIT / topic / GIF） | Task 4 |

漏れなし。

**Placeholder scan:** 「後で実装」「適切に処理」の類は無い。Task 1 Step 4 の `quote.sh` は調査用の暫定実装だが、Task 3 で置き換わることと、その中身を明記してある。

**Type consistency:** `quote_lines <text> [separator]` は Task 2 で定義し Task 3 で同じ引数順で呼んでいる。`QUOTE_LIB_ONLY` は Task 2 のテストで設定し Task 3 の末尾で参照している。`json_field <json> <field>` は Task 3 内で定義・使用。プラグイン ID とアクション ID は Task 1・4 で `yasainet.quote.quote-selection` に統一。
