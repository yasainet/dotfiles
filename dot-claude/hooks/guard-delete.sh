#!/usr/bin/env bash
# PreToolUse(Bash): ファイル削除を rm から trash へ寄せる
#
# settings.json の permissions.deny (Bash(rm:*), Bash(sudo rm:*)) が floor。
# この hook はそこに 2 つを足す
#
# - deny rule が構造上覆えない経路を塞ぐ
# - block した理由と代替 (trash) を Claude に返す。deny rule は理由を伝えない
#
# 塞ぐ経路。いずれも prefix rule の対象外だと公式が明記している
# - xargs -n1 rm     : flag 付き xargs は wrapper 剥がしの対象外で、内側に届かない
# - find -exec rm    : find の -exec / -delete は prefix rule で覆えない
# - npx, docker exec : 引数をコマンドとして実行するが wrapper 一覧に無い
# - sh -c 'rm -rf x' : quote の中は permission rule から見えない
#
# jq が無い等でこの hook が落ちたときは素通りする。deny rule が floor に残る
set -uf

JQ=/opt/homebrew/bin/jq
[ -x "$JQ" ] || JQ=jq

# shellcheck source=lib/mask.sh
. "${BASH_SOURCE[0]%/*}/lib/mask.sh" || exit 0

IFS= read -rd '' input

# rm も -delete も無ければ即抜ける。Bash 呼び出しの大半はここで終わる
case $input in
  *rm* | *-delete*) ;;
  *) exit 0 ;;
esac

cmd=$("$JQ" -r '.tool_input.command // ""' <<<"$input")
[ -z "$cmd" ] && exit 0

TRASH="Use trash instead. It moves the target to the Finder trash, so a mistake stays recoverable; rm does not. If the file must really be destroyed, ask the user."

deny() {
  "$JQ" -n --arg r "$1 $TRASH" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

# 単語としての rm。/bin/rm と、quote 直後の "rm も拾う
RM_RE="(^|[[:space:]/\"'])rm([[:space:]\"']|\$)"
has_rm() { [[ $1 =~ $RM_RE ]]; }

segments=$(mask <<<"$cmd")

# ; & | 改行 で区切り、各 segment の先頭語をコマンド名として見る
while IFS= read -r seg; do
  # 先頭の空白・( ・$( ・` と、sudo・環境変数代入 (FOO=bar など) を落とす
  while [[ $seg =~ ^([[:space:]]+|\(|\$\(|\`|sudo[[:space:]]+|[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)(.*)$ ]]; do
    seg=${BASH_REMATCH[2]}
  done

  first=${seg%%[[:space:]]*}
  name=${first##*/}
  rest=${seg#"$first"}

  case $name in
    rm)
      deny "rm deletes irreversibly."
      ;;
    xargs)
      has_rm "$rest" && deny "xargs with flags is not unwrapped by permission rules, so this reaches rm past the deny rule for it."
      ;;
    find)
      case $rest in
        *-delete*) deny "find -delete removes files irreversibly." ;;
        *-exec* | *-execdir* | *-ok*)
          has_rm "$rest" && deny "find -exec is not covered by prefix rules, so this reaches rm past the deny rule for it."
          ;;
      esac
      ;;
    # 引数をコマンドとして実行するが、wrapper 剥がしの一覧に入っていないもの
    npx | docker | podman | devbox | mise | direnv | nix | env | ssh)
      has_rm "$rest" && deny "$name runs its arguments as a command and is not unwrapped by permission rules, so this reaches rm past the deny rule for it."
      ;;
    # -c の引数は quote されていて mask 済みなので、生のコマンド全体を見る。
    # script を渡すだけの `bash foo.sh` は対象外
    sh | bash | zsh | dash | ksh)
      case " $rest " in *' -c '*) ;; *) continue ;; esac
      has_rm "$cmd" && deny "A quoted command string is invisible to permission rules, so this can reach rm past the deny rule for it."
      ;;
    eval)
      has_rm "$cmd" && deny "eval builds its command at runtime, so permission rules cannot see what it runs."
      ;;
  esac
done <<<"${segments//[;&|]/$'\n'}"

exit 0
