#!/bin/bash

set -e

NAME="gemma-4-26B-A4B-abliterated"
MODEL_DIR="$HOME/models/$NAME"
MODEL="$MODEL_DIR/Huihui-gemma-4-26B-A4B-it-qat-q4_0-unquantized-abliterated-Q4_K.gguf"
CTX_SIZE="${LLM_SUMMARY_CTX_SIZE:-32768}"
HOST="${LLM_HOST:-127.0.0.1}"

if ! command -v "$HOME/.local/bin/llama-server" &>/dev/null; then
  echo "llama-server not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

if [ ! -f "$MODEL" ]; then
  echo "$NAME not found. Run ./scripts/llm/fetch.sh first."
  exit 1
fi

exec "$HOME/.local/bin/llama-server" \
  -m "$MODEL" \
  --alias "$NAME" \
  --host "$HOST" \
  --port 8081 \
  -ngl 99 \
  -fa on \
  --parallel 1 \
  --ctx-size "$CTX_SIZE" \
  -fit off \
  -b 4096 \
  -ub 1024 \
  --metrics \
  --jinja \
  --chat-template-kwargs '{"enable_thinking":false}' \
  --temp 1.0 \
  --top-p 0.95 \
  --top-k 64 \
  "$@"
