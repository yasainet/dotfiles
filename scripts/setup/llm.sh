#!/bin/bash
#
# LLM host profile (macOS / Metal).
#

LLAMA_CPP_VER="b10698"

# ====================
# CLI tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools (llm profile)..."

  brew install git
  brew install gh
  brew install lazygit
  brew install neovim
  brew install tree-sitter-cli
  brew install lua-language-server
  brew install ripgrep
  brew install fd
  brew install fzf
  brew install bat
  brew install ghq
  brew install jq
  brew install yq
  brew install btop
  brew install fastfetch
  brew install herdr
  brew install hunk
  brew install yazi
  brew install uv
  brew install tailscale
  brew install direnv
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install zsh-completions
  brew install pure
}

install_gui_apps() {
  echo "  [skip] GUI apps (llm profile)"
}

# ====================
# llama.cpp (Metal build)
# ====================
build_llama_cpp() {
  if [ -x "$HOME/.local/bin/llama-server" ] \
    && "$HOME/.local/bin/llama-server" --version 2>&1 | grep -q "$LLAMA_CPP_VER"; then
    echo "  [skip] llama-server ${LLAMA_CPP_VER} already built"
    return
  fi

  command -v cmake >/dev/null 2>&1 || brew install cmake

  rm -rf "$HOME/llama.cpp-build"
  git clone -q --depth 1 -b "$LLAMA_CPP_VER" \
    https://github.com/ggml-org/llama.cpp "$HOME/llama.cpp-build"

  cmake -S "$HOME/llama.cpp-build" -B "$HOME/llama.cpp-build/build" \
    -DGGML_METAL=ON -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=OFF
  cmake --build "$HOME/llama.cpp-build/build" --target llama-server -j "$(sysctl -n hw.ncpu)"

  mkdir -p "$HOME/.local/bin"
  cp "$HOME/llama.cpp-build/build/bin/llama-server" "$HOME/.local/bin/"
  echo "  [build] llama-server ${LLAMA_CPP_VER} (Metal)"
}

setup_profile() {
  echo "Configuring LLM host (macOS/Metal)..."
  build_llama_cpp

  echo ""
  echo "  models: ./scripts/llm/fetch.sh で取得する"
  echo "  serve: darkbloom を停止してから ./scripts/llm/serve.sh で起動する"
  echo "  expose: tailscale serve --bg --tcp=8080 tcp://127.0.0.1:8080 で tailnet へ公開する"
}
