#!/bin/bash
#
# Usage:
# - ./scripts/llm/fetch.sh    # GGUF を ~/models へ取得
#

set -e

QUANT="${LLM_QUANT:-Q3_K_L}"
REPO="orcarouter/Qwen3.8-Flash-Next-Uncensored-GGUF"
NAME="Qwen3.8-Flash-Next-Uncensored"

MODELS=(
  "$REPO ${NAME}-${QUANT}-00001-of-00003.gguf $NAME"
  "$REPO ${NAME}-${QUANT}-00002-of-00003.gguf $NAME"
  "$REPO ${NAME}-${QUANT}-00003-of-00003.gguf $NAME"
  "$REPO mmproj-${NAME}-F16.gguf $NAME"
)

HF_TOKEN="${HF_TOKEN:-$(cat "$HOME/.cache/huggingface/token" 2>/dev/null || true)}"

echo "=== Fetching models into $HOME/models (quant: $QUANT) ==="

for m in "${MODELS[@]}"; do
  read -r repo file subdir <<<"$m"
  echo "  [fetch] $subdir/$file"
  curl -L -C - --retry 1000 --retry-delay 3 --retry-all-errors --speed-limit 500000 --speed-time 30 \
    --fail \
    ${HF_TOKEN:+--header @<(printf 'Authorization: Bearer %s\n' "$HF_TOKEN")} \
    --create-dirs -o "$HOME/models/$subdir/$file" "https://huggingface.co/$repo/resolve/main/$file"
done

echo ""
echo "=== Fetch complete! ==="
