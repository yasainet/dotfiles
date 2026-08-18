#!/bin/bash
#
# Usage:
# - ./scripts/llm/fetch.sh    # GGUF を ~/models へ取得

set -e

MODELS=(
  "unsloth/Qwen3.6-35B-A3B-GGUF Qwen3.6-35B-A3B-Q8_0.gguf Qwen3.6-35B-A3B"
  "unsloth/Qwen3.6-35B-A3B-GGUF mmproj-F16.gguf Qwen3.6-35B-A3B"
  "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive"
  "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive mmproj-Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-f16.gguf Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive"
  "HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Balanced Qwen3.6-27B-Uncensored-HauhauCS-Balanced-Q8_K_P.gguf Qwen3.6-27B-Uncensored-HauhauCS-Balanced"
  "HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Balanced mmproj-Qwen3.6-27B-Uncensored-HauhauCS-Balanced-f16.gguf Qwen3.6-27B-Uncensored-HauhauCS-Balanced"
  "unsloth/Qwen3.8-27B-GGUF BF16/Qwen3.8-27B-BF16-00001-of-00002.gguf Qwen3.8-27B"
  "unsloth/Qwen3.8-27B-GGUF BF16/Qwen3.8-27B-BF16-00002-of-00002.gguf Qwen3.8-27B"
  "unsloth/Qwen3.8-27B-GGUF mmproj-BF16.gguf Qwen3.8-27B"
  "JonathanColetti/Qwen3.8-27B-Uncensored-GGUF Qwen3.8-27B-Uncensored-Q8_0.gguf Qwen3.8-27B-Uncensored"
  "JonathanColetti/Qwen3.8-27B-Uncensored-GGUF Qwen3.8-27B-Uncensored-vision-f16.gguf Qwen3.8-27B-Uncensored"
)

echo "=== Fetching models into $HOME/models ==="

for m in "${MODELS[@]}"; do
  read -r repo file subdir <<< "$m"
  echo "  [fetch] $subdir/$file"
  curl -L -C - --retry 1000 --retry-delay 3 --retry-all-errors --speed-limit 500000 --speed-time 30 \
    --create-dirs -o "$HOME/models/$subdir/$file" "https://huggingface.co/$repo/resolve/main/$file"
done

echo ""
echo "=== Fetch complete! ==="
