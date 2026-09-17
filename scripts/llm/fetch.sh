#!/bin/bash

set -e

QUANT="${LLM_QUANT:-Q4_K_M}"
REPO="orcarouter/Qwen3.8-Flash-Next-Uncensored-GGUF"
NAME="Qwen3.8-Flash-Next-Uncensored"
MODEL_DIR="$HOME/models/$NAME"
RAW_DIR="$MODEL_DIR/raw"
SPLIT_BIN="$HOME/.local/bin/llama-gguf-split"
SPLIT_MAX_SIZE="${LLM_SPLIT_MAX_SIZE:-8G}"

HF_TOKEN="${HF_TOKEN:-$(cat "$HOME/.cache/huggingface/token" 2>/dev/null || true)}"

fetch() {
  local file="$1" dest="$2"
  echo "  [fetch] $file"
  curl -L -C - --retry 1000 --retry-delay 3 --retry-all-errors --speed-limit 500000 --speed-time 30 \
    --fail \
    ${HF_TOKEN:+--header @<(printf 'Authorization: Bearer %s\n' "$HF_TOKEN")} \
    --create-dirs -o "$dest/$file" "https://huggingface.co/$REPO/resolve/main/$file"
}

echo "=== Fetching models into $HOME/models (quant: $QUANT) ==="

fetch "mmproj-${NAME}-F16.gguf" "$MODEL_DIR"

if compgen -G "$MODEL_DIR/${NAME}-${QUANT}-00001-of-*.gguf" >/dev/null; then
  echo "  [skip] ${NAME}-${QUANT} already re-split"
else
  if [ ! -x "$SPLIT_BIN" ]; then
    echo "llama-gguf-split not found. Run DOTFILES_PROFILE=llm ./install.sh first."
    exit 1
  fi

  for i in 1 2 3; do
    fetch "${NAME}-${QUANT}-0000${i}-of-00003.gguf" "$RAW_DIR"
  done

  echo "  [split] ${NAME}-${QUANT} (max $SPLIT_MAX_SIZE)"
  "$SPLIT_BIN" --merge "$RAW_DIR/${NAME}-${QUANT}-00001-of-00003.gguf" "$RAW_DIR/merged.gguf"
  "$SPLIT_BIN" --split --split-max-size "$SPLIT_MAX_SIZE" "$RAW_DIR/merged.gguf" "$MODEL_DIR/${NAME}-${QUANT}"
  trash "$RAW_DIR"
fi

echo ""
echo "=== Fetch complete! ==="
