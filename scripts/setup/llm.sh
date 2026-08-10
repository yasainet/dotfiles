#!/bin/bash

# ====================
# Symlinks
# ====================
SKIP_LINKS+=(
  ghostty
  espanso
  hammerspoon
  karabiner
  snapzy
)

LLAMA_SWAP_VER="v222"

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools (llm profile)..."

  brew tap anomalyco/tap
  brew trust anomalyco/tap || true

  brew install git
  brew install git-lfs
  brew install gh
  brew install lazygit
  brew install neovim
  brew install bat
  brew install fzf
  brew install ghq
  brew install ripgrep
  brew install fd
  brew install tree
  brew install jq
  brew install yq
  brew install btop
  brew install fastfetch
  brew install herdr
  brew install yazi
  brew install glow
  brew install tailspin
  brew install direnv
  brew install tailscale
  brew install hunk

  # opencode
  brew install anomalyco/tap/opencode

  # Zsh plugins
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install zsh-completions
  brew install pure

  # Claude Code CLI
  if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  brew install llama.cpp
  brew install hf
  install_llama_swap
}

install_llama_swap() {
  if [ -x "$HOME/.local/bin/llama-swap" ]; then
    echo "  [skip] llama-swap already installed"
    return
  fi

  mkdir -p "$HOME/.local/bin"
  curl -sL "https://github.com/mostlygeek/llama-swap/releases/download/${LLAMA_SWAP_VER}/llama-swap_${LLAMA_SWAP_VER#v}_darwin_arm64.tar.gz" |
    tar -xz -C "$HOME/.local/bin" llama-swap
  chmod +x "$HOME/.local/bin/llama-swap"
  echo "  [install] llama-swap ${LLAMA_SWAP_VER}"
}

# ====================
# Skipped on this profile
# ====================
install_gui_apps() {
  echo "  [skip] GUI apps (llm profile)"
}

install_mas_apps() {
  echo "  [skip] App Store apps (llm profile)"
}

install_npm_globals() {
  echo "  [skip] npm globals (llm profile)"
}

link_espanso() {
  echo "  [skip] espanso (llm profile)"
}

# ====================
# LLM host
# ====================
link_llama_swap_agent() {
  echo "Installing llama-swap LaunchAgent..."

  local plist="$HOME/Library/LaunchAgents/com.yasainet.llama-swap.plist"
  mkdir -p "$HOME/Library/LaunchAgents"

  sed -e "s|@HOME@|$HOME|g" \
    "$DOTFILES/extras/launchd/com.yasainet.llama-swap.plist" >"$plist"

  launchctl bootout "gui/$(id -u)/com.yasainet.llama-swap" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$plist"
  echo "  [done] com.yasainet.llama-swap"
}

setup_profile() {
  echo "Configuring LLM host..."

  # 電源アダプタ接続時はスリープしない
  sudo pmset -c sleep 0
  # 蓋を閉じてもスリープしない (clamshell 運用)
  sudo pmset -c disablesleep 1
  # ディスプレイは 10 分で消す (画面は使わない)
  sudo pmset -c displaysleep 10
  # 停電復帰後に自動で起動する
  sudo pmset -c autorestart 1
  # スリープ後もネットワークからの接続で起きる
  sudo pmset -c womp 1

  # リモートログイン (ssh) を有効化。
  if ! sudo systemsetup -setremotelogin on 2>/dev/null; then
    echo "  [warn] systemsetup -setremotelogin に失敗した"
    echo "         System Settings -> General -> Sharing -> Remote Login を手動で ON にすること"
  fi

  link_llama_swap_agent
}

# ====================
# Manual setup
# ====================
#
# 1. マシン名を MacBook-Pro-2023 にする (README の Rename machine を参照)
# 2. tailscale up
# 3. 画面共有: System Settings -> General -> Sharing -> Screen Sharing
#    再起動後、GUI にログインしないと llama-swap が上がらないため
# 4. ./scripts/llm/fetch.sh でモデルを取得
