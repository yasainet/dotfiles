#!/bin/sh
input=$(cat)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .workspace.project_dir')
short_dir=$(echo "$current_dir" | sed "s|^/Users/[^/]*|~|")
branch=$(git -C "$current_dir" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

ctx=""
if [ -n "$context_pct" ]; then
  ctx=$(printf "%.0f%%" "$context_pct")
fi

line1="$short_dir"
if [ -n "$branch" ]; then
  line1=$(printf "%s (%s)" "$line1" "$branch")

  stats=$(git -C "$current_dir" --no-optional-locks diff --numstat HEAD 2>/dev/null)
  if [ -n "$stats" ]; then
    added=$(echo "$stats" | awk '{ a += $1 } END { print a+0 }')
    removed=$(echo "$stats" | awk '{ r += $2 } END { print r+0 }')
    line1=$(printf "%s \033[38;2;158;206;106m+%s\033[0m \033[38;2;247;118;142m-%s\033[0m" "$line1" "$added" "$removed")
  fi
fi

line2=""
for part in "$model" "$effort" "$ctx"; do
  [ -n "$part" ] || continue
  if [ -n "$line2" ]; then
    line2=$(printf "%s | %s" "$line2" "$part")
  else
    line2="$part"
  fi
done

badge=""
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL) mode_bg="38;2;122;162;247" ;;
    INSERT) mode_bg="38;2;158;206;106" ;;
    *) mode_bg="38;2;187;154;247" ;;
  esac
  badge=$(printf "\033[1;%sm%s\033[0m " "$mode_bg" "$vim_mode")
fi

if [ -n "$line2" ]; then
  printf "%s%s\n\033[38;2;86;95;137m%s\033[0m" "$badge" "$line1" "$line2"
else
  printf "%s%s" "$badge" "$line1"
fi
