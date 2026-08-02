# Local LLM client
#
# LLM ホストは MacBook-Pro-2023 (tailscale 経由)。
# 接続先 LLM_URL は .zshenv で定義する。
# opencode.json が {env:LLM_URL} で参照するため、非対話シェルにも必要。
#
# ホスト側のセットアップと運用は dotfiles を参照:
#   DOTFILES_PROFILE=llm ./install.sh  初期セットアップ
#   scripts/llm/fetch.sh               モデル取得
#   scripts/llm/serve.sh               llama-swap 手動起動 (常駐の確認用)
#   docs/llm-host.md                   運用手順

# opencode 起動前に LLM ホストの llama-swap を起こす。
# 通常は LaunchAgent が常駐しているため、ここは落ちていた時の復旧経路。
opencode() {
  local agent="com.yasainet.llama-swap"

  if ! curl -sf -m2 "$LLM_URL/health" >/dev/null 2>&1; then
    if command -v llama-swap &>/dev/null; then
      # 自機が LLM ホスト
      launchctl kickstart -k "gui/$UID/$agent" 2>/dev/null
    else
      ssh MacBook-Pro-2023 "launchctl kickstart -k gui/\$(id -u)/$agent" 2>/dev/null
    fi
    curl -sf -m2 --retry 30 --retry-delay 1 --retry-connrefused --retry-all-errors \
      "$LLM_URL/health" >/dev/null 2>&1
  fi
  command opencode "$@"
}
