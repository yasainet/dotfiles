#!/bin/sh
deny() {
  echo "$1" >&2
  exit 2
}

jq -r '.tool_input.command // "" | splits("[;&|\n]")' | while read -r first second _; do
  [ "$first" = sudo ] && first=$second
  case "${first##*/}" in
  rm) deny "Don't use rm. Use trash <path> instead." ;;
  esac
done
