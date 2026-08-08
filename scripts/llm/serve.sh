#!/bin/bash

set -e

if ! command -v llama-swap &>/dev/null; then
  echo "llama-swap not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

exec llama-swap --config "$HOME/.config/llama-swap/config.yaml" --listen :8080 "$@"
