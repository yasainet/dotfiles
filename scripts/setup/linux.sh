#!/bin/bash

# ====================
# Symlinks
# ====================
SKIP_LINKS=(
  # macOS-only apps
  hammerspoon # Hammerspoon
  karabiner   # Karabiner-Elements
  snapzy      # Snapzy (screenshot app)

  # GUI apps: no display server here
  ghostty # config is macos-*/cmd+ specific anyway
  espanso # needs an X11/Wayland session

  # macOS-only paths: /opt/homebrew, /Users/yasainet/models (see llm.sh)
  llama-swap
)

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools..."

  sudo true

  sudo apt update

  sudo apt install -y locales
  sudo locale-gen en_US.UTF-8

  sudo apt install -y curl wget unzip zsh software-properties-common
  sudo apt install -y bat btop fd-find fzf ripgrep tree jq
  sudo apt install -y nvtop
  sudo apt install -y trash-cli
  sudo apt install -y zsh-autosuggestions zsh-syntax-highlighting

  # Neovim
  if ! command -v nvim &> /dev/null || [[ "$(nvim --version | head -1)" < "NVIM v0.10" ]]; then
    echo "Installing Neovim from PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
  fi
  sudo apt install -y ffmpeg
  sudo apt install -y xclip
}

# ====================
# ghq (no apt package on Ubuntu)
# ====================
GHQ_VERSION="v1.10.1"

install_ghq() {
  if command -v ghq &> /dev/null; then
    echo "ghq already installed"
    return
  fi

  local arch
  case "$(uname -m)" in
    x86_64)  arch="amd64" ;;
    aarch64) arch="arm64" ;;
    *)
      echo "  [skip] ghq (unsupported arch: $(uname -m))"
      return
      ;;
  esac

  echo "Installing ghq $GHQ_VERSION..."

  local name="ghq_linux_${arch}"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/ghq.zip" \
    "https://github.com/x-motemen/ghq/releases/download/${GHQ_VERSION}/${name}.zip"
  unzip -q "$tmp/ghq.zip" -d "$tmp"

  mkdir -p "$HOME/.local/bin"
  install -m 755 "$tmp/$name/ghq" "$HOME/.local/bin/ghq"
  rm -rf "$tmp"

  echo "  [done] ghq -> $HOME/.local/bin/ghq"
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
# Zsh Plugins (git clone fallback)
# ====================
install_zsh_plugins() {
  echo "Installing Zsh plugins..."

  local plugin_dir="$HOME/.local/share/zsh/plugins"
  mkdir -p "$plugin_dir"

  # Pure prompt
  if [ ! -d "$plugin_dir/pure" ]; then
    git clone "https://github.com/sindresorhus/pure.git" "$plugin_dir/pure"
    echo "  [done] pure"
  else
    echo "  [skip] pure (already installed)"
  fi

  # zsh-completions
  if [ ! -d "$plugin_dir/zsh-completions" ]; then
    git clone "https://github.com/zsh-users/zsh-completions.git" "$plugin_dir/zsh-completions"
    echo "  [done] zsh-completions"
  else
    echo "  [skip] zsh-completions (already installed)"
  fi
}

# ====================
# Main (Linux)
# ====================
install_packages() {
  install_cli_tools
  install_ghq
  set_default_shell
  install_zsh_plugins
}
