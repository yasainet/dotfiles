#!/bin/bash
#
# Usage:
# - ./scripts/llm/webui.sh
#

set -e

if ! command -v uvx &>/dev/null; then
  echo "uv not found. Run DOTFILES_PROFILE=llm ./install.sh first."
  exit 1
fi

export DATA_DIR="$HOME/.open-webui"
export OPENAI_API_BASE_URL="http://127.0.0.1:${WEBUI_LLM_PORT:-8081}/v1"
export OPENAI_API_KEY="dummy"
export ENABLE_OLLAMA_API=false
export ENABLE_WEB_SEARCH=true
export WEB_SEARCH_ENGINE="${WEBUI_SEARCH_ENGINE:-duckduckgo}"
export WEB_SEARCH_RESULT_COUNT=5
export WEB_SEARCH_CONCURRENT_REQUESTS=5
export WEBUI_AUTH=false
export ENABLE_SIGNUP=false

exec uvx --python 3.11 open-webui@latest serve --host 127.0.0.1 --port 3000 "$@"
