# Visual Companion Guide

mockup や図や選択肢を見せるための、browser を使う視覚的な brainstorming 補助だ。

## When to Use

session 単位ではなく質問ごとに判断せよ。判定はこうだ。読むより見る方が `user` はよく理解できるか。

browser を使うのは、中身そのものが視覚的なとき:

- UI の mockup — wireframe、layout、navigation の構造、component の設計
- 構成図 — 系の component、data の流れ、関係の地図
- 並べての視覚的な比較 — 二つの layout、二つの配色、二つの設計方針の比較
- 仕上げの検討 — 見た目や質感、余白、視覚的な階層に関する質問
- 空間的な関係 — 図として描く状態機械、flowchart、entity の関係

terminal を使うのは、中身が文字や表のとき:

- 要件と範囲の質問 — 「X とは何か」「どの機能を範囲に含めるか」
- 概念的な A/B/C の選択 — 言葉で説明された案から選ぶ
- 得失の一覧 — 長所短所、比較表
- 技術的な判断 — API 設計、data model、構成方針の選択
- 確認の質問 — 答えが視覚的な好みではなく言葉になるもの全て

UI に関する質問が、自動的に視覚的な質問になるわけではない。「どんな wizard が欲しいか」は概念的だ。terminal を使え。「この wizard layout のどれがしっくり来るか」は視覚的だ。browser を使え。

## How It Works

server は directory を監視し、最も新しい HTML file を browser に配る。あなたは `screen_dir` に HTML を書き、`user` はそれを browser で見て、click で選択肢を選べる。選択は `state_dir/events` に記録され、あなたは次の turn でそれを読む。

content の断片か完全な文書か: HTML file が `<!DOCTYPE` か `<html` で始まるなら、server はそのまま配る (helper script だけ差し込む)。そうでなければ、server が frame template で自動的に包む。header、CSS の配色、接続状態、対話に必要な仕組みが付く。既定では content の断片を書け。page 全体を制御する必要があるときだけ、完全な文書を書け。

## Starting a Session

```bash
# Start AFTER the user approves the companion. --open auto-opens their browser on
# the first screen; --project-dir persists mockups and enables same-port restart.
scripts/start-server.sh --project-dir /path/to/project --open

# Returns: {"type":"server-started","port":52341,
#           "url":"http://localhost:52341/?key=ab12…",
#           "screen_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/content",
#           "state_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/state"}
```

応答から `screen_dir` と `state_dir` を控えよ。`--open` を付けると、最初の画面を送った時点で browser が自分で開く。`user` に開くよう頼む必要は無いが、控えとして URL は伝えよ (headless や遠隔の環境では自動で開かない)。

URL には session key (`?key=…`) が含まれる。server はこれの無い request を全て拒む。だから `url` field の完全な URL をそのまま `user` に渡せ。query string を削るな。素の `http://host:port` を渡すな。この key が HTTP と WebSocket への access を守る。迷い込んだ browser tab や network 上の別の機械が、画面を読んだり event を注入したりするのを防ぐ。最初の読み込みの後、browser は cookie で key を覚えるので、再読み込みや `/files/*` の資材は key 無しで動く。

接続情報の探し方: server は起動時の JSON を `$STATE_DIR/server-info` に書く。background で起動して stdout を取り損ねたなら、その file を読んで URL と port を得よ。`--project-dir` を使ったなら、`<project>/.superpowers/brainstorm/` に session directory がある。

注意: `--project-dir` に project の root を渡せ。mockup が `.superpowers/brainstorm/` に残り、server を再起動しても消えない。渡さないと file は `/tmp` に置かれ、掃除される。`.gitignore` に `.superpowers/` が無ければ、足すよう `user` に伝えよ。

platform 別の server の起動:

Claude Code:
```bash
# Default mode works — the script backgrounds the server itself.
scripts/start-server.sh --project-dir /path/to/project --open
```

Windows では script が自動で判定し、foreground mode に切り替える (この場合 tool 呼び出しが塞がる)。Bash tool の呼び出しに `run_in_background: true` を付け、会話の turn をまたいで server を生かせ。次の turn で `$STATE_DIR/server-info` を読み、URL と port を得よ。

Codex:
```bash
# Codex reaps background processes. The script auto-detects CODEX_CI and
# switches to foreground mode. Run it normally — no extra flags needed.
scripts/start-server.sh --project-dir /path/to/project --open
```

Gemini CLI:
```bash
# Use --foreground and set is_background: true on your shell tool call
# so the process survives across turns
scripts/start-server.sh --project-dir /path/to/project --open --foreground
```

Copilot CLI:
```bash
# Use --foreground and start the server via the bash tool with mode: "async"
# so the process survives across turns. Capture the returned shellId for
# read_bash / stop_bash if you need to interact with it later.
scripts/start-server.sh --project-dir /path/to/project --open --foreground
```

その他の環境: server は会話の turn をまたいで background で動き続ける必要がある。切り離した process が刈られる環境なら、`--foreground` を使い、その platform の background 実行の仕組みで起動せよ。

`user` の browser から URL に届かないなら (遠隔や container の環境でよくある)、loopback でない host に bind せよ。

```bash
scripts/start-server.sh \
  --project-dir /path/to/project \
  --host 0.0.0.0 \
  --url-host localhost
```

返る URL の JSON に出す hostname は `--url-host` で決められる。

## The Loop

1. server が生きているか確認し、`screen_dir` の新しい file に HTML を書く:
   - 必須: URL に言及する前、画面を送る前に、server が生きていることを確かめよ。`$STATE_DIR/server-info` があり、`$STATE_DIR/server-stopped` が無いことを確認する。落ちていたら、同じ `--project-dir` で `start-server.sh` を使い再起動せよ。同じ port を再利用するので、`user` の開いている tab は自分で再接続する (server が落ちている間は「paused」の覆いが出る)。新しい URL を送る必要は無い。server は 4 時間の無操作で自動終了する (`--idle-timeout-minutes` で変えられる)
   - 意味の分かる file 名を使え: `platform.html`, `visual-style.html`, `layout.html`
   - file 名を再利用するな。画面ごとに新しい file を作れ
   - file 作成の tool を使え。cat や heredoc は使うな (terminal に雑音を撒く)
   - server は自動で最新の file を配る

2. 何が起きるか `user` に伝え、turn を終える:
   - URL を毎回伝えよ (最初だけでなく毎 step)
   - 画面に何が出ているかを短く文字でも伝えよ (例: 「homepage の layout 案を 3 つ出しました」)
   - terminal で返答するよう頼め: 「見て感想を教えてください。よければ click で選んでください。」

3. 次の turn で — `user` が terminal で返答した後:
   - `$STATE_DIR/events` があれば読め。`user` の browser 操作 (click、選択) が JSON 行として入っている
   - `user` の terminal の文と突き合わせ、全体像を掴め
   - 主たる feedback は terminal の message だ。`state_dir/events` は構造化された操作の記録を補う

4. 練り直すか進むか — feedback が今の画面を変えるなら、新しい file を書け (例: `layout-v2.html`)。今の step が固まって初めて次の質問へ進め

5. terminal に戻るときは表示を降ろせ — 次の step で browser が要らないなら (確認の質問、得失の議論など)、待機画面を送って古い内容を消せ:

   ```html
   <!-- filename: waiting.html (or waiting-2.html, etc.) -->
   <div style="display:flex;align-items:center;justify-content:center;min-height:60vh">
     <p class="subtitle">Continuing in terminal...</p>
   </div>
   ```

   会話が先へ進んだのに、決着済みの選択を `user` が見続ける事態を防げる。次の視覚的な質問が来たら、いつも通り新しい content file を送れ。

6. 終わるまで繰り返せ。

## Writing Content Fragments

page の中身に入る部分だけを書け。server が frame template で自動的に包む (header、配色の CSS、接続状態、対話に必要な仕組み)。

最小の例:

```html
<h2>Which layout works better?</h2>
<p class="subtitle">Consider readability and visual hierarchy</p>

<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>Single Column</h3>
      <p>Clean, focused reading experience</p>
    </div>
  </div>
  <div class="option" data-choice="b" onclick="toggleSelect(this)">
    <div class="letter">B</div>
    <div class="content">
      <h3>Two Column</h3>
      <p>Sidebar navigation with main content</p>
    </div>
  </div>
</div>
```

これだけだ。`<html>` も CSS も `<script>` も要らない。server が全て用意する。

## CSS Classes Available

frame template は、content 向けに次の CSS class を用意している。

### Options (A/B/C choices)

```html
<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>Title</h3>
      <p>Description</p>
    </div>
  </div>
</div>
```

複数選択: 容器に `data-multiselect` を足すと、`user` は複数の選択肢を選べる。click ごとにその項目の選択状態が切り替わる。

```html
<div class="options" data-multiselect>
  <!-- same option markup — users can select/deselect multiple -->
</div>
```

### Cards (visual designs)

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image"><!-- mockup content --></div>
    <div class="card-body">
      <h3>Name</h3>
      <p>Description</p>
    </div>
  </div>
</div>
```

### Mockup container

```html
<div class="mockup">
  <div class="mockup-header">Preview: Dashboard Layout</div>
  <div class="mockup-body"><!-- your mockup HTML --></div>
</div>
```

### Split view (side-by-side)

```html
<div class="split">
  <div class="mockup"><!-- left --></div>
  <div class="mockup"><!-- right --></div>
</div>
```

### Pros/Cons

```html
<div class="pros-cons">
  <div class="pros"><h4>Pros</h4><ul><li>Benefit</li></ul></div>
  <div class="cons"><h4>Cons</h4><ul><li>Drawback</li></ul></div>
</div>
```

### Mock elements (wireframe building blocks)

```html
<div class="mock-nav">Logo | Home | About | Contact</div>
<div style="display: flex;">
  <div class="mock-sidebar">Navigation</div>
  <div class="mock-content">Main content area</div>
</div>
<button class="mock-button">Action Button</button>
<input class="mock-input" placeholder="Input field">
<div class="placeholder">Placeholder area</div>
```

### Typography and sections

- `h2` — page の題
- `h3` — 節の見出し
- `.subtitle` — 題の下に置く補助の文
- `.section` — 下に余白を持つ content の塊
- `.label` — 小さな大文字の label

## Browser Events Format

`user` が browser で選択肢を click すると、その操作は `$STATE_DIR/events` に記録される (1 行 1 JSON object)。新しい画面を送ると、この file は自動で空になる。

```jsonl
{"type":"click","choice":"a","text":"Option A - Simple Layout","timestamp":1706000101}
{"type":"click","choice":"c","text":"Option C - Complex Grid","timestamp":1706000108}
{"type":"click","choice":"b","text":"Option B - Hybrid","timestamp":1706000115}
```

event の並びは `user` が探った道筋を示す。決める前に複数の選択肢を click することもある。最後の `choice` event が最終的な選択であることが多いが、click の様子から迷いや好みが読み取れることもある。尋ねる価値がある。

`$STATE_DIR/events` が無いなら、`user` は browser を操作していない。terminal の文だけを使え。

## Design Tips

- 質問に応じた作り込みにせよ — layout の質問なら wireframe、仕上げの質問なら仕上げまで
- page ごとに質問を書け — 「一つ選んで」ではなく「どちらの layout がより professional に見えますか」
- 進む前に練り直せ — feedback が今の画面を変えるなら、新しい版を書け
- 画面ごとの選択肢は 2〜4 個まで
- 重要なら本物の content を使え — 写真の portfolio なら実際の画像を使え (Unsplash)。仮の content は設計上の問題を隠す
- mockup は簡素に保て — 画素単位の完成度ではなく、layout と構造に集中せよ

## File Naming

- 意味の分かる名前を使え: `platform.html`, `visual-style.html`, `layout.html`
- file 名を再利用するな。画面ごとに新しい file にせよ
- 練り直しでは版の接尾辞を足せ。例: `layout-v2.html`, `layout-v3.html`
- server は更新時刻が最も新しい file を配る

## Cleaning Up

```bash
scripts/stop-server.sh $SESSION_DIR
```

session が `--project-dir` を使っていたなら、mockup の file は後で参照できるよう `.superpowers/brainstorm/` に残る。停止時に消えるのは `/tmp` の session だけだ。

## Reference

- frame template (CSS の参照先): `scripts/frame-template.html`
- helper script (client 側): `scripts/helper.js`
