#!/bin/bash
#
# Usage:
# - ./scripts/llm/ctl.sh up      # llama-server を起動し、health を待つ
# - ./scripts/llm/ctl.sh down    # llama-server を止める
# - ./scripts/llm/ctl.sh status  # llama-server の状態を表示する
#

set -e

SERVE="$(cd "$(dirname "$0")" && pwd)/serve.sh"
BIN="$HOME/.local/bin/llama-server"
LOG="$HOME/llama-server.log"
HEALTH="http://127.0.0.1:8080/health"
HEALTH_TIMEOUT="${LLM_HEALTH_TIMEOUT:-300}"

healthy() {
  curl -sf -m 2 "$HEALTH" >/dev/null
}

up() {
  if healthy; then
    echo "llama-server: already up"
    return 0
  fi
  nohup "$SERVE" >>"$LOG" 2>&1 &
  local pid=$! i
  for ((i = 0; i < HEALTH_TIMEOUT; i++)); do
    if healthy; then
      echo "llama-server: up (${i}s)"
      return 0
    fi
    if ! kill -0 "$pid" 2>/dev/null; then
      echo "llama-server: exited during startup (see $LOG)" >&2
      tail -5 "$LOG" >&2
      return 1
    fi
    sleep 1
  done
  echo "llama-server: health timeout after ${HEALTH_TIMEOUT}s (see $LOG)" >&2
  return 1
}

down() {
  pkill -INT -f "$BIN" || true
  local i
  for ((i = 0; i < 30; i++)); do
    pgrep -f "$BIN" >/dev/null || break
    sleep 1
  done
}

status() {
  if healthy; then
    echo "llama-server: up (pid $(pgrep -f "$BIN" | head -1))"
  elif pgrep -f "$BIN" >/dev/null; then
    echo "llama-server: starting (pid $(pgrep -f "$BIN" | head -1))"
  else
    echo "llama-server: down"
  fi
}

case "${1:-}" in
up | down | status)
  "$1"
  ;;
*)
  sed -n '3,7p' "$0"
  exit 1
  ;;
esac
