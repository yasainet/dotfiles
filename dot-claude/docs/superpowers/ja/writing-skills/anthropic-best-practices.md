# Skill authoring best practices

> agent が見つけて使いこなせる、効く Skill の書き方。

良い Skill は簡潔で、構成がよく、実際の利用で test されている。この手引きは、agent が見つけて有効に使える Skill を書くための、実践的な判断を示す。

Skill の仕組みの概念的な背景は [Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) を見よ。

## Core principles

### 簡潔さが要だ

[context window](https://platform.claude.com/docs/en/build-with-claude/context-windows) は公共財だ。あなたの Skill は、agent が知る必要のある他の全てと context window を分け合う。

* system prompt
* 会話の履歴
* 他の Skill の metadata
* 実際の依頼

Skill の全ての token に即座の費用が掛かるわけではない。起動時に先読みされるのは、全ての Skill の metadata (name と description) だけだ。agent は Skill が関係してきたときに初めて SKILL.md を読み、追加の file は必要になったときだけ読む。それでも SKILL.md が簡潔であることは重要だ。いったん読み込まれれば、全ての token が会話の履歴や他の context と競う。

既定の想定: agent は既にとても賢い

agent がまだ持っていない文脈だけを足せ。情報ごとに問え。

* 「agent には本当にこの説明が要るか」
* 「agent がこれを知っていると想定してよいか」
* 「この段落は token の費用に見合うか」

良い例: 簡潔 (約 50 token):

````markdown  theme={null}
## Extract PDF text

Use pdfplumber for text extraction:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
````

悪い例: 冗長すぎる (約 150 token):

```markdown  theme={null}
## Extract PDF text

PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available for PDF processing, but we
recommend pdfplumber because it's easy to use and handles most cases well.
First, you'll need to install it using pip. Then you can use the code below...
```

簡潔な方は、PDF が何かも library の使い方も agent が知っていると想定している。

### 自由度を適切に設定する

task の壊れやすさと振れ幅に合わせて、指示の具体さを決めよ。

高い自由度 (文章による指示):

使うとき:

* 複数の進め方が妥当
* 判断が文脈に依存する
* 経験則が進め方を導く

例:

```markdown  theme={null}
## Code review process

1. Analyze the code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions
```

中くらいの自由度 (擬似 code や引数を持つ script):

使うとき:

* 望ましい型がある
* ある程度の違いは許される
* 設定が振る舞いを変える

例:

````markdown  theme={null}
## Generate report

Use this template and customize as needed:

```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
    # Optionally include visualizations
```
````

低い自由度 (具体的な script、引数はほとんど無い):

使うとき:

* 操作が脆く、誤りやすい
* 一貫性が決定的に重要
* 決まった順序を守る必要がある

例:

````markdown  theme={null}
## Database migration

Run exactly this script:

```bash
python scripts/migrate.py --verify --backup
```

Do not modify the command or add additional flags.
````

例え: agent を、道を進む robot だと考えよ。

* 両側が崖の細い橋: 安全な道は一つしかない。具体的な手すりと正確な指示を与えよ (低い自由度)。例: 決まった順序で走らせる必要のある database の移行。
* 危険の無い開けた野原: 多くの道が成功に通じる。大まかな方向を示し、最良の経路は agent に任せよ (高い自由度)。例: 文脈が最良の進め方を決める code review。

### 使う予定の model 全てで test する

Skill は model への追加として働くので、その効き目は土台の model に依存する。使う予定の model 全てで Skill を test せよ。

model 別の確認の観点:

* Claude Haiku (速く、経済的): Skill は十分な導きを与えているか
* Claude Sonnet (均衡): Skill は明快で無駄が無いか
* Claude Opus (強い推論): Skill は説明しすぎていないか

Opus で完璧に働くものが、Haiku ではもっと詳しさを要ることがある。複数の model で使う予定なら、そのどれでもうまく働く指示を目指せ。

## Skill structure

<Note>
  YAML frontmatter: SKILL.md の frontmatter には二つの field が要る。

  * `name` — Skill の人間向けの名前 (最大 64 文字)
  * `description` — Skill が何をし、いつ使うかの一行の説明 (最大 1024 文字)

  Skill の構造の詳細は [Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#skill-structure) を見よ。
</Note>

### 命名の慣習

一貫した命名の型を使うと、Skill を参照し議論しやすくなる。Skill 名には動名詞 (動詞 + -ing) を薦める。その Skill が与える活動や能力をはっきり述べられるからだ。

良い命名の例 (動名詞):

* "Processing PDFs"
* "Analyzing spreadsheets"
* "Managing databases"
* "Testing code"
* "Writing documentation"

許せる代替:

* 名詞句: "PDF Processing", "Spreadsheet Analysis"
* 行動を示す形: "Process PDFs", "Analyze Spreadsheets"

避けるもの:

* 曖昧な名前: "Helper", "Utils", "Tools"
* 一般的すぎる名前: "Documents", "Data", "Files"
* 自分の skill 群の中で型が揃っていないこと

一貫した命名は、次を容易にする。

* 文書や会話で Skill を参照すること
* Skill が何をするか一目で掴むこと
* 複数の Skill を整理し検索すること
* まとまりのある skill 集を保つこと

### 効く description の書き方

`description` field は Skill の発見を可能にする。何をするかと、いつ使うかの両方を含めること。

<Warning>
  必ず三人称で書け。description は system prompt に差し込まれ、視点が揃っていないと発見の問題を起こす。

  * 良い: "Processes Excel files and generates reports"
  * 避ける: "I can help you process Excel files"
  * 避ける: "You can use this to process Excel files"
</Warning>

具体的に書き、鍵となる語を入れよ。Skill が何をするかと、いつ使うかの具体的な引き金や文脈の両方を含めること。

Skill には description field がちょうど一つある。description は skill の選択に決定的だ。agent は 100 を超えることもある Skill の中から、これを見て正しいものを選ぶ。description は、その Skill を選ぶべきか agent が判断できるだけの情報を持たねばならない。実装の詳細は SKILL.md の残りが担う。

効く例:

PDF Processing skill:

```yaml  theme={null}
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

Excel Analysis skill:

```yaml  theme={null}
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

Git Commit Helper skill:

```yaml  theme={null}
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

次のような曖昧な description は避けよ。

```yaml  theme={null}
description: Helps with documents
```

```yaml  theme={null}
description: Processes data
```

```yaml  theme={null}
description: Does stuff with files
```

### 段階的な開示の型

SKILL.md は概観として働き、必要に応じて詳しい資料へ agent を導く。入門の手引きの目次のようなものだ。段階的な開示の仕組みの説明は、overview の [How Skills work](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#how-skills-work) を見よ。

実践的な指針:

* 性能のため、SKILL.md の本文は 500 行未満に保て
* この上限に近づいたら、内容を別の file に分けよ
* 指示、code、資材を効果的に整理するには、下の型を使え

#### 見取り図: 単純なものから複雑なものへ

基本の Skill は、metadata と指示を含む SKILL.md 一つから始まる。

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=87782ff239b297d9a9e8e1b72ed72db9" alt="Simple SKILL.md file showing YAML frontmatter and markdown body" data-og-width="2048" width="2048" data-og-height="1153" height="1153" data-path="images/agent-skills-simple-file.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=c61cc33b6f5855809907f7fda94cd80e 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=90d2c0c1c76b36e8d485f49e0810dbfd 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=ad17d231ac7b0bea7e5b4d58fb4aeabb 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=f5d0a7a3c668435bb0aee9a3a8f8c329 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0e927c1af9de5799cfe557d12249f6e6 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=46bbb1a51dd4c8202a470ac8c80a893d 2500w" />

Skill が育つにつれ、必要なときだけ読み込まれる内容を同梱できる。

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=a5e0aa41e3d53985a7e3e43668a33ea3" alt="Bundling additional reference files like reference.md and forms.md." data-og-width="2048" width="2048" data-og-height="1327" height="1327" data-path="images/agent-skills-bundling-content.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=f8a0e73783e99b4a643d79eac86b70a2 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=dc510a2a9d3f14359416b706f067904a 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=82cd6286c966303f7dd914c28170e385 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=56f3be36c77e4fe4b523df209a6824c6 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=d22b5161b2075656417d56f41a74f3dd 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=3dd4bdd6850ffcc96c6c45fcb0acd6eb 2500w" />

Skill の directory 全体は、こんな形になりうる。

```
pdf/
├── SKILL.md              # Main instructions (loaded when triggered)
├── FORMS.md              # Form-filling guide (loaded as needed)
├── reference.md          # API reference (loaded as needed)
├── examples.md           # Usage examples (loaded as needed)
└── scripts/
    ├── analyze_form.py   # Utility script (executed, not loaded)
    ├── fill_form.py      # Form filling script
    └── validate.py       # Validation script
```

#### Pattern 1: 概観と参照

````markdown  theme={null}
---
name: PDF Processing
description: Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick start

Extract text with pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Advanced features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
**Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
````

agent は FORMS.md、REFERENCE.md、EXAMPLES.md を必要なときだけ読む。

#### Pattern 2: 領域ごとの整理

複数の領域を持つ Skill では、関係の無い context を読み込まないよう領域ごとに整理せよ。`user` が売上の指標を尋ねたとき、agent は売上に関する schema だけを読めばよく、財務や marketing の data は要らない。token の消費を抑え、context の焦点を保てる。

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

````markdown SKILL.md theme={null}
# BigQuery Data Analysis

## Available datasets

**Finance**: Revenue, ARR, billing → See [reference/finance.md](reference/finance.md)
**Sales**: Opportunities, pipeline, accounts → See [reference/sales.md](reference/sales.md)
**Product**: API usage, features, adoption → See [reference/product.md](reference/product.md)
**Marketing**: Campaigns, attribution, email → See [reference/marketing.md](reference/marketing.md)

## Quick search

Find specific metrics using grep:

```bash
grep -i "revenue" reference/finance.md
grep -i "pipeline" reference/sales.md
grep -i "api usage" reference/product.md
```
````

#### Pattern 3: 条件付きの詳細

基本の内容を示し、進んだ内容へ link せよ。

```markdown  theme={null}
# DOCX Processing

## Creating documents

Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents

For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

agent は REDLINING.md や OOXML.md を、`user` がその機能を必要とするときだけ読む。

### 深い入れ子の参照を避ける

参照された file からさらに参照された file を、agent は部分的にしか読まないことがある。入れ子の参照に出会うと、agent は file 全体を読まずに `head -100` のような command で中身を覗くことがあり、情報が欠ける。

参照は SKILL.md から一段の深さに留めよ。全ての参照 file を SKILL.md から直接 link し、必要なときに agent が file 全体を読むようにせよ。

悪い例: 深すぎる:

```markdown  theme={null}
# SKILL.md
See [advanced.md](advanced.md)...

# advanced.md
See [details.md](details.md)...

# details.md
Here's the actual information...
```

良い例: 一段の深さ:

```markdown  theme={null}
# SKILL.md

**Basic usage**: [instructions in SKILL.md]
**Advanced features**: See [advanced.md](advanced.md)
**API reference**: See [reference.md](reference.md)
**Examples**: See [examples.md](examples.md)
```

### 長い参照 file には目次を付ける

100 行を超える参照 file には、先頭に目次を置け。部分的に読まれたときでも、agent は使える情報の全体像を見られる。

例:

```markdown  theme={null}
# API Reference

## Contents
- Authentication and setup
- Core methods (create, read, update, delete)
- Advanced features (batch operations, webhooks)
- Error handling patterns
- Code examples

## Authentication and setup
...

## Core methods
...
```

その上で agent は、file 全体を読むことも、必要な節へ飛ぶこともできる。

この file 中心の構成が、どう段階的な開示を可能にするかは、下の Advanced の [Runtime environment](#runtime-environment) の節を見よ。

## Workflows and feedback loops

### 複雑な task には workflow を使う

複雑な操作を、明確で順序のある step に分けよ。特に複雑な workflow では、agent が応答に写して進捗を印付けられる checklist を渡せ。

例 1: 調査の統合の workflow (code を含まない Skill 向け):

````markdown  theme={null}
## Research synthesis workflow

Copy this checklist and track your progress:

```
Research Progress:
- [ ] Step 1: Read all source documents
- [ ] Step 2: Identify key themes
- [ ] Step 3: Cross-reference claims
- [ ] Step 4: Create structured summary
- [ ] Step 5: Verify citations
```

**Step 1: Read all source documents**

Review each document in the `sources/` directory. Note the main arguments and supporting evidence.

**Step 2: Identify key themes**

Look for patterns across sources. What themes appear repeatedly? Where do sources agree or disagree?

**Step 3: Cross-reference claims**

For each major claim, verify it appears in the source material. Note which source supports each point.

**Step 4: Create structured summary**

Organize findings by theme. Include:
- Main claim
- Supporting evidence from sources
- Conflicting viewpoints (if any)

**Step 5: Verify citations**

Check that every claim references the correct source document. If citations are incomplete, return to Step 3.
````

この例は、code を要しない分析の task にも workflow が当てはまることを示す。checklist の型は、複数 step の複雑な過程なら何にでも働く。

例 2: PDF の form 記入の workflow (code を含む Skill 向け):

````markdown  theme={null}
## PDF form filling workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form (run analyze_form.py)
- [ ] Step 2: Create field mapping (edit fields.json)
- [ ] Step 3: Validate mapping (run validate_fields.py)
- [ ] Step 4: Fill the form (run fill_form.py)
- [ ] Step 5: Verify output (run verify_output.py)
```

**Step 1: Analyze the form**

Run: `python scripts/analyze_form.py input.pdf`

This extracts form fields and their locations, saving to `fields.json`.

**Step 2: Create field mapping**

Edit `fields.json` to add values for each field.

**Step 3: Validate mapping**

Run: `python scripts/validate_fields.py fields.json`

Fix any validation errors before continuing.

**Step 4: Fill the form**

Run: `python scripts/fill_form.py input.pdf fields.json output.pdf`

**Step 5: Verify output**

Run: `python scripts/verify_output.py output.pdf`

If verification fails, return to Step 2.
````

明確な step があれば、agent が重要な検証を飛ばさない。checklist は、あなたにも agent にも、複数 step の workflow の進み具合を示す。

### feedback の loop を作る

よくある型: 検証器を回す → error を直す → 繰り返す

この型は出力の品質を大きく上げる。

例 1: 文体の指針への適合 (code を含まない Skill 向け):

```markdown  theme={null}
## Content review process

1. Draft your content following the guidelines in STYLE_GUIDE.md
2. Review against the checklist:
   - Check terminology consistency
   - Verify examples follow the standard format
   - Confirm all required sections are present
3. If issues found:
   - Note each issue with specific section reference
   - Revise the content
   - Review the checklist again
4. Only proceed when all requirements are met
5. Finalize and save the document
```

これは、script ではなく参照文書を使った検証の loop の型だ。「検証器」は STYLE_GUIDE.md であり、agent は読んで比べることで確認を行う。

例 2: 文書の編集の過程 (code を含む Skill 向け):

```markdown  theme={null}
## Document editing process

1. Make your edits to `word/document.xml`
2. **Validate immediately**: `python ooxml/scripts/validate.py unpacked_dir/`
3. If validation fails:
   - Review the error message carefully
   - Fix the issues in the XML
   - Run validation again
4. **Only proceed when validation passes**
5. Rebuild: `python ooxml/scripts/pack.py unpacked_dir/ output.docx`
6. Test the output document
```

検証の loop が error を早く捕まえる。

## Content guidelines

### 時間に依存する情報を避ける

いずれ古くなる情報を入れるな。

悪い例: 時間に依存する (いずれ誤りになる):

```markdown  theme={null}
If you're doing this before August 2025, use the old API.
After August 2025, use the new API.
```

良い例 (「old patterns」の節を使う):

```markdown  theme={null}
## Current method

Use the v2 API endpoint: `api.example.com/v2/messages`

## Old patterns

<details>
<summary>Legacy v1 API (deprecated 2025-08)</summary>

The v1 API used: `api.example.com/v1/messages`

This endpoint is no longer supported.
</details>
```

old patterns の節は、本文を散らかさずに歴史的な文脈を与える。

### 用語を揃える

一つの語を選び、Skill 全体でそれを使え。

良い — 揃っている:

* 常に「API endpoint」
* 常に「field」
* 常に「extract」

悪い — 揃っていない:

* 「API endpoint」「URL」「API route」「path」が混ざる
* 「field」「box」「element」「control」が混ざる
* 「extract」「pull」「get」「retrieve」が混ざる

一貫性は、agent が指示を理解し従う助けになる。

## Common patterns

### template の型

出力の形式には template を渡せ。厳しさの度合いは必要に応じて選べ。

厳格な要件のとき (API の応答や data の形式など):

````markdown  theme={null}
## Report structure

ALWAYS use this exact template structure:

```markdown
# [Analysis Title]

## Executive summary
[One-paragraph overview of key findings]

## Key findings
- Finding 1 with supporting data
- Finding 2 with supporting data
- Finding 3 with supporting data

## Recommendations
1. Specific actionable recommendation
2. Specific actionable recommendation
```
````

柔軟な指針のとき (合わせて変える方がよいとき):

````markdown  theme={null}
## Report structure

Here is a sensible default format, but use your best judgment based on the analysis:

```markdown
# [Analysis Title]

## Executive summary
[Overview]

## Key findings
[Adapt sections based on what you discover]

## Recommendations
[Tailor to the specific context]
```

Adjust sections as needed for the specific analysis type.
````

### 例示の型

出力の品質が例を見ることに左右される Skill では、通常の prompt と同じく入出力の組を渡せ。

````markdown  theme={null}
## Commit message format

Generate commit messages following these examples:

**Example 1:**
Input: Added user authentication with JWT tokens
Output:
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Example 2:**
Input: Fixed bug where dates displayed incorrectly in reports
Output:
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

**Example 3:**
Input: Updated dependencies and refactored error handling
Output:
```
chore: update dependencies and refactor error handling

- Upgrade lodash to 4.17.21
- Standardize error response format across endpoints
```

Follow this style: type(scope): brief description, then detailed explanation.
````

例は、説明だけよりも、望む文体と詳しさの度合いを agent に明確に伝える。

### 条件分岐の workflow の型

判断の分岐で agent を導け。

```markdown  theme={null}
## Document modification workflow

1. Determine the modification type:

   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below

2. Creation workflow:
   - Use docx-js library
   - Build document from scratch
   - Export to .docx format

3. Editing workflow:
   - Unpack existing document
   - Modify XML directly
   - Validate after each change
   - Repack when complete
```

<Tip>
  workflow が大きく複雑になり step が増えたら、別 file に移し、task に応じてその file を読むよう agent に伝えることを考えよ。
</Tip>

## Evaluation and iteration

### 先に評価を作る

詳しい文書を書く前に評価を作れ。これで、想像した問題ではなく実際の問題を解く Skill になる。

評価から始める開発:

1. 穴を特定する: 代表的な task を Skill 無しで agent に走らせよ。具体的な失敗や足りない文脈を記録せよ
2. 評価を作る: その穴を突く場面を三つ作れ
3. 基準を決める: Skill 無しでの agent の成績を測れ
4. 最小限の指示を書く: 穴を埋め、評価を通すのに足るだけの内容を書け
5. 繰り返す: 評価を実行し、基準と比べ、磨け

この進め方なら、実現しないかもしれない要件を先取りせず、実際の問題を解ける。

評価の構造:

```json  theme={null}
{
  "skills": ["pdf-processing"],
  "query": "Extract all text from this PDF file and save it to output.txt",
  "files": ["test-files/document.pdf"],
  "expected_behavior": [
    "Successfully reads the PDF file using an appropriate PDF processing library or command-line tool",
    "Extracts text content from all pages in the document without missing any pages",
    "Saves the extracted text to a file named output.txt in a clear, readable format"
  ]
}
```

<Note>
  この例は、単純な採点基準を持つ data 中心の評価を示す。今のところ、これらの評価を実行する組み込みの手段は用意していない。`user` は自分の評価の仕組みを作れる。評価は Skill の効き目を測る拠り所だ。
</Note>

### agent と共に Skill を練り上げる

最も効く Skill の開発の過程には、agent 自身が関わる。ある instance (「Agent A」) と組んで、他の instance (「Agent B」) が使う Skill を作れ。Agent A は指示の設計と改良を助け、Agent B は実際の task でそれを試す。土台の model は、効く agent 向けの指示の書き方も、agent に必要な情報も理解しているから、これが働く。

新しい Skill を作る:

1. Skill 無しで task をやり切る: 通常の prompt で Agent A と問題を解け。その過程で、あなたは自然に文脈を渡し、好みを説明する。手順の知識も共有する。何を繰り返し渡しているか気付け。

2. 再利用できる型を見つける: task を終えたら、渡した文脈のうち、似た task で役立つものを見極めよ。

   例: BigQuery の分析をやり切ったなら、いくつもの文脈を渡していたはずだ。table 名、field の定義、絞り込みの規則 (「test 用の account は常に除く」など)、よくある query の型だ。

3. Agent A に Skill の作成を頼む: 「今使った BigQuery の分析の型を捉えた Skill を作って。table の schema、命名の慣習、test 用 account を除く規則を含めて。」

   <Tip>
     今の agent は Skill の形式と構造を元から理解している。Skill を作る助けを得るのに、特別な system prompt も「skill を書く skill」も要らない。作ってと頼めば、適切な frontmatter と本文を持つ SKILL.md を生成する。
   </Tip>

4. 簡潔さを確認する: Agent A が不要な説明を足していないか見よ。「勝率が何かの説明は消して。agent はもう知っている。」

5. 情報の構成を良くする: 内容をより効果的に整理するよう Agent A に頼め。例: 「table の schema を別の参照 file に分けて。後で table が増えるかもしれない。」

6. 似た task で試す: Skill を読み込んだ真新しい instance (Agent B) で、関連する用途に使え。Agent B が正しい情報に辿り着き、規則を正しく適用し、task をやり切るか観察せよ。

7. 観察から練り直す: Agent B が詰まったり見落としたりしたら、具体を持って Agent A に戻れ: 「この Skill を使ったとき、agent は Q4 の日付で絞るのを忘れた。日付での絞り込みの型について節を足すべきか。」

既存の Skill を練り直す:

改良のときも、同じ階層の型が続く。あなたは次を行き来する。

* Agent A と作業する (Skill を磨く助けをする専門家)
* Agent B で試す (実際の作業のために Skill を使う agent)
* Agent B の振る舞いを観察し、気付きを Agent A に持ち帰る

1. 実際の workflow で Skill を使う: 試験用の場面ではなく、実際の task を (Skill を読み込んだ) Agent B に渡せ

2. Agent B の振る舞いを観察する: どこで詰まり、どこでうまくいき、どこで想定外の選択をするか控えよ

   観察の例: 「地域別の売上 report を頼んだとき、Agent B は query を書いたが、Skill に書いてあるのに test 用 account を除くのを忘れた。」

3. 改良のために Agent A へ戻る: 今の SKILL.md を渡し、観察したことを述べよ。こう尋ねる: 「地域別の report を頼んだとき、Agent B は test 用 account を除くのを忘れた。Skill には絞り込みの記述があるが、目立たないのではないか。」

4. Agent A の提案を確かめる: Agent A は次のような提案をするかもしれない。規則が目立つよう構成を変える。「always filter」ではなく「MUST filter」のような強い言葉を使う。workflow の節を組み直す。

5. 変更を適用して試す: Agent A の改良で Skill を更新し、似た依頼で Agent B にもう一度試せ

6. 利用に応じて繰り返す: 新しい場面に出会うたび、観察 → 改良 → 試験の周期を続けよ。回を重ねるごとに、想像ではなく実際の agent の振る舞いに基づいて Skill が良くなる。

team の feedback を集める:

1. 同僚と Skill を共有し、その使い方を観察せよ
2. 尋ねよ。想定通りに Skill は起動するか。指示は明快か。何が足りないか
3. feedback を取り込み、自分の使い方では見えない死角を埋めよ

なぜこの進め方が働くか: Agent A は agent の必要を理解し、あなたは領域の知識を持ち、Agent B は実際の利用を通して穴を露わにする。そして、想像ではなく観測された振る舞いに基づく反復が Skill を良くする。

### agent が Skill をどう辿るか観察する

Skill を練り直す間、agent が実際にそれをどう使うかに注意せよ。次を見よ。

* 予想外の探索の道筋: 想定しない順で file を読んでいないか。構成が思ったほど直感的でない印かもしれない
* 見落とされた繋がり: 重要な file への参照を辿らないことはないか。link をもっと明示的に、目立つようにする必要があるかもしれない
* 特定の節への偏り: 同じ file を繰り返し読むなら、その内容は SKILL.md 本体に置くべきかもしれない
* 読まれない内容: 同梱した file に一度も触れないなら、それは不要か、本文での案内が弱い

これらの観察に基づいて練り直せ。想像に基づくな。Skill の metadata の `name` と `description` は特に重要だ。agent は、今の task に対してその Skill を起動するか決めるときにこれを使う。何をする Skill で、いつ使うべきかを明確に述べよ。

## Anti-patterns to avoid

### Windows 形式の path を避ける

file の path には、Windows でも常に slash を使え。

* ✓ 良い: `scripts/helper.py`, `reference/guide.md`
* ✗ 避ける: `scripts\helper.py`, `reference\guide.md`

Unix 形式の path は全ての platform で働くが、Windows 形式の path は Unix の系で error を起こす。

### 選択肢を並べすぎない

必要がない限り、複数の進め方を示すな。

````markdown  theme={null}
**Bad example: Too many choices** (confusing):
"You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image, or..."

**Good example: Provide a default** (with escape hatch):
"Use pdfplumber for text extraction:
```python
import pdfplumber
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead."
````

## Advanced: Skills with executable code

以下の節は、実行できる script を含む Skill を扱う。markdown の指示だけの Skill なら、[Checklist for effective Skills](#checklist-for-effective-skills) へ飛べ。

### 解け。投げるな

Skill のための script を書くときは、error の場合を自分で扱え。agent に投げるな。

良い例: error を明示的に扱う:

```python  theme={null}
def process_file(path):
    """Process a file, creating it if it doesn't exist."""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # Create file with default content instead of failing
        print(f"File {path} not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # Provide alternative instead of failing
        print(f"Cannot access {path}, using default")
        return ''
```

悪い例: agent に投げる:

```python  theme={null}
def process_file(path):
    # Just fail and let the agent figure it out
    return open(path).read()
```

設定の値にも根拠を示し、文書化せよ。「呪文のような定数」を避けるためだ (Ousterhout の法則)。あなたが正しい値を知らないなら、agent はどう決めればよいのか。

良い例: それ自体が説明になっている:

```python  theme={null}
# HTTP requests typically complete within 30 seconds
# Longer timeout accounts for slow connections
REQUEST_TIMEOUT = 30

# Three retries balances reliability vs speed
# Most intermittent failures resolve by the second retry
MAX_RETRIES = 3
```

悪い例: 意味不明な数値:

```python  theme={null}
TIMEOUT = 47  # Why 47?
RETRIES = 5   # Why 5?
```

### utility の script を用意する

agent が script を書けるとしても、あらかじめ用意した script には利点がある。

utility script の利点:

* 生成された code より確実
* token を節約する (code を context に入れなくてよい)
* 時間を節約する (code の生成が要らない)
* 使うたびに一貫する

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=4bbc45f2c2e0bee9f2f0d5da669bad00" alt="Bundling executable scripts alongside instruction files" data-og-width="2048" width="2048" data-og-height="1154" height="1154" data-path="images/agent-skills-executable-scripts.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=9a04e6535a8467bfeea492e517de389f 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=e49333ad90141af17c0d7651cca7216b 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=954265a5df52223d6572b6214168c428 840w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=2ff7a2d8f2a83ee8af132b29f10150fd 1100w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=48ab96245e04077f4d15e9170e081cfb 1650w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0301a6c8b3ee879497cc5b5483177c90 2500w" />

上の図は、実行できる script が指示の file と並んでどう働くかを示す。指示の file (forms.md) が script を参照し、agent はその中身を context に読み込まずに実行できる。

重要な区別: agent が次のどちらをすべきか、指示で明らかにせよ。

* script を実行する (最も多い): 「field を取り出すには `analyze_form.py` を実行せよ」
* 参照として読む (込み入った論理のとき): 「field の取り出しの算法は `analyze_form.py` を見よ」

ほとんどの utility script では、実行の方が確実で無駄が無い。script の実行の仕組みは、下の [Runtime environment](#runtime-environment) の節を見よ。

例:

````markdown  theme={null}
## Utility scripts

**analyze_form.py**: Extract all form fields from PDF

```bash
python scripts/analyze_form.py input.pdf > fields.json
```

Output format:
```json
{
  "field_name": {"type": "text", "x": 100, "y": 200},
  "signature": {"type": "sig", "x": 150, "y": 500}
}
```

**validate_boxes.py**: Check for overlapping bounding boxes

```bash
python scripts/validate_boxes.py fields.json
# Returns: "OK" or lists conflicts
```

**fill_form.py**: Apply field values to PDF

```bash
python scripts/fill_form.py input.pdf fields.json output.pdf
```
````

### 視覚的な分析を使う

入力を画像として描けるなら、agent に見て分析させよ。

````markdown  theme={null}
## Form layout analysis

1. Convert PDF to images:
   ```bash
   python scripts/pdf_to_images.py form.pdf
   ```

2. Analyze each page image to identify form fields
3. The agent can see field locations and types visually
````

<Note>
  この例では、`pdf_to_images.py` の script を自分で書く必要がある。
</Note>

agent の視覚の能力は、配置や構造の理解を助ける。

### 検証できる中間の出力を作る

agent が複雑で開かれた task を行うとき、誤ることがある。「計画 → 検証 → 実行」の型は、agent にまず構造化された形式で計画を作らせ、実行の前に script で検証させることで、error を早く捕まえる。

例: 表計算に基づいて PDF の 50 個の field を更新するよう agent に頼むとする。検証が無いと、存在しない field を参照したり、衝突する値を作ったり、必要な field を落としたり、更新を誤って当てたりしうる。

解: 上に示した workflow の型 (PDF の form 記入) を使い、そこに `changes.json` という中間の file を足し、変更を当てる前に検証する。workflow はこうなる: 分析 → 計画 file を作る → 計画を検証する → 実行 → 確認。

この型が働く理由:

* error を早く捕まえる: 変更を当てる前に検証が問題を見つける
* 機械的に確かめられる: script が客観的な確認を与える
* 計画は戻せる: 原本に触れずに計画を練り直せる
* debug が明快: error message が具体的な問題を指す

使うとき: 一括の操作、破壊的な変更、込み入った検証の規則、失敗の代償が大きい操作。

実装の助言: 検証の script は饒舌にし、具体的な error message を出せ。`Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed` のように書けば、agent が直しやすい。

### package の依存

Skill は code 実行の環境で動き、platform ごとの制限がある。

* claude.ai: npm と PyPI から package を導入でき、GitHub の repository からも取得できる
* Anthropic API: network に繋がらず、実行時の package の導入もできない

必要な package を SKILL.md に並べ、[code execution tool の文書](https://platform.claude.com/docs/en/agents-and-tools/tool-use/code-execution-tool) で使えることを確かめよ。

### Runtime environment

Skill は、file 系への access、bash の command、code の実行ができる環境で動く。この構成の概念的な説明は overview の [The Skills architecture](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#the-skills-architecture) を見よ。

これが執筆に及ぼす影響:

agent が Skill にどう触れるか:

1. metadata が先読みされる: 起動時に、全ての Skill の YAML frontmatter の name と description が system prompt に読み込まれる
2. file は必要に応じて読まれる: agent は file 読み取りの tool で、必要になったときに SKILL.md やその他の file を読む
3. script は効率よく実行される: utility script は bash で実行でき、中身全体を context に読み込む必要が無い。token を使うのは script の出力だけだ
4. 大きな file に context の代償は無い: 参照 file、data、文書は、実際に読まれるまで context の token を使わない

* file の path が効く: agent は skill の directory を file 系として辿る。backslash ではなく slash を使え (`reference/guide.md`)
* file 名は説明的に: 中身が分かる名前を使え。`doc2.md` ではなく `form_validation_rules.md`
* 見つけやすく整理せよ: 領域や機能で directory を分けよ
  * 良い: `reference/finance.md`, `reference/sales.md`
  * 悪い: `docs/file1.md`, `docs/file2.md`
* 網羅的な資材を同梱せよ: 完全な API の文書、豊富な例、大きな data 一式を入れてよい。読まれるまで context の代償は無い
* 決まった動作には script を選べ: 検証の code を agent に生成させるより、`validate_form.py` を書け
* 実行か参照かを明確に:
  * 「field を取り出すには `analyze_form.py` を実行せよ」(実行)
  * 「取り出しの算法は `analyze_form.py` を見よ」(参照として読む)
* file への辿り方を試せ: 実際の依頼で試し、agent が directory の構成を辿れることを確かめよ

例:

```
bigquery-skill/
├── SKILL.md (overview, points to reference files)
└── reference/
    ├── finance.md (revenue metrics)
    ├── sales.md (pipeline data)
    └── product.md (usage analytics)
```

`user` が売上について尋ねると、agent は SKILL.md を読み、`reference/finance.md` への参照を見て、bash でその file だけを読む。sales.md と product.md は file 系に残り、必要になるまで context の token を一切使わない。この file 中心の model が段階的な開示を可能にする。agent は必要なものだけを選んで読める。

技術的な構成の詳細は、Skills overview の [How Skills work](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#how-skills-work) を見よ。

### MCP tool への参照

Skill が MCP (Model Context Protocol) の tool を使うなら、常に完全修飾の tool 名を使え。「tool not found」の error を避けられる。

形式: `ServerName:tool_name`

例:

```markdown  theme={null}
Use the BigQuery:bigquery_schema tool to retrieve table schemas.
Use the GitHub:create_issue tool to create issues.
```

ここで:

* `BigQuery` と `GitHub` は MCP server の名前
* `bigquery_schema` と `create_issue` は、その server の中の tool の名前

server の接頭辞が無いと、特に複数の MCP server がある場合、agent は tool を見つけられないことがある。

### 道具が入っていると想定しない

package が使えると決め付けるな。

````markdown  theme={null}
**Bad example: Assumes installation**:
"Use the pdf library to process the file."

**Good example: Explicit about dependencies**:
"Install required package: `pip install pypdf`

Then use it:
```python
from pypdf import PdfReader
reader = PdfReader("file.pdf")
```"
````

## Technical notes

### YAML frontmatter の要件

SKILL.md の frontmatter には `name` (最大 64 文字) と `description` (最大 1024 文字) が要る。構造の詳細は [Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#skill-structure) を見よ。

### token の予算

性能のため、SKILL.md の本文は 500 行未満に保て。これを超えるなら、先に述べた段階的な開示の型で別 file に分けよ。構成の詳細は [Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#how-skills-work) を見よ。

## Checklist for effective Skills

Skill を共有する前に、次を確かめよ。

### 中核の品質

* [ ] description が具体的で、鍵となる語を含む
* [ ] description が、何をするかといつ使うかの両方を含む
* [ ] SKILL.md の本文が 500 行未満
* [ ] 追加の詳細が別 file にある (必要なら)
* [ ] 時間に依存する情報が無い (あるいは「old patterns」の節にある)
* [ ] 全体で用語が揃っている
* [ ] 例が抽象的でなく具体的
* [ ] file の参照が一段の深さ
* [ ] 段階的な開示を適切に使っている
* [ ] workflow の step が明確

### code と script

* [ ] script が問題を解いている。agent に投げていない
* [ ] error 処理が明示的で役に立つ
* [ ] 「呪文のような定数」が無い (全ての値に根拠がある)
* [ ] 必要な package を指示に並べ、使えることを確かめた
* [ ] script に明確な説明がある
* [ ] Windows 形式の path が無い (全て slash)
* [ ] 重要な操作に検証や確認の step がある
* [ ] 品質が重要な task に feedback の loop がある

### test

* [ ] 評価を三つ以上作った
* [ ] Haiku、Sonnet、Opus で試した
* [ ] 実際の利用の場面で試した
* [ ] team の feedback を取り込んだ (該当するなら)

## Next steps

<CardGroup cols={2}>
  <Card title="Get started with Agent Skills" icon="rocket" href="https://platform.claude.com/docs/en/agents-and-tools/agent-skills/quickstart">
    Create your first Skill
  </Card>

  <Card title="Use Skills in Claude Code" icon="terminal" href="https://code.claude.com/docs/en/skills">
    Create and manage Skills in Claude Code
  </Card>

  <Card title="Use Skills with the API" icon="code" href="https://platform.claude.com/docs/en/build-with-claude/skills-guide">
    Upload and use Skills programmatically
  </Card>
</CardGroup>
