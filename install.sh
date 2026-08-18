#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES
OS="$(uname -s)"

DOTFILES_PROFILE="${DOTFILES_PROFILE:-full}"
export DOTFILES_PROFILE

case "$DOTFILES_PROFILE" in
full | llm) ;;
*)
  echo "Unknown DOTFILES_PROFILE: $DOTFILES_PROFILE (use full or llm)"
  exit 1
  ;;
esac

echo "=== Dotfiles Installer ==="
echo "Detected OS: $OS"
echo "Profile: $DOTFILES_PROFILE"

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

if [ "$DOTFILES_PROFILE" = "llm" ]; then
  if [ "$OS" != "Linux" ]; then
    echo "Profile llm is Linux only (NVIDIA GPU host)"
    exit 1
  fi
  source "$DOTFILES/scripts/setup/llm.sh"
fi

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

  if [ "$OS" = "Darwin" ]; then
    start_tailscaled
    install_npm_globals
    configure_bundler
    link_espanso
    link_claude_code
    link_pi
    configure_system
    install_mas_apps
  fi

  setup_profile

  echo ""
  echo "=== Setup complete! ==="
  echo "Restart your shell: exec zsh"
}

main "$@"
