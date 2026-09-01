---
description: Show the current session id
allowed-tools: Bash(echo *)
disable-model-invocation: true
---

Current session id: !`echo "${CLAUDE_CODE_SESSION_ID:-$PI_SESSION_ID}"`

If the line above shows a command instead of an id, run it with the bash tool first.
Output the session id in a single code block for easy copying. No explanation.
