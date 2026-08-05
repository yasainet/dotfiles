#!/usr/bin/env bash
# PreToolUse(Bash): process と port の生殺を制御する
#
# 判定軸は「コマンドの形」ではなく「対象の所有者」。permission rule では
# 表現できない軸なので hook でやる
#
# - pkill / killall / xargs kill は deny。pattern では対象を区別できない
#   (next dev と next start は同じ process.title "next-server (vX)" を名乗る)
# - kill <PID> は対象の祖先に claude が居れば allow、他人なら ask
# - dev server は port が LISTEN 中なら deny、AGENT_PORT_MIN 未満なら ask
#
# settings.json の permissions.ask (kill / pkill / killall) は floor として残す。
# jq が無い等でこの hook が落ちたときに素通りさせないため、set -e は使わない
set -uf

# agent が server を立てるときに使う port 帯。この外は user のものと見る。
# framework ごとの default port (3000, 5173, 8080...) を列挙しないための線引き
AGENT_PORT_MIN=3100
AGENT_PORT_MAX=3199

# PATH 検索の fork を避ける
JQ=/opt/homebrew/bin/jq
[ -x "$JQ" ] || JQ=jq
LSOF=/usr/sbin/lsof
[ -x "$LSOF" ] || LSOF=lsof

# shellcheck source=lib/mask.sh
. "${BASH_SOURCE[0]%/*}/lib/mask.sh" || exit 0

IFS= read -rd '' input

# 見張る名前が 1 つも無ければ即抜ける。Bash 呼び出しの大半はここで終わり、
# jq も awk も起動しない
case $input in
  *kill* | *fuser* | *npm* | *pnpm* | *yarn* | *bun* | *npx* | *next* | *vite* | *nuxt* | *astro* | *remix* | *serve*) ;;
  *) exit 0 ;;
esac

cmd=$("$JQ" -r '.tool_input.command // ""' <<<"$input")
[ -z "$cmd" ] && exit 0

TARGET=

# $1=allow|deny|ask $2=reason
decide() {
  "$JQ" -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  exit 0
}

# 対象 PID の祖先に claude が居れば agent が起動した process。
# 併せて $TARGET に「PID コマンド行」を残す (message 用)
mine() {
  local pid=$1 depth=0 ppid args out
  while [ "$depth" -lt 20 ]; do
    out=$(ps -o ppid=,command= -p "$pid" 2>/dev/null)
    [ -z "$out" ] && return 1
    read -r ppid args <<<"$out"
    [ "$depth" = 0 ] && TARGET="$pid ${args:0:110}"
    case $args in
      *.claude/shell-snapshots* | */bin/claude* | *' claude '*) return 0 ;;
    esac
    case $ppid in '' | 0 | 1 | *[!0-9]*) return 1 ;; esac
    pid=$ppid
    depth=$((depth + 1))
  done
  return 1
}

# dev server 起動の port を見る
check_port() {
  local port=3000 pid
  [[ $cmd =~ PORT=([0-9]+) ]] && port=${BASH_REMATCH[1]}
  [[ $seg =~ (-p|--port)[[:space:]=]+([0-9]+) ]] && port=${BASH_REMATCH[2]}

  pid=$("$LSOF" -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null)
  pid=${pid%%$'\n'*}
  if [ -n "$pid" ]; then
    if mine "$pid"; then
      decide deny "Port $port is already served by an agent-started server:
  $TARGET
Do not start a second one. curl that server to verify."
    fi
    decide deny "Port $port is served by the user's own server:
  $TARGET
Do not stop it. HMR picks up your edits, so curl that server to verify. If you truly need an isolated server, use PORT=$AGENT_PORT_MIN."
  fi

  [ "$port" -ge "$AGENT_PORT_MIN" ] && [ "$port" -le "$AGENT_PORT_MAX" ] && return 0
  decide ask "Port $port belongs to the user. Agent servers must use $AGENT_PORT_MIN-$AGENT_PORT_MAX, e.g. PORT=$AGENT_PORT_MIN. If this exact port is required, say why and get approval."
}

allow_kill=
segments=$(mask <<<"$cmd")

# ; & | 改行 で区切り、各 segment の先頭語をコマンド名として見る
while IFS= read -r seg; do
  # 先頭の空白・( ・$( ・` と、環境変数代入 (PORT=3100 など) を落とす
  while [[ $seg =~ ^([[:space:]]+|\(|\$\(|\`|[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)(.*)$ ]]; do
    seg=${BASH_REMATCH[2]}
  done

  first=${seg%%[[:space:]]*}
  name=${first##*/}
  rest=${seg#"$first"}

  case $name in
    pkill | killall)
      decide deny "pkill and killall match machine-wide and will hit the user's processes: next dev and next start share the same process title. Find the PID first, then kill it by PID: lsof -tiTCP:3000 -sTCP:LISTEN. To stop a background task you started, use the task stop control instead."
      ;;
    xargs)
      case $rest in
        *kill*) decide ask "xargs kill: the target PID is not visible in the command, so ownership cannot be checked. The user must decide." ;;
      esac
      ;;
    kill)
      pids=
      for w in $rest; do
        w=${w%\)}
        [[ $w =~ ^[0-9]+$ ]] && pids+="$w "
      done
      # $! や $(cat pid) のような形。所有者を判定できないので user に投げる
      [ -z "$pids" ] && decide ask "kill target is not a literal PID, so ownership cannot be checked. The user must decide."
      for p in $pids; do
        ps -p "$p" > /dev/null 2>&1 || continue # 既に居ない PID は放っておく
        mine "$p" || decide ask "PID $p was not started by the agent:
  $TARGET
The user must decide whether to stop it."
      done
      allow_kill=1
      ;;
    fuser | kill-port)
      decide ask "$name stops whatever is listening on that port, regardless of who started it. The user must decide."
      ;;
    npm | pnpm | yarn | bun | npx | next | vite | nuxt | astro | remix | serve)
      # port を掴む道具か、dev / start / preview / serve か、framework 単体か
      case $name$rest in
        *kill-port*) decide ask "kill-port stops whatever is listening on that port, regardless of who started it. The user must decide." ;;
        *' dev'* | *' start'* | *' preview'* | *' serve'* | next | vite | nuxt | astro | remix | serve) check_port ;;
      esac
      ;;
  esac
done <<<"${segments//[;&|]/$'\n'}"

[ -n "$allow_kill" ] && decide allow "Every target process was started by the agent."
exit 0
