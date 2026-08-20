#!/bin/bash
#
# Usage:
# - ./scripts/llm/fetch.sh    # GGUF を ~/models へ取得
#

set -e

QUANT="${LLM_QUANT:-Q8_0}"

MODELS=(
  "orcarouter/Qwen3.8-27B-Uncensored-GGUF Qwen3.8-27B-Uncensored-${QUANT}.gguf Qwen3.8-27B-Uncensored"
  "orcarouter/Qwen3.8-27B-Uncensored-GGUF mmproj-Qwen3.8-27B-Uncensored-f16.gguf Qwen3.8-27B-Uncensored"
)

HF_TOKEN="${HF_TOKEN:-$(cat "$HOME/.cache/huggingface/token" 2>/dev/null || true)}"

echo "=== Fetching models into $HOME/models (quant: $QUANT) ==="

for m in "${MODELS[@]}"; do
  read -r repo file subdir <<<"$m"
  echo "  [fetch] $subdir/$file"
  curl -L -C - --retry 1000 --retry-delay 3 --retry-all-errors --speed-limit 500000 --speed-time 30 \
    ${HF_TOKEN:+-H "Authorization: Bearer $HF_TOKEN"} \
    --create-dirs -o "$HOME/models/$subdir/$file" "https://huggingface.co/$repo/resolve/main/$file"
done

echo ""
echo "=== Fetch complete! ==="
