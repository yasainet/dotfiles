#!/bin/bash

# Linux-specific installation (Ubuntu/Debian)

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools..."

  sudo true

  sudo apt update

  sudo apt install -y curl wget zsh
  sudo apt install -y neovim
  sudo apt install -y bat fzf ripgrep tree jq
  sudo apt install -y ffmpeg
  sudo apt install -y xclip

  # Starship
  if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh -o /tmp/starship-install.sh
    sh /tmp/starship-install.sh -y
    rm -f /tmp/starship-install.sh
  fi
}

# ====================
# Set Zsh as Default Shell
# ====================
set_default_shell() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
  fi
}

# ====================
# Main (Linux)
# ====================
install_packages() {
  install_cli_tools
  set_default_shell
}
