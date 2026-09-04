---
allowed-tools: Bash(echo *)
disable-model-invocation: true
---

# Claude Session

以下を bash tool で実行して、session id を出力せよ。

```bash
echo "${CLAUDE_CODE_SESSION_ID:-$PI_SESSION_ID}"
```
