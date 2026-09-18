#!/bin/bash

set -e

NAME="Qwen3.8-Flash-Next-Uncensored"
MODEL_DIR="$HOME/models/$NAME"
QUANT="${LLM_QUANT:-Q4_K_M}"
WIRED_LIMIT_MB="${LLM_WIRED_LIMIT_MB:-118784}"
CTX_SIZE="${LLM_CTX_SIZE:-262144}"
CACHE_TYPE="${LLM_CACHE_TYPE:-f16}"
HOST="${LLM_HOST:-127.0.0.1}"

if ! command -v "$HOME/.local/bin/llama-server" &>/dev/null; then
  echo "llama-server not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

MODEL="$(compgen -G "$MODEL_DIR/${NAME}-${QUANT}-00001-of-*.gguf" | head -1)"
if [ -z "$MODEL" ]; then
  echo "${NAME}-${QUANT} not found. Run ./scripts/llm/fetch.sh first."
  exit 1
fi

if [ "$(sysctl -n iogpu.wired_limit_mb 2>/dev/null || echo 0)" -lt "$WIRED_LIMIT_MB" ]; then
  sudo -n sysctl iogpu.wired_limit_mb="$WIRED_LIMIT_MB" || {
    echo "iogpu.wired_limit_mb < $WIRED_LIMIT_MB. Run: sudo sysctl iogpu.wired_limit_mb=$WIRED_LIMIT_MB" >&2
    exit 1
  }
fi

exec "$HOME/.local/bin/llama-server" \
  -m "$MODEL" \
  --alias "${NAME}-${QUANT}" \
  --mmproj "$MODEL_DIR/mmproj-${NAME}-F16.gguf" \
  --host "$HOST" \
  --port 8080 \
  -ngl 99 \
  -fa on \
  --parallel 1 \
  --ctx-size "$CTX_SIZE" \
  --cache-type-k "$CACHE_TYPE" \
  --cache-type-v "$CACHE_TYPE" \
  -fit off \
  -b 4096 \
  -ub 1024 \
  --metrics \
  --jinja \
  --temp 1.0 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0 \
  --presence-penalty 0.5 \
  --repeat-penalty 1.0 \
  "$@"
