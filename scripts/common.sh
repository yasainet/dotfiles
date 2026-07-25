#!/bin/bash

# ====================
# Symlinks
# ====================

# .config entries this OS does not use. Overridden in scripts/{darwin,linux}.sh,
# which are sourced after this file.
SKIP_LINKS=()

link() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    local current
    current=$(readlink "$dest")
    if [ "$current" = "$src" ]; then
      echo "  [skip] $dest (already linked)"
    else
      ln -sfn "$src" "$dest"
      echo "  [relink] $dest -> $src (was: $current)"
    fi
  elif [ -e "$dest" ]; then
    echo "  [warn] $dest exists (backup and remove manually)"
  else
    ln -s "$src" "$dest"
    echo "  [link] $dest -> $src"
  fi
}

is_skipped_link() {
  local name="$1"
  local skip

  for skip in "${SKIP_LINKS[@]}"; do
    [ "$name" = "$skip" ] && return 0
  done
  return 1
}

# Drop an entry this OS does not use, removing a stale link left by an older run.
# Only unlinks symlinks pointing into $DOTFILES; anything else is left alone.
skip_link() {
  local name="$1"
  local dest="$HOME/.config/$name"

  if [ -L "$dest" ]; then
    local current
    current=$(readlink "$dest")
    case "$current" in
      "$DOTFILES"/*)
        rm -f "$dest"
        echo "  [unlink] $dest (not used on $OS)"
        return
        ;;
      *)
        echo "  [warn] $dest points outside dotfiles (left as-is)"
        return
        ;;
    esac
  fi

  echo "  [skip] $name (not used on $OS)"
}

create_symlinks() {
  echo "Creating symlinks..."
  mkdir -p "$HOME/.config"

  for dir in "$DOTFILES/.config/"*/; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")

    if is_skipped_link "$name"; then
      skip_link "$name"
      continue
    fi

    link "$dir" "$HOME/.config/$name"
  done

  # .zshenv
  link "$DOTFILES/.config/zsh/.zshenv" "$HOME/.zshenv"
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
