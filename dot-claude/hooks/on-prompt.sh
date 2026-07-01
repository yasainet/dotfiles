#!/bin/sh
# UserPromptSubmit: プロンプト送信時に IME を ASCII へ戻す
# （tmux-claude-signal の state.sh は herdr ネイティブ検出へ移行し撤去）
/opt/homebrew/bin/macism com.apple.keylayout.ABC || true
