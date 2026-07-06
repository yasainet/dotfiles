#!/bin/sh
cat <<'EOF'
[tool-call drift prevention (Opus 4.8 1M)]
- Start responses with a tool call. No preamble prose before it; state progress in one line after the tool returns.
- One tool call per turn by default. Batch only when parallel reads are clearly a win.
- Keep images to the latest turn only. Do not reference prior screenshots; fetch file contents via Read / gh api / cat.
EOF

# "UserPromptSubmit": [
#   {
#     "matcher": "",
#       {
#         "type": "command",
#         "command": "sh ~/ghq/github.com/yasainet/dotfiles/dot-claude/hooks/inject-anti-court-drift.sh"
#       }
#     ]
#   }
# ],

