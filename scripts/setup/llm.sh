#!/bin/bash
#
# LLM host profile (macOS / Metal).
#

LLAMA_CPP_VER="b10472"

# ====================
# llama.cpp (Metal build)
# ====================
build_llama_cpp() {
  if [ -x "$HOME/.local/bin/llama-server" ]; then
    echo "  [skip] llama-server already built"
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

# ====================
# uv (Open WebUI 用)
# ====================
install_uv() {
  if command -v uv >/dev/null 2>&1; then
    echo "  [skip] uv already installed"
    return
  fi
  brew install uv
  echo "  [install] uv"
}

setup_profile() {
  echo "Configuring LLM host (macOS/Metal)..."
  build_llama_cpp
  install_uv

  echo ""
  echo "  models: ./scripts/llm/fetch.sh で取得する"
  echo "  serve: ./scripts/llm/serve.sh で起動する"
  echo "  expose: tailscale serve --bg --tcp=8080 tcp://127.0.0.1:8080 で tailnet へ公開する"
  echo "  webui: ./scripts/llm/webui.sh で起動する"
  echo "  webui expose: tailscale serve --bg --tcp=3000 tcp://127.0.0.1:3000 で tailnet へ公開する"
}
