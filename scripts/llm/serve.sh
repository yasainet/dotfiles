#!/bin/bash
#
# Usage:
# - ./scripts/llm/serve.sh    # llama-server を :8080 で起動

set -e

MODEL_DIR="$HOME/models/Qwen3.8-27B-Uncensored"

if ! command -v "$HOME/.local/bin/llama-server" &>/dev/null; then
  echo "llama-server not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

export LLAMA_ARG_CHAT_TEMPLATE_KWARGS='{"preserve_thinking": true, "reasoning_effort": "medium"}'

exec "$HOME/.local/bin/llama-server" \
  -m "$MODEL_DIR/Qwen3.8-27B-Uncensored-Q4_K_M.gguf" \
  --alias "Qwen3.8-27B-Uncensored-Q4_K_M" \
  --mmproj "$MODEL_DIR/Qwen3.8-27B-Uncensored-vision-f16.gguf" \
  --host 0.0.0.0 \
  --port 8080 \
  -ngl 99 \
  -fa on \
  --parallel 1 \
  --ctx-size 204800 \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  --jinja \
  --temp 0.6 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0 \
  --presence-penalty 1.5 \
  --repeat-penalty 1.0 \
  --spec-type draft-mtp \
  --spec-draft-n-max 2 \
  --spec-draft-p-min 0.65 \
  "$@"
