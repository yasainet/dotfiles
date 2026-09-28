#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES
OS="$(uname -s)"

echo "=== Dotfiles Installer ==="
echo "Detected OS: $OS"

source "$DOTFILES/scripts/setup/common.sh"

case "$OS" in
Darwin)
  source "$DOTFILES/scripts/setup/darwin.sh"
  ;;
Linux)
  source "$DOTFILES/scripts/setup/linux.sh"
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
  install_textlint
  post_install
  link_claude_code
  link_pi

  if [ "$OS" = "Darwin" ]; then
    start_tailscaled
    install_npm_globals
    configure_bundler
    link_espanso
    setup_brave_policy
    configure_system
    install_mas_apps
  fi

  echo ""
  echo "=== Setup complete! ==="
  echo "Restart your shell: exec zsh"
}

main "$@"
