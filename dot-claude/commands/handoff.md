---
description: 現在の会話を 200 行以内の引き継ぎ markdown に保存する (次回 /compact 前に実行)
allowed-tools: Bash(mkdir *), Bash(date *), Bash(wc *), Write(**/docs/compacts/*.md)
---

# handoff

現在の会話状態を分析し、次回セッションが引き継ぐべき情報を 200 行以内の markdown として保存する。
保存先は `./docs/compacts/YYYY-MM-DD-HHMMSS.md`。
`YYYY-MM-DD-HHMMSS` は Bash で `date +%Y-%m-%d-%H%M%S` を叩いた値を使う。

## 出力する markdown 構成

```markdown
# handoff — <セッションのテーマ 1 行>

## 進行中のタスク

- 今何をしている途中か
- どこまで進んだか

## 決定事項 (と Why)

- 決めたこと、その理由

## 未解決の問い / 次のステップ

- 次にやること
- 判断が保留の点

## 触れたファイル・コマンド

- 具体的なパス、実行したコマンド、エラー文言はそのまま残す
```

## ルール

- 200 行を厳守する (人間の可読限界)
- 超えそうなら重要度で切る
- 情報は具体的に残す (パス、コマンド、エラー文言はそのまま)
- 主観的要約 (「うまくいった」「順調」等) は書かない
- 事実ベースで書く
- 該当なしの節は省いてよい
- Format Rules (`dot-claude/rules/docs/format.md`) に従う
  - 1 文 1 行、日本語 60 字以内
  - `**Bold**` 禁止
  - 見出し前後の `---` 禁止

## 実行手順

1. Bash で `mkdir -p ./docs/compacts` を実行
2. Bash で `date +%Y-%m-%d-%H%M%S` を叩き変数化
3. Write ツールで上記構成の markdown を `./docs/compacts/<timestamp>.md` に書き出す
4. Bash で `wc -l` を叩き行数を確認
5. 生成ファイルパスと行数を 1 行で報告

## 報告フォーマット

作業完了後の user への報告は 1 行のみ。

```
docs/compacts/<filename>.md (N lines)
```

他のコメントは書かない。
