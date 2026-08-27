#!/bin/bash
#
# Usage:
# - ./scripts/llm/serve-webui.sh    # Open WebUI 用 llama-server を :8081 で起動(Q4_K_M, ctx 32768)
#

export LLM_QUANT="${LLM_QUANT:-Q4_K_M}"
export LLM_CTX_SIZE="${LLM_CTX_SIZE:-32768}"
export LLM_PORT="${LLM_PORT:-8081}"

exec "$(dirname "$0")/serve.sh" "$@"
