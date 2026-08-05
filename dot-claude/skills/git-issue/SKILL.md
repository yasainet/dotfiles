---
description: GitHub/Gitea に issue を作成
allowed-tools: Bash(gh *), Bash(tea *), Bash(git remote *)
disable-model-invocation: true
---

## Steps

1. 現在の会話のコンテキストを要約し、適切な issue タイトルと本文をドラフトする

2. 作成前に、ドラフトしたタイトルと本文をユーザーに見せて確認を取る

3. remote を判定する

```bash
git remote get-url origin
```

4. issue を作成する

- GitHub:

```bash
gh issue create --title "<title>" --body "<body>"
```

- Gitea:

```bash
tea issues create --remote origin --title "<title>" --description "<body>"
```

5. 作成された issue の URL をユーザーに表示する

> [!NOTE]
>
> - 本文は HEREDOC `cat <<'EOF' ... EOF` で記述せよ
> - metadata は付与しない
