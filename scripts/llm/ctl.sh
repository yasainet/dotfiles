#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin/llama-server"
HEALTH_TIMEOUT="${LLM_HEALTH_TIMEOUT:-300}"

# name:serve script:port:log
SERVERS=(
  "main:$DIR/serve.sh:8080:$HOME/llama-server.log"
  "summary:$DIR/serve-summary.sh:8081:$HOME/llama-server-summary.log"
)

healthy() {
  curl -sf -m 2 "http://127.0.0.1:$1/health" >/dev/null
}

pid_of() {
  pgrep -f "$BIN.*--port $1" | head -1
}

up_one() {
  local name="$1" serve="$2" port="$3" log="$4"
  if healthy "$port"; then
    echo "llama-server[$name]: already up"
    return 0
  fi
  nohup "$serve" >>"$log" 2>&1 &
  local pid=$! i
  for ((i = 0; i < HEALTH_TIMEOUT; i++)); do
    if healthy "$port"; then
      echo "llama-server[$name]: up (${i}s)"
      return 0
    fi
    if ! kill -0 "$pid" 2>/dev/null; then
      echo "llama-server[$name]: exited during startup (see $log)" >&2
      tail -5 "$log" >&2
      return 1
    fi
    sleep 1
  done
  echo "llama-server[$name]: health timeout after ${HEALTH_TIMEOUT}s (see $log)" >&2
  return 1
}

down_one() {
  local name="$1" port="$3"
  local pid i
  pid="$(pid_of "$port")"
  [ -n "$pid" ] || return 0
  kill -INT "$pid"
  for ((i = 0; i < 30; i++)); do
    kill -0 "$pid" 2>/dev/null || break
    sleep 1
  done
}

status_one() {
  local name="$1" port="$3"
  local pid
  pid="$(pid_of "$port")"
  if healthy "$port"; then
    echo "llama-server[$name]: up (pid $pid)"
  elif [ -n "$pid" ]; then
    echo "llama-server[$name]: starting (pid $pid)"
  else
    echo "llama-server[$name]: down"
  fi
}

each() {
  local fn="$1" entry rc=0 name serve port log
  for entry in "${SERVERS[@]}"; do
    IFS=: read -r name serve port log <<<"$entry"
    "$fn" "$name" "$serve" "$port" "$log" || rc=1
  done
  return $rc
}

case "${1:-}" in
up) each up_one ;;
down) each down_one ;;
status) each status_one ;;
*)
  echo "usage: $0 {up|down|status}"
  exit 1
  ;;
esac
