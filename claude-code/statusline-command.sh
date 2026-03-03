#!/bin/sh
input=$(cat)
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
short_dir=$(echo "$project_dir" | sed "s|^/Users/[^/]*|~|")
branch=$(git -C "$project_dir" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  printf "%s (%s)" "$short_dir" "$branch"
else
  printf "%s" "$short_dir"
fi
