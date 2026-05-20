---
name: commit
description: Create commit, review
allowed-tools: Bash(git *), AskUserQuestion
---

# Commit

1. `git status` を実行する。未コミットの変更がない場合は、ユーザーに伝えて停止する
2. `git diff` を実行し、実際の変更内容を確認する
3. `git log --oneline -10` を実行し、既存のコミットメッセージのスタイルを確認する
4. Security Check: コミット対象に機密ファイルが含まれている場合は、ユーザーに警告して確認を取れ
5. `git add -A` ではなく、個別のファイルパスを指定（`git add <file1> <file2> ...`）してステージする
6. ステップ 3 のスタイルに従い、簡潔なコミットメッセージを生成する。`Co-Authored-By` や署名トレーラーは含めない
7. `AskUserQuestion` ツールでユーザーに以下の選択肢を提示する:
   - 生成したメッセージを使用する（ラベルにメッセージを表示）
   - キャンセル
