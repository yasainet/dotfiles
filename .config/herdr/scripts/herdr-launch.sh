#!/bin/sh
# herdr server が Claude Code の env を継承すると、以降 spawn される全 CC pane が
# 「死んだ session の child」扱いになり jsonl が書かれなくなる（silent data loss）。
# anthropics/claude-code#73294 / #72347 / #67603 / #68534 — 全て open (data-loss)。
# ここで env を確実に落としてから本体を exec する。
unset CLAUDE_CODE_SESSION_ID \
      CLAUDE_CODE_CHILD_SESSION \
      CLAUDE_CODE_EXECPATH \
      CLAUDE_CODE_ENTRYPOINT \
      CLAUDECODE

exec /opt/homebrew/bin/herdr "$@"
