#!/bin/bash
#
# Usage:
# - ./scripts/llm/serve.sh    # llama-server を :8080 で起動
#

set -e

NAME="Qwen3.8-Flash-Next-Uncensored"
MODEL_DIR="$HOME/models/$NAME"
QUANT="${LLM_QUANT:-Q3_K_L}"
WIRED_LIMIT_MB="${LLM_WIRED_LIMIT_MB:-118784}"
CTX_SIZE="${LLM_CTX_SIZE:-262144}"
CACHE_TYPE="${LLM_CACHE_TYPE:-f16}"
HOST="${LLM_HOST:-127.0.0.1}"
SLEEP_IDLE_SECONDS="${LLM_SLEEP_IDLE_SECONDS:-1800}"

if ! command -v "$HOME/.local/bin/llama-server" &>/dev/null; then
  echo "llama-server not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

# Metal wired 上限を拡張する (再起動で既定値に戻る)
if [ "$(sysctl -n iogpu.wired_limit_mb 2>/dev/null || echo 0)" -lt "$WIRED_LIMIT_MB" ]; then
  sudo sysctl iogpu.wired_limit_mb="$WIRED_LIMIT_MB"
fi

export LLAMA_ARG_CHAT_TEMPLATE_KWARGS='{"preserve_thinking": true, "reasoning_effort": "medium"}'

exec "$HOME/.local/bin/llama-server" \
  -m "$MODEL_DIR/${NAME}-${QUANT}-00001-of-00003.gguf" \
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
  --load-mode mlock \
  -b 4096 \
  -ub 4096 \
  --metrics \
  --jinja \
  --temp 1.0 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0 \
  --presence-penalty 0.5 \
  --repeat-penalty 1.0 \
  --sleep-idle-seconds "$SLEEP_IDLE_SECONDS" \
  "$@"
