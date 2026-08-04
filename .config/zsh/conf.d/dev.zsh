alldown() {
  if ! docker info &>/dev/null; then
    echo "docker is not running"
    return 0
  fi

  command -v supabase &>/dev/null && supabase stop --all

  local ids
  ids=$(docker ps -q)
  [[ -n "$ids" ]] && docker stop $ids

  return 0
}
