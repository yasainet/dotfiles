#!/bin/bash
#
# LLM host profile (Linux / NVIDIA GPU).
#
# base の linux.sh に上乗せして、llama-swap と CUDA ビルドの llama.cpp を
# systemd user service として常駐させる。CLI ツール類は linux.sh に任せ、
# ここでは host 固有のセットアップだけを担う。

LLAMA_SWAP_VER="v250"
LLAMA_CPP_VER="b10472"

# ====================
# llama-swap (prebuilt)
# ====================
install_llama_swap() {
  if [ -x "$HOME/.local/bin/llama-swap" ]; then
    echo "  [skip] llama-swap already installed"
    return
  fi

  mkdir -p "$HOME/.local/bin"
  curl -sL "https://github.com/mostlygeek/llama-swap/releases/download/${LLAMA_SWAP_VER}/llama-swap_${LLAMA_SWAP_VER#v}_linux_amd64.tar.gz" |
    tar -xz -C "$HOME/.local/bin" llama-swap
  chmod +x "$HOME/.local/bin/llama-swap"
  echo "  [install] llama-swap ${LLAMA_SWAP_VER}"
}

# ====================
# llama.cpp (CUDA build)
# ====================
# prebuilt の ubuntu バイナリは CUDA を含まないため自前でビルドする。
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
link_llama_swap_service() {
  echo "Installing llama-swap systemd user service..."

  mkdir -p "$HOME/.config/systemd/user"
  ln -sfn "$DOTFILES/extras/systemd/llama-swap.service" \
    "$HOME/.config/systemd/user/llama-swap.service"

  systemctl --user daemon-reload
  # ログアウト後も常駐させる
  loginctl enable-linger "$USER"
  systemctl --user enable --now llama-swap.service
  echo "  [done] llama-swap.service"
}

setup_profile() {
  echo "Configuring LLM host (Linux/CUDA)..."
  install_llama_swap
  build_llama_cpp
  link_llama_swap_service

  echo ""
  echo "  models: ./scripts/llm/fetch.sh で取得する"
}

# ====================
# Manual setup
# ====================
#
# 1. NVIDIA ドライバと nvidia-container-toolkit は別途導入済みであること
# 2. tailscale up (リモートから LLM_URL で到達するため)
# 3. ./scripts/llm/fetch.sh でモデルを取得
