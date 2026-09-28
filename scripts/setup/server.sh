#!/bin/bash

# ====================
# CLI tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools (server profile)..."

  brew install git
  brew install gh
  brew install lazygit
  brew install neovim
  brew install tree-sitter-cli
  brew install lua-language-server
  brew install ripgrep
  brew install fd
  brew install fzf
  brew install bat
  brew install ghq
  brew install jq
  brew install yq
  brew install btop
  brew install fastfetch
  brew install herdr
  brew install hunk
  brew install yazi
  brew install uv
  brew install tailscale
  brew install direnv
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install zsh-completions
  brew install pure
}

install_gui_apps() {
  echo "  [skip] GUI apps (server profile)"
}
