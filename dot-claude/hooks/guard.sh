#!/bin/sh
command=$(jq -r '.tool_input.command // ""')

case "$command" in
rm | rm\ *)
  echo "Don't use rm. Use trash <path> instead." >&2
  exit 2
  ;;
esac
