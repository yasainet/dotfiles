---
name: lessons
description: Record user feedback as a lesson entry using the standard template
argument-hint: <feedback>
disable-model-invocation: true
---

# Lessons

Record the following feedback as a new entry using the template below:

$ARGUMENTS

## Rules

- Append the new entry to the "Entries" section of this file
- When a pattern repeats, promote it to `rules/*.md` or eslint(`@yasainet/eslint`) rules

## Template

```markdown
## [Short Title] - [yyyy/mm/dd]

Project: [Project Name]

- Summary:
- Why:
- What:
- How:
```

## Entries

---

## @yasainet/eslint Push & Publish Workflow - 2026/03/03

Project: @yasainet/eslint

- Summary: eslint config を更新後、明示的な指示があれば push + tag 作成で npm publish まで完了するフロー
- Why: 毎回同じ手順を繰り返すので、ワークフローを記録して一貫性を保つ
- What:
  1. コード変更後、ユーザーが commit する
  2. ユーザーの明示的な指示を受けて以下を実行:
     - `git push origin main`
     - 最新タグをインクリメント（例: `v0.0.19` → `v0.0.20`）
     - `git tag v0.0.XX && git push origin v0.0.XX`
  3. `v*` タグの push をトリガーに GitHub Actions (`publish.yml`) が起動
  4. CI がタグからバージョンを設定 (`npm version "${GITHUB_REF_NAME#v}" --no-git-tag-version`) し `npm publish` を実行
- How:
  - `package.json` の `version` は `0.0.0` 固定（CI でタグから上書き）
  - `publishConfig.access: "public"` でスコープ付きパッケージを公開
  - ビルドステップなし、`src/` をそのまま publish（`"files": ["src"]`）
