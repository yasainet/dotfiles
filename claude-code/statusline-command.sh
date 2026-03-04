#!/bin/sh
input=$(cat)
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
short_dir=$(echo "$project_dir" | sed "s|^/Users/[^/]*|~|")
branch=$(git -C "$project_dir" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -n "$branch" ]; then
  stats=$(git -C "$project_dir" --no-optional-locks diff --numstat HEAD 2>/dev/null)
  if [ -n "$stats" ]; then
    added=$(echo "$stats" | awk '{ a += $1 } END { print a+0 }')
    removed=$(echo "$stats" | awk '{ r += $2 } END { print r+0 }')
    printf "%s (%s) \033[38;2;158;206;106m+%s\033[0m \033[38;2;247;118;142m-%s\033[0m" "$short_dir" "$branch" "$added" "$removed"
  else
    printf "%s (%s)" "$short_dir" "$branch"
  fi
else
  printf "%s" "$short_dir"
fi
