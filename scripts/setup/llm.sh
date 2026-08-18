#!/bin/bash
#
# LLM host profile (Linux / NVIDIA GPU).
#

LLAMA_CPP_VER="b10472"

# ====================
# llama.cpp (CUDA build)
# ====================
build_llama_cpp() {
  if [ -x "$HOME/.local/bin/llama-server" ]; then
    echo "  [skip] llama-server already built"
    return
  fi

  command -v nvcc >/dev/null 2>&1 || sudo apt-get install -y nvidia-cuda-toolkit
  command -v cmake >/dev/null 2>&1 || sudo apt-get install -y cmake

  rm -rf "$HOME/llama.cpp-build"
  git clone -q --depth 1 -b "$LLAMA_CPP_VER" \
    https://github.com/ggml-org/llama.cpp "$HOME/llama.cpp-build"

  cmake -S "$HOME/llama.cpp-build" -B "$HOME/llama.cpp-build/build" \
    -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=OFF
  cmake --build "$HOME/llama.cpp-build/build" --target llama-server -j "$(nproc)"

  mkdir -p "$HOME/.local/bin"
  cp "$HOME/llama.cpp-build/build/bin/llama-server" "$HOME/.local/bin/"
  echo "  [build] llama-server ${LLAMA_CPP_VER} (CUDA)"
}

# ====================
# systemd user service
# ====================
link_llama_server_service() {
  echo "Installing llama-server systemd user service..."

  mkdir -p "$HOME/.config/systemd/user"
  ln -sfn "$DOTFILES/extras/systemd/llama-server.service" \
    "$HOME/.config/systemd/user/llama-server.service"

  systemctl --user daemon-reload
  loginctl enable-linger "$USER"
  echo "  [done] llama-server.service"
}

setup_profile() {
  echo "Configuring LLM host (Linux/CUDA)..."
  build_llama_cpp
  link_llama_server_service

  echo ""
  echo "  models: ./scripts/llm/fetch.sh で取得する"
}
