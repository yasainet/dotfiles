#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES
OS="$(uname -s)"
export OS

echo "=== Dotfiles Installer ==="
echo "Detected OS: $OS"

case "$OS" in
Darwin)
  bash "$DOTFILES/scripts/setup/darwin.sh"
  ;;
Linux)
  bash "$DOTFILES/scripts/setup/linux.sh"
  ;;
*)
  echo "Unsupported OS: $OS"
  exit 1
  ;;
esac

echo ""
echo "=== Setup complete! ==="
echo "Restart your shell: exec zsh"
