---
name: commit
description: [Skills] Create commit, review
allowed-tools: Bash(git *)
---

# Commit skill

## Steps

1. プロジェクト固有の `Verification` が完了している状態であること

2. 未コミットの変更を確認。変更がない場合はユーザーに伝えて停止する

```bash
git status
```

3. 実際の変更内容を確認する

```bash
git diff
```

4. 既存のコミットメッセージのスタイルを確認する

```bash
git log --oneline -10
```

5. Security Check: コミット対象に機密ファイルが含まれている場合は、ユーザーに警告して確認を取れ

6. `git add -A` ではなく、個別のファイルパスを指定してステージする

```bash
git add <file1> <file2> ...
```

7. ステップ 4 のスタイルに従い、簡潔なコミットメッセージを生成する
   - `Co-Authored-By` や署名トレーラーは含めない
   - Conventional Commits に従え

8. 生成したメッセージで `git commit -m "..."` を実行する
   - `settings.json` の ask permission により、実行前にユーザーへ確認が表示される
