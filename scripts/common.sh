#!/bin/bash

# Common functions for all platforms

DOTFILES="$HOME/dotfiles"

# ====================
# Symlinks
# ====================
link() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    echo "  [skip] $dest (already linked)"
  elif [ -e "$dest" ]; then
    echo "  [warn] $dest exists (backup and remove manually)"
  else
    ln -s "$src" "$dest"
    echo "  [link] $dest -> $src"
  fi
}

create_symlinks() {
  echo "Creating symlinks..."
  mkdir -p "$HOME/.config"

  for dir in "$DOTFILES/.config/"*/; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    link "$dir" "$HOME/.config/$name"
  done

  # .zprofile
  link "$DOTFILES/.config/zsh/.zprofile" "$HOME/.zprofile"

  # .zshenv
  link "$DOTFILES/.config/zsh/.zshenv" "$HOME/.zshenv"

  # .oh-my-zsh
  link "$DOTFILES/.config/.oh-my-zsh" "$HOME/.config/.oh-my-zsh"
}

# ====================
# Node.js (nvm)
# ====================
install_nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o /tmp/nvm-install.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh
    bash /tmp/nvm-install.sh
    rm -f /tmp/nvm-install.sh
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 24
  else
    echo "nvm already installed"
  fi
}

# ====================
# Post-install
# ====================
post_install() {
  echo "Running post-install setup..."

  # bat cache
  if command -v bat &> /dev/null; then
    bat cache --build
  fi
}
