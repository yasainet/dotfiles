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

  # .zshenv
  link "$DOTFILES/.config/zsh/.zshenv" "$HOME/.zshenv"

  # .oh-my-zsh - macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    link "$DOTFILES/.config/.oh-my-zsh" "$HOME/.config/.oh-my-zsh"
  fi

  # Claude Code
  mkdir -p "$HOME/.claude"
  link "$DOTFILES/claude-code/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  link "$DOTFILES/claude-code/settings.json" "$HOME/.claude/settings.json"
  link "$DOTFILES/claude-code/rules" "$HOME/.claude/rules"
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
# bat theme
# ====================
setup_bat_theme() {
  echo "Setting up bat theme..."

  # Determine bat command (macOS: bat, Linux: batcat)
  if command -v bat &> /dev/null; then
    BAT_CMD="bat"
  elif command -v batcat &> /dev/null; then
    BAT_CMD="batcat"
  else
    echo "  [skip] bat not installed"
    return
  fi

  BAT_CONFIG_DIR="$($BAT_CMD --config-dir)"
  mkdir -p "$BAT_CONFIG_DIR/themes"

  # Download tokyonight theme
  THEME_URL="https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme"
  curl -sL "$THEME_URL" -o "$BAT_CONFIG_DIR/themes/tokyonight_night.tmTheme"
  echo "  [download] tokyonight_night.tmTheme"

  # Build cache
  $BAT_CMD cache --build
  echo "  [done] bat theme setup complete"
}

# ====================
# Post-install
# ====================
post_install() {
  echo "Running post-install setup..."
  setup_bat_theme
}
