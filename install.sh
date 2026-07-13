#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES
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
  if [ "$OS" = "Darwin" ]; then
    sudo -v
    accept_xcode_license
    configure_firewall
  fi

  create_symlinks
  install_packages
  install_nvm
  post_install

  if [ "$OS" = "Darwin" ]; then
    install_npm_globals
    configure_bundler
    link_espanso
    link_claude_code
    configure_system
    install_mas_apps
  fi

  echo ""
  echo "=== Setup complete! ==="
  echo "Restart your shell: exec zsh"
}

main "$@"
