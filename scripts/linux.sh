#!/bin/bash

# Linux-specific installation (Ubuntu/Debian)

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools..."

  sudo true

  sudo apt update

  # Locale (required for UTF-8 support)
  sudo apt install -y locales
  sudo locale-gen en_US.UTF-8

  sudo apt install -y curl wget zsh
  sudo apt install -y neovim
  sudo apt install -y bat fzf ripgrep tree jq
  sudo apt install -y ffmpeg
  sudo apt install -y xclip

  # Starship
  if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh -o /tmp/starship-install.sh
    sudo sh /tmp/starship-install.sh -y
    rm -f /tmp/starship-install.sh
  fi
}

# ====================
# Oh My Zsh Plugins
# ====================
install_omz_plugins() {
  local plugins_dir="$HOME/.config/.oh-my-zsh/custom/plugins"

  echo "Installing Oh My Zsh plugins..."

  if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
  fi

  if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"
  fi

  if [ ! -d "$plugins_dir/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "$plugins_dir/zsh-completions"
  fi
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
# Main (Linux)
# ====================
install_packages() {
  install_cli_tools
  install_omz_plugins
  set_default_shell
}
