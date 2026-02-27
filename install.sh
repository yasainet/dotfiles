#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"
OS="$(uname -s)"

echo "=== Dotfiles Installer ==="
echo "Detected OS: $OS"

source "$DOTFILES/scripts/common.sh"

case "$OS" in
  Darwin)
    source "$DOTFILES/scripts/darwin.sh"
    ;;
  Linux)
    source "$DOTFILES/scripts/linux.sh"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# ====================
# Main
# ====================
main() {
  create_symlinks
  install_packages
  install_nvm
  post_install

  if [ "$OS" = "Darwin" ]; then
    configure_system
  fi

  echo ""
  echo "=== Setup complete! ==="
  echo "Restart your shell: exec zsh"
}

main "$@"
