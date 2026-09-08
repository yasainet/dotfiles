#!/bin/bash

# ====================
# Symlinks
# ====================
# shellcheck disable=SC2034
SKIP_LINKS=(
  # macOS-only apps
  hammerspoon # Hammerspoon
  karabiner   # Karabiner-Elements
  snapzy      # Snapzy (screenshot app)

  # GUI apps: no display server here
  ghostty # config is macos-*/cmd+ specific anyway
  espanso # needs an X11/Wayland session
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
  sudo apt install -y bat btop fd-find fzf ripgrep tree jq gh
  sudo apt install -y make zip binutils # vivify build
  sudo apt install -y nvtop
  sudo apt install -y trash-cli
  sudo apt install -y zsh-autosuggestions zsh-syntax-highlighting

  # Neovim
  if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1)" < "NVIM v0.10" ]]; then
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
  if command -v ghq &>/dev/null; then
    echo "ghq already installed"
    return
  fi

  local arch
  case "$(uname -m)" in
  x86_64) arch="amd64" ;;
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
# fzf (apt version is too old for --highlight-line; keep apt one for its shell scripts)
# ====================
FZF_VERSION="v0.74.3"
FZF_MIN_VERSION="0.53.0"

install_fzf() {
  if command -v fzf &>/dev/null; then
    local current
    current="$(fzf --version | awk '{print $1}')"
    if [[ "$(printf '%s\n%s\n' "$FZF_MIN_VERSION" "$current" | sort -V | head -1)" == "$FZF_MIN_VERSION" ]]; then
      echo "fzf $current already installed"
      return
    fi
  fi

  local arch
  case "$(uname -m)" in
  x86_64) arch="amd64" ;;
  aarch64) arch="arm64" ;;
  *)
    echo "  [skip] fzf (unsupported arch: $(uname -m))"
    return
    ;;
  esac

  echo "Installing fzf $FZF_VERSION..."

  local tmp
  tmp="$(mktemp -d)"
  if ! curl -fsSL -o "$tmp/fzf.tar.gz" \
    "https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION#v}-linux_${arch}.tar.gz" ||
    ! tar -xzf "$tmp/fzf.tar.gz" -C "$tmp"; then
    echo "  [fail] fzf download/extract failed"
    rm -rf "$tmp"
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  install -m 755 "$tmp/fzf" "$HOME/.local/bin/fzf"
  rm -rf "$tmp"

  echo "  [done] fzf -> $HOME/.local/bin/fzf"
}

# ====================
# GitHub release binaries -> ~/.local/bin
# ====================
# Prints x86_64 or aarch64. Prints nothing (and returns 1) on other arches.
linux_arch() {
  case "$(uname -m)" in
  x86_64 | aarch64) uname -m ;;
  *) return 1 ;;
  esac
}

# Downloads $url to $tmp/<basename>. Prints [fail] and returns 1 on error.
fetch_release() {
  local name="$1" url="$2" tmp="$3"
  if ! curl -fsSL -o "$tmp/$(basename "$url")" "$url"; then
    echo "  [fail] $name download failed: $url"
    return 1
  fi
}

install_local_bin() {
  mkdir -p "$HOME/.local/bin"
  install -m 755 "$1" "$HOME/.local/bin/$2"
  echo "  [done] $2 -> $HOME/.local/bin/$2"
}

# ====================
# herdr
# ====================
HERDR_VERSION="v0.9.0"

install_herdr() {
  if command -v herdr &>/dev/null; then
    echo "herdr already installed"
    return
  fi

  local arch
  if ! arch="$(linux_arch)"; then
    echo "  [skip] herdr (unsupported arch: $(uname -m))"
    return
  fi

  echo "Installing herdr $HERDR_VERSION..."

  local tmp
  tmp="$(mktemp -d)"
  if ! fetch_release herdr \
    "https://github.com/herdrdev/herdr/releases/download/${HERDR_VERSION}/herdr-linux-${arch}" "$tmp"; then
    rm -rf "$tmp"
    return 1
  fi

  install_local_bin "$tmp/herdr-linux-${arch}" herdr
  rm -rf "$tmp"
}

# ====================
# lazygit
# ====================
LAZYGIT_VERSION="v0.65.0"

install_lazygit() {
  if command -v lazygit &>/dev/null; then
    echo "lazygit already installed"
    return
  fi

  local arch
  if ! arch="$(linux_arch)"; then
    echo "  [skip] lazygit (unsupported arch: $(uname -m))"
    return
  fi
  [[ "$arch" == "aarch64" ]] && arch="arm64"

  echo "Installing lazygit $LAZYGIT_VERSION..."

  local name="lazygit_${LAZYGIT_VERSION#v}_linux_${arch}"
  local tmp
  tmp="$(mktemp -d)"
  if ! fetch_release lazygit \
    "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/${name}.tar.gz" "$tmp" ||
    ! tar -xzf "$tmp/${name}.tar.gz" -C "$tmp" lazygit; then
    echo "  [fail] lazygit extract failed"
    rm -rf "$tmp"
    return 1
  fi

  install_local_bin "$tmp/lazygit" lazygit
  rm -rf "$tmp"
}

# ====================
# hunk
# ====================
HUNK_VERSION="v0.21.1"

install_hunk() {
  if command -v hunk &>/dev/null; then
    echo "hunk already installed"
    return
  fi

  local arch
  if ! arch="$(linux_arch)"; then
    echo "  [skip] hunk (unsupported arch: $(uname -m))"
    return
  fi
  [[ "$arch" == "x86_64" ]] && arch="x64"
  [[ "$arch" == "aarch64" ]] && arch="arm64"

  echo "Installing hunk $HUNK_VERSION..."

  local name="hunkdiff-linux-${arch}"
  local tmp
  tmp="$(mktemp -d)"
  if ! fetch_release hunk \
    "https://github.com/modem-dev/hunk/releases/download/${HUNK_VERSION}/${name}.tar.gz" "$tmp" ||
    ! tar -xzf "$tmp/${name}.tar.gz" -C "$tmp" "${name}/hunk"; then
    echo "  [fail] hunk extract failed"
    rm -rf "$tmp"
    return 1
  fi

  install_local_bin "$tmp/${name}/hunk" hunk
  rm -rf "$tmp"
}

# ====================
# yazi
# ====================
YAZI_VERSION="v26.9.1"

install_yazi() {
  if command -v yazi &>/dev/null; then
    echo "yazi already installed"
    return
  fi

  local arch
  if ! arch="$(linux_arch)"; then
    echo "  [skip] yazi (unsupported arch: $(uname -m))"
    return
  fi

  echo "Installing yazi $YAZI_VERSION..."

  local name="yazi-${arch}-unknown-linux-gnu"
  local tmp
  tmp="$(mktemp -d)"
  if ! fetch_release yazi \
    "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/${name}.zip" "$tmp" ||
    ! unzip -q "$tmp/${name}.zip" "${name}/yazi" "${name}/ya" -d "$tmp"; then
    echo "  [fail] yazi extract failed"
    rm -rf "$tmp"
    return 1
  fi

  install_local_bin "$tmp/${name}/yazi" yazi
  install_local_bin "$tmp/${name}/ya" ya
  rm -rf "$tmp"
}

# ====================
# vivify (Linux release is x86_64 only; build from source with nvm's node)
# ====================
VIVIFY_VERSION="v0.14.0"

install_vivify() {
  if command -v viv &>/dev/null; then
    echo "vivify already installed"
    return
  fi

  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if ! command -v node &>/dev/null || ! command -v corepack &>/dev/null; then
    echo "  [skip] vivify (node/corepack not found; install nvm first)"
    return
  fi

  echo "Installing vivify $VIVIFY_VERSION (building from source)..."

  local tmp
  tmp="$(mktemp -d)"
  if ! git -c advice.detachedHead=false clone -q --depth 1 -b "$VIVIFY_VERSION" \
    https://github.com/jannis-baum/vivify.git "$tmp/vivify"; then
    echo "  [fail] vivify clone failed"
    rm -rf "$tmp"
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  if ! (
    cd "$tmp/vivify" &&
      corepack yarn install --frozen-lockfile &&
      ./configure "$HOME/.local/bin" &&
      VIV_VERSION="$VIVIFY_VERSION" make linux &&
      make install
  ); then
    echo "  [fail] vivify build failed"
    rm -rf "$tmp"
    return 1
  fi
  rm -rf "$tmp"

  echo "  [done] viv -> $HOME/.local/bin/viv"
}

# ====================
# fd -> fdfind (Debian renames it; scripts call fd)
# ====================
link_fd() {
  if command -v fd &>/dev/null; then
    echo "fd already available"
    return
  fi
  if ! command -v fdfind &>/dev/null; then
    echo "  [skip] fd (fdfind not found)"
    return
  fi

  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  echo "  [done] fd -> $(command -v fdfind)"
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
  install_fzf
  install_herdr
  install_lazygit
  install_hunk
  install_yazi
  install_vivify
  link_fd
  set_default_shell
  install_zsh_plugins
}
