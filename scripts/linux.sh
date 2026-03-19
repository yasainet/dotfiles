#!/bin/bash

# Linux-specific installation (Ubuntu/Debian)

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools..."

  sudo true

  sudo apt update

  sudo apt install -y locales
  sudo locale-gen en_US.UTF-8

  sudo apt install -y curl wget zsh software-properties-common
  sudo apt install -y bat btop fd-find fzf ripgrep tree jq
  sudo apt install -y zsh-autosuggestions zsh-syntax-highlighting

  # Neovim
  if ! command -v nvim &> /dev/null || [[ "$(nvim --version | head -1)" < "NVIM v0.10" ]]; then
    echo "Installing Neovim from PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
  fi
  sudo apt install -y ffmpeg
  sudo apt install -y xclip
}

# ====================
# Set Zsh as Default Shell
# ====================
set_default_shell() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

# ====================
# Zsh Plugins (git clone fallback)
# ====================
install_zsh_plugins() {
  echo "Installing Zsh plugins..."

  local plugin_dir="$HOME/.local/share/zsh/plugins"
  mkdir -p "$plugin_dir"

  # Pure prompt
  if [ ! -d "$plugin_dir/pure" ]; then
    git clone "https://github.com/sindresorhus/pure.git" "$plugin_dir/pure"
    echo "  [done] pure"
  else
    echo "  [skip] pure (already installed)"
  fi

  # zsh-completions
  if [ ! -d "$plugin_dir/zsh-completions" ]; then
    git clone "https://github.com/zsh-users/zsh-completions.git" "$plugin_dir/zsh-completions"
    echo "  [done] zsh-completions"
  else
    echo "  [skip] zsh-completions (already installed)"
  fi
}

# ====================
# Main (Linux)
# ====================
install_packages() {
  install_cli_tools
  set_default_shell
  install_zsh_plugins
}
