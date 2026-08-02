#!/bin/bash

# ====================
# Start llama-swap
# ====================
# LLM ホスト (MacBook-Pro-2023) でのみ実行する。install.sh からは呼ばれない。
#
#   ./scripts/llm/serve.sh
#
# 通常は LaunchAgent (com.yasainet.llama-swap) が常駐させる。
# これはログを直接見たい時やモデル追加の動作確認に使う手動起動。
# 常駐と競合するため、先に launchctl bootout で止めておくこと。

set -e

if ! command -v llama-swap &>/dev/null; then
  echo "llama-swap not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

exec llama-swap --config "$HOME/.config/llama-swap/config.yaml" --listen :8080 "$@"
