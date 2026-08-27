#!/bin/bash
#
# Usage:
# - ./scripts/llm/webui.sh         # Open WebUI + SearXNG を :3000 で起動
# - ./scripts/llm/webui.sh down    # 停止
# - ./scripts/llm/webui.sh pull    # イメージ更新
#

set -e

DIR="$(cd "$(dirname "$0")/webui" && pwd)"
ENV_FILE="$DIR/.env"

if ! command -v docker &>/dev/null; then
  echo "docker not found. Run DOTFILES_PROFILE=llm ./install.sh first (installs OrbStack)."
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "SEARXNG_SECRET=$(openssl rand -hex 32)" >"$ENV_FILE"
  echo "  [init] generated $ENV_FILE"
fi

case "${1:-up}" in
up) exec docker compose -f "$DIR/compose.yml" up -d ;;
down) exec docker compose -f "$DIR/compose.yml" down ;;
pull) docker compose -f "$DIR/compose.yml" pull && exec docker compose -f "$DIR/compose.yml" up -d ;;
*) echo "Usage: $0 [up|down|pull]"; exit 1 ;;
esac
