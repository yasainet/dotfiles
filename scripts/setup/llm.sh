#!/bin/bash

# ====================
# LLM host profile
# ====================
# DOTFILES_PROFILE=llm のときに install.sh が読む。macOS 専用。
# common.sh と darwin.sh の後に読まれ、そこで定義された関数を上書きする。
#
# darwin.sh とパッケージが重複するが、条件分岐で削るより一覧を並べる方が読みやすい。
# 入れる物を変えたい時はこのファイルのリストだけ見ればよい。
#
# 運用手順は docs/llm-host.md を参照。

# ====================
# Symlinks
# ====================
# GUI アプリを入れないため、その設定もリンクしない。
SKIP_LINKS+=(
  ghostty     # Ghostty (ssh 越しに使うので不要)
  espanso     # Espanso
  hammerspoon # Hammerspoon
  karabiner   # Karabiner-Elements
  snapzy      # Snapzy (screenshot app)
)

# llama-swap のバージョン。更新時はここだけ変える。
LLAMA_SWAP_VER="v222"

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools (llm profile)..."

  brew tap anomalyco/tap
  brew trust anomalyco/tap || true

  brew install git
  brew install git-lfs
  brew install gh
  brew install lazygit
  brew install neovim
  brew install bat
  brew install fzf
  brew install ghq
  brew install ripgrep
  brew install fd
  brew install tree
  brew install jq
  brew install yq
  brew install btop
  brew install fastfetch
  brew install herdr
  brew install yazi
  brew install glow
  brew install tailspin
  brew install direnv
  brew install tailscale
  brew install hunk

  # opencode
  brew install anomalyco/tap/opencode

  # Zsh plugins
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install zsh-completions
  brew install pure

  # Claude Code CLI
  if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  # 推論エンジンとモデル取得
  brew install llama.cpp
  brew install hf
  install_llama_swap
}

install_llama_swap() {
  if [ -x "$HOME/.local/bin/llama-swap" ]; then
    echo "  [skip] llama-swap already installed"
    return
  fi

  mkdir -p "$HOME/.local/bin"
  curl -sL "https://github.com/mostlygeek/llama-swap/releases/download/${LLAMA_SWAP_VER}/llama-swap_${LLAMA_SWAP_VER#v}_darwin_arm64.tar.gz" \
    | tar -xz -C "$HOME/.local/bin" llama-swap
  chmod +x "$HOME/.local/bin/llama-swap"
  echo "  [install] llama-swap ${LLAMA_SWAP_VER}"
}

# ====================
# Skipped on this profile
# ====================
install_gui_apps() {
  echo "  [skip] GUI apps (llm profile)"
}

install_mas_apps() {
  echo "  [skip] App Store apps (llm profile)"
}

install_npm_globals() {
  echo "  [skip] npm globals (llm profile)"
}

link_espanso() {
  echo "  [skip] espanso (llm profile)"
}

# ====================
# LLM host
# ====================
# llama-swap を常駐させる。
# LaunchDaemon ではなく LaunchAgent なのは、Metal がユーザーセッションを要るため。
# GUI にログインするまで起動しない。再起動後の復旧は docs/llm/setup.md を参照。
link_llama_swap_agent() {
  echo "Installing llama-swap LaunchAgent..."

  local plist="$HOME/Library/LaunchAgents/com.yasainet.llama-swap.plist"
  mkdir -p "$HOME/Library/LaunchAgents"

  # $HOME を展開して書き出す。plist はチルダ展開しない。
  sed -e "s|@HOME@|$HOME|g" \
    "$DOTFILES/extras/launchd/com.yasainet.llama-swap.plist" > "$plist"

  launchctl bootout "gui/$(id -u)/com.yasainet.llama-swap" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$plist"
  echo "  [done] com.yasainet.llama-swap"
}

# 常時稼働させるための電源とリモートアクセス設定。
setup_profile() {
  echo "Configuring LLM host..."

  # 電源アダプタ接続時はスリープしない
  sudo pmset -c sleep 0
  # 蓋を閉じてもスリープしない (clamshell 運用)
  sudo pmset -c disablesleep 1
  # ディスプレイは 10 分で消す (画面は使わない)
  sudo pmset -c displaysleep 10
  # 停電復帰後に自動で起動する
  sudo pmset -c autorestart 1
  # スリープ後もネットワークからの接続で起きる
  sudo pmset -c womp 1

  # リモートログイン (ssh) を有効化。
  # ターミナルにフルディスク アクセスが無いと失敗するため、その場合は手動で入れる。
  if ! sudo systemsetup -setremotelogin on 2>/dev/null; then
    echo "  [warn] systemsetup -setremotelogin に失敗した"
    echo "         System Settings -> General -> Sharing -> Remote Login を手動で ON にすること"
  fi

  link_llama_swap_agent
}

# ====================
# Manual setup
# ====================
#
# 1. マシン名を MacBook-Pro-2023 にする (README の Rename machine を参照)
# 2. tailscale up
# 3. 画面共有: System Settings -> General -> Sharing -> Screen Sharing
#    再起動後、GUI にログインしないと llama-swap が上がらないため
# 4. ./scripts/llm/fetch.sh でモデルを取得
# 5. DeepSeek-V4-Flash は手動 (docs/llm-host.md を参照)
