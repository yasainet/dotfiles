#!/bin/bash
#
# Usage:
# - ./scripts/llm/serve.sh    # llama-server を :8080 で起動
#

set -e

MODEL_DIR="$HOME/models/Qwen3.8-27B-Uncensored"
QUANT="${LLM_QUANT:-Q8_0}"
CTX_SIZE="${LLM_CTX_SIZE:-262144}"
CACHE_TYPE="${LLM_CACHE_TYPE:-f16}"
HOST="${LLM_HOST:-127.0.0.1}"
SLEEP_IDLE_SECONDS="${LLM_SLEEP_IDLE_SECONDS:-3600}"

if ! command -v "$HOME/.local/bin/llama-server" &>/dev/null; then
  echo "llama-server not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

export LLAMA_ARG_CHAT_TEMPLATE_KWARGS='{"preserve_thinking": true, "reasoning_effort": "medium"}'

exec "$HOME/.local/bin/llama-server" \
  -m "$MODEL_DIR/Qwen3.8-27B-Uncensored-${QUANT}.gguf" \
  --alias "Qwen3.8-27B-Uncensored-${QUANT}" \
  --mmproj "$MODEL_DIR/mmproj-Qwen3.8-27B-Uncensored-f16.gguf" \
  --host "$HOST" \
  --port 8080 \
  -ngl 99 \
  -fa on \
  --parallel 1 \
  --ctx-size "$CTX_SIZE" \
  --cache-type-k "$CACHE_TYPE" \
  --cache-type-v "$CACHE_TYPE" \
  --load-mode mlock \
  -b 4096 \
  -ub 4096 \
  --metrics \
  --jinja \
  --temp 0.6 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0 \
  --presence-penalty 0.5 \
  --repeat-penalty 1.0 \
  --sleep-idle-seconds "$SLEEP_IDLE_SECONDS" \
  --spec-type draft-mtp \
  --spec-draft-n-max 8 \
  --spec-draft-p-min 0.5 \
  "$@"
