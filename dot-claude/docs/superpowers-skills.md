# Superpowers Skills

Superpowers Skills の説明。
原典: `~/.claude/plugins/cache/claude-plugins-official/superpowers/<version>/skills/<name>/SKILL.md`

## The Basic Workflow

### brainstorming

アイデアを設計と spec に落とす。コードを書く前に必ず通る入口。

**発動**: 機能追加・コンポーネント作成・挙動変更など、あらゆる創造的作業の前。

**HARD-GATE**: 設計を提示してユーザーが承認するまで、実装 skill の呼び出し・コード記述・雛形生成を一切しない。「単純すぎて設計不要」は明示的に禁止。

**手順**:

1. **Explore project context**
   - ファイル・docs・直近コミットで現状を把握する
   - 同時にスコープを判定する。独立したサブシステムが複数あれば sub-project へ分解する
   - 分解した場合、各 sub-project が spec → plan → 実装のサイクルを持つ
2. **Offer the visual companion just-in-time**
   - mockup や図をブラウザで見せる補助ツール
   - 冒頭では提案しない
   - 「見せた方が明らかに分かりやすい」質問が初めて出た時に、その提案だけを単独メッセージで送る
3. **Ask clarifying questions**
   - 1 メッセージにつき 1 問
   - 可能なら選択式
   - 目的・制約・成功条件に絞る
4. **Propose 2-3 approaches**
   - trade-off を添える
   - 推奨案を先頭に、理由付きで
   - YAGNI を徹底する
5. **Present design**
   - 分量は複雑さに応じて（数文〜300 語）
   - セクションごとに合っているか確認する
   - architecture / components / data flow / error handling / testing をカバーする
6. **Write design doc**
   - `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` に保存して commit
   - 保存先はユーザー設定が優先
7. **Spec self-review**
   - プレースホルダ（TBD / TODO）が残っていないか
   - セクション間で矛盾していないか
   - 単一の plan に収まるスコープか
   - 二通りに読める要件がないか
   - 見つけたらその場で直す。再レビューはしない
8. **User reviews written spec**
   - パスを伝えてレビューを待つ
   - 承認されるまで進まない
9. **Transition to implementation**
   - `writing-plans` を呼ぶ
   - ここが唯一の出口。他の実装 skill を呼んではいけない

### using-git-worktrees

現作業から隔離したワークスペースを用意する。

**発動**: 隔離が必要な feature 作業の開始時、または plan 実行前。

**手順**:

1. 既存の隔離を検出する
2. ワークスペースを作る
   - ネイティブ worktree ツールを優先
   - なければ `git worktree`
   - 配置先の優先順位は 指示 > 既存の project-local ディレクトリ > `.worktrees/`
3. プロジェクトのセットアップを走らせる
4. テストが通るクリーンな baseline を確認して報告する

### writing-plans

spec から実装 plan を作る。

**発動**: 複数ステップのタスクの spec / 要件がある時、コードに触れる前。

**要点**:

- task は「自前のテストサイクルを持ち、レビュアーのゲートに値する最小単位」
- セットアップ・設定・雛形・ドキュメントは、それを必要とする task に畳み込む
- 分割するのは「隣を承認しつつ片方を却下できる」境界だけ
- 各 task は独立にテスト可能な成果物で終わる
- プレースホルダ禁止
- 最後に self-review

### subagent-driven-development

plan の task を、現在のセッション内で subagent に投げて回す。

**発動**: 独立した task を含む plan を現セッションで実行する時。

**ループ**:

1. implementer を dispatch する
2. 報告を処理する
3. task をレビューする（spec 準拠 → コード品質の 2 段）
4. fix ループを回す
5. task を完了する

全 task 後に全体レビューして finish。

### executing-plans

plan を別セッションで、人間のチェックポイントを挟みながら実行する。

**発動**: 書かれた実装 plan を、レビュー checkpoint 付きで別セッション実行する時。

**手順**:

1. plan を読み込みレビューする
2. 各 task を回す
   - in_progress にする
   - 手順どおり実行する
   - 指定の検証を走らせる
   - completed にする
3. 開発完了処理をする

### test-driven-development

**発動**: あらゆる機能実装・バグ修正で、実装コードを書く前。

**Iron Law**: `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
（失敗するテストなしに production コードを書くな）

**サイクル**:

1. RED — 失敗するテストを書く
2. 失敗を目視で確認する
3. GREEN — 通すための最小限のコードを書く
4. 成功を目視で確認する
5. REFACTOR — 整理する
6. 繰り返す

テストより先に書いたコードは削除する。

### requesting-code-review

**発動**: task 完了時、大きな機能の実装後、merge 前。

**手順**:

1. BASE_SHA / HEAD_SHA を取得する
2. `code-reviewer.md` のテンプレートを埋めて `general-purpose` subagent を dispatch する

指摘は深刻度別に報告される。critical があれば先へ進めない。

### finishing-a-development-branch

**発動**: 実装が完了しテストが通り、統合方法を決める段階。

**手順**:

1. テストを検証する
2. 環境を検出する
3. base branch を判定する
4. 選択肢を提示する
   - ローカルで merge
   - push して PR
   - そのまま保持
   - 破棄
5. 選択を実行する
6. ワークスペースを後片付けする

## Debugging

### systematic-debugging

**発動**: バグ・テスト失敗・想定外の挙動に遭遇した時、修正案を出す前。

**Iron Law**: `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
（根本原因の調査なしに修正するな）

**4 フェーズ**:

1. 根本原因の調査
   - エラーメッセージを精読する
   - 安定して再現させる
   - 直近の変更を確認する
   - 複数コンポーネントにまたがるなら証拠を集める
   - データフローを追跡する
2. パターン分析
   - 動いている例を見つける
   - 参照実装と比較する
   - 差分を特定する
   - 依存関係を理解する
3. 仮説と検証
   - 仮説は 1 つずつ立てる
   - 最小限の変更で検証する
   - 次に進む前に確認する
4. 実装
   - 失敗するテストケースを作る
   - 修正は 1 つだけ入れる
   - 修正を検証する
   - 3 回失敗したらアーキテクチャを疑う

### verification-before-completion

**発動**: 完了・修正済み・テスト通過を主張する直前、commit や PR 作成の前。

**Iron Law**: `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`
（新鮮な検証の証拠なしに完了を主張するな）

そのメッセージ内で検証コマンドを実行していないなら、通っているとは言えない。主張の前に必ず証拠。

## Collaboration

### dispatching-parallel-agents

**発動**: 共有状態も順序依存もない独立した task が 2 つ以上ある時。

**手順**:

1. 独立したドメインを特定する
2. 焦点を絞った agent task を作る
   - 1 ドメインにつき 1 つ
   - 自己完結させる
   - 出力形式を明示する
3. 並列で dispatch する
4. レビューして統合する
   - 各サマリを確認する
   - 同一箇所を編集していないか衝突を確認する
   - 全テストを走らせる
   - 抜き取りで確認する（agent は系統的に間違えることがある）

### receiving-code-review

**発動**: コードレビューの指摘を受け取った時、着手する前。特に指摘が不明瞭・技術的に疑わしい場合。

**要点**:

- 迎合も盲従も禁止
- 技術的に検証してから応じる
- 不明瞭なら確認する
- 押し返すべき場面では押し返す
- 自分の押し返しが誤りなら潔く訂正する
- 「プロっぽい」だけの機能追加要求には YAGNI を適用する

## Meta

### writing-skills

**発動**: skill の新規作成・編集・デプロイ前の検証。

**要点**:

- skill の型は technique / pattern / reference の 3 つ
- Skill Discovery Optimization
  - description を厚く書く
  - キーワードを網羅する
  - 名前を説明的にする
  - トークン効率を上げる
  - 他 skill を相互参照する
- 100 行超の重い参照や再利用ツールは別ファイルに切り出す

### using-superpowers

**発動**: 会話の開始時。

**要点**:

- 1% でも該当しそうなら skill を呼ぶ
- 呼ぶのは応答・確認質問・調査より前
- 複数該当するときは process 系（brainstorming, systematic-debugging）が先、実装系が後
- ユーザーの指示（CLAUDE.md 等）は skill に優先する
