opencode() {
  local agent="com.yasainet.llama-swap"

  if ! curl -sf -m2 "$LLM_URL/health" >/dev/null 2>&1; then
    if command -v llama-swap &>/dev/null; then
      launchctl kickstart -k "gui/$UID/$agent" 2>/dev/null
    else
      ssh MacBook-Pro-2023 "launchctl kickstart -k gui/\$(id -u)/$agent" 2>/dev/null
    fi
    curl -sf -m2 --retry 30 --retry-delay 1 --retry-connrefused --retry-all-errors \
      "$LLM_URL/health" >/dev/null 2>&1
  fi
  command opencode "$@"
}
