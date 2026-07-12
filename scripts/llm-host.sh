#!/bin/bash

# ====================
# Local LLM host setup
# ====================
# LLM ホスト (MacBook-Pro-2023) でのみ手動実行する。install.sh からは呼ばれない。
#
#   ./scripts/llm-host.sh
#
# セットアップ後、モデルの取得は llm-fetch、起動は llm-serve (共に .zshrc で定義)。

set -e

echo "=== Local LLM host setup ==="

brew install llama.cpp
brew install hf

if ! command -v llama-swap &>/dev/null; then
  LLAMA_SWAP_VER="v222"
  mkdir -p "$HOME/.local/bin"
  curl -sL "https://github.com/mostlygeek/llama-swap/releases/download/${LLAMA_SWAP_VER}/llama-swap_${LLAMA_SWAP_VER#v}_darwin_arm64.tar.gz" \
    | tar -xz -C "$HOME/.local/bin" llama-swap
  chmod +x "$HOME/.local/bin/llama-swap"
  echo "  [install] llama-swap ${LLAMA_SWAP_VER}"
else
  echo "  [skip] llama-swap already installed"
fi

echo ""
echo "=== LLM host setup complete! ==="
echo "Next: llm-fetch (download models), llm-serve (start server)"
