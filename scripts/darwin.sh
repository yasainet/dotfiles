#!/bin/bash

# ====================
# Homebrew
# ====================
export HOMEBREW_NO_ASK=1

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "Homebrew already installed"
  fi
}

# ====================
# CLI Tools
# ====================
trust_third_party_taps() {
  echo "Trusting third-party Homebrew taps..."
  local taps=(
    hashicorp/tap
    fujiwara/tap
    kayac/tap
    getsentry/tools
    runpod/runpodctl
    anomalyco/tap
    microsoft/git
    laishulu/homebrew
    supabase/tap
    shuntaka9576/tap
  )
  for tap in "${taps[@]}"; do
    brew tap "$tap"
    brew trust "$tap" || true
  done
}

install_cli_tools() {
  echo "Installing CLI tools..."

  trust_third_party_taps

  brew install git
  brew install git-lfs
  brew install gh
  brew install tea
  brew install neovim
  brew install bat
  brew install fzf
  brew install ghq
  brew install ripgrep
  brew install fd
  brew install tree
  brew install jq
  brew install yq
  brew install ffmpeg
  brew install imagemagick
  brew install btop
  brew install fastfetch
  brew install uv
  brew install herdr
  brew install mise
  brew install pnpm
  brew install firebase-cli
  brew install tailscale
  brew install yt-dlp
  brew install lua-language-server
  brew install tree-sitter-cli
  brew install tailspin
  brew install taplo
  brew install glow
  brew install modem-dev/tap/hunk
  brew install gallery-dl
  brew install libpq
  brew install librsvg

  # Terraform
  brew install hashicorp/tap/terraform

  # Deploy tools
  brew install fujiwara/tap/lambroll
  brew install kayac/tap/ecspresso

  # Sentry
  brew install getsentry/tools/sentry-cli

  # RunPod
  brew install runpod/runpodctl/runpodctl

  # opencode
  brew install anomalyco/tap/opencode

  # Git Credential Manager
  brew tap microsoft/git
  brew install --cask git-credential-manager

  # macism
  brew tap laishulu/homebrew
  brew install macism

  # Stripe
  brew install stripe-cli

  # Supabase
  brew install supabase/tap/supabase || {
    brew uninstall --ignore-dependencies supabase 2>/dev/null || true
    brew install supabase/tap/supabase
  }

  # Google Cloud SDK
  brew install --cask gcloud-cli

  # CloudFlare
  brew install cloudflared

  # AWS CLI
  brew install awscli

  # direnv
  brew install direnv

  # Zsh plugins
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install zsh-completions
  brew install pure

  # Local LLM
  brew install llama.cpp
  brew install hf

  if ! command -v llama-swap &>/dev/null; then
    LLAMA_SWAP_VER="v222"
    mkdir -p "$HOME/.local/bin"
    curl -sL "https://github.com/mostlygeek/llama-swap/releases/download/${LLAMA_SWAP_VER}/llama-swap_${LLAMA_SWAP_VER#v}_darwin_arm64.tar.gz" \
      | tar -xz -C "$HOME/.local/bin" llama-swap
    chmod +x "$HOME/.local/bin/llama-swap"
  fi

  # Claude Code CLI
  if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

# ====================
# GUI Applications
# ====================
install_gui_apps() {
  echo "Installing GUI applications..."

  # Fonts
  brew install --cask font-plemol-jp-nf
  brew install --cask font-sf-mono

  # Terminal
  brew install --cask ghostty

  # Browser
  brew install --cask google-chrome
  brew install --cask brave-browser
  brew install --cask tor-browser

  # Productivity
  brew install --cask google-drive
  brew install --cask slack
  brew install --cask discord
  brew install --cask telegram
  brew install --cask signal

  # Development
  brew install --cask orbstack
  brew install --cask ngrok
  brew install --cask espanso

  # Utilities
  brew install --cask karabiner-elements
  brew install --cask keyboardcleantool
  brew install --cask the-unarchiver
  brew install --cask logi-options+

  # Privacy
  brew install --cask protonvpn
}

# ====================
# App Store
# ====================
install_mas_apps() {
  echo "Installing App Store apps..."

  brew install mas

  mas install 539883307 || true  # LINE
  mas install 497799835 || true  # Xcode
}

# ====================
# System Preferences
# ====================
configure_system() {
  echo "Configuring system preferences..."

  # Trackpad
  # カーソル移動速度 (最大 3.0)
  defaults write -g com.apple.trackpad.scaling -float 3.0
  # 内蔵: 三本指ドラッグ
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  # Bluetooth: 三本指ドラッグ
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
  # 内蔵: タップでクリック
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  # Bluetooth: タップでクリック
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

  # Mouse
  # マウスカーソル移動速度 (最大 3.0)
  defaults write -g com.apple.mouse.scaling -float 3.0
  # スクロールホイール速度
  defaults write -g com.apple.scrollwheel.scaling -float 1.0
  # ナチュラルスクロール ON
  defaults write -g com.apple.swipescrolldirection -bool true

  # Appearance
  # ダークモード固定
  defaults write -g AppleInterfaceStyle -string "Dark"

  # Keyboard
  # キーリピート速度
  defaults write -g KeyRepeat -int 2
  # リピート開始までの遅延
  defaults write -g InitialKeyRepeat -int 15
  # 長押しアクセント入力を無効化しキーリピートを優先
  defaults write -g ApplePressAndHoldEnabled -bool false

  # plutil
  killall cfprefsd 2>/dev/null || true

  # Notification Center
  plutil -replace AppleSymbolicHotKeys.163 \
    -json '{"enabled":true,"value":{"parameters":[65535,53,1048576],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist

  # Screenshot hotkeys: swap file/clipboard defaults
  #   Cmd+Shift+3/4       → クリップボード
  #   Ctrl+Cmd+Shift+3/4  → ファイル
  # 画面全体 → ファイル: Ctrl+Cmd+Shift+3
  plutil -replace AppleSymbolicHotKeys.28 \
    -json '{"enabled":true,"value":{"parameters":[51,20,1441792],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist
  # 画面全体 → クリップボード: Cmd+Shift+3
  plutil -replace AppleSymbolicHotKeys.29 \
    -json '{"enabled":true,"value":{"parameters":[51,20,1179648],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist
  # 範囲選択 → ファイル: Ctrl+Cmd+Shift+4
  plutil -replace AppleSymbolicHotKeys.30 \
    -json '{"enabled":true,"value":{"parameters":[52,21,1441792],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist
  # 範囲選択 → クリップボード: Cmd+Shift+4
  plutil -replace AppleSymbolicHotKeys.31 \
    -json '{"enabled":true,"value":{"parameters":[52,21,1179648],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist

  # Input Source
  #   60: Select previous input source (Ctrl+Space)
  #   61: Select next input source (Ctrl+Opt+Space)
  plutil -replace AppleSymbolicHotKeys.60 \
    -json '{"enabled":false,"value":{"parameters":[32,49,262144],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist
  plutil -replace AppleSymbolicHotKeys.61 \
    -json '{"enabled":false,"value":{"parameters":[32,49,786432],"type":"standard"}}' \
    ~/Library/Preferences/com.apple.symbolichotkeys.plist

  # Focus navigation
  for id in 15 16 17 18 19 20 21 22 23 24 25 26; do
    plutil -replace "AppleSymbolicHotKeys.$id" \
      -json '{"enabled":false}' \
      ~/Library/Preferences/com.apple.symbolichotkeys.plist
  done

  killall cfprefsd 2>/dev/null || true
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

  # Disable two-finger swipe from right edge
  # 内蔵: 右端 2 本指スワイプで通知センターを開くジェスチャー OFF
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
  # Bluetooth: 同上
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

  # Dock
  # Dock の常駐アプリを空に
  defaults write com.apple.dock persistent-apps -array
  # Dock アイコンサイズ 最小 (16px)
  defaults write com.apple.dock tilesize -int 16
  # マウスオーバー時の拡大 OFF
  defaults write com.apple.dock magnification -bool false
  # Dock 自動非表示 ON
  defaults write com.apple.dock autohide -bool true
  # Dock 位置 右
  defaults write com.apple.dock orientation -string "right"
  # 最近使ったアプリ OFF
  defaults write com.apple.dock show-recents -bool false
  # タイトルバーダブルクリックでウィンドウを画面いっぱいに広げる
  defaults write -g AppleActionOnDoubleClick -string "Fill"
  # ホットコーナー 左上 無効化
  defaults write com.apple.dock wvous-tl-corner -int 0
  # 左上 修飾キー無し
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # 右上 無効化
  defaults write com.apple.dock wvous-tr-corner -int 0
  # 右上 修飾キー無し
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # 左下 無効化
  defaults write com.apple.dock wvous-bl-corner -int 0
  # 左下 修飾キー無し
  defaults write com.apple.dock wvous-bl-modifier -int 0
  # 右下 無効化
  defaults write com.apple.dock wvous-br-corner -int 0
  # 右下 修飾キー無し
  defaults write com.apple.dock wvous-br-modifier -int 0

  # Finder
  # 全ての拡張子を表示
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # 隠しファイルを表示
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # パスバーを表示
  defaults write com.apple.finder ShowPathbar -bool true
  # ステータスバーを表示
  defaults write com.apple.finder ShowStatusBar -bool true

  # Screenshots
  # 保存先を Downloads に
  defaults write com.apple.screencapture location "$HOME/Downloads"
  # フォーマットを PNG に
  defaults write com.apple.screencapture type -string "png"
  # 撮影後のフローティングサムネイル表示
  defaults write com.apple.screencapture show-thumbnail -bool true
  # HDR キャプチャ OFF (SDR で保存)
  defaults write com.apple.screencapture captureHDR -bool false

  # Restart affected apps
  killall Dock || true
  killall Finder || true
  killall SystemUIServer || true
}

# ====================
# Firewall (Application Firewall)
# ====================
configure_firewall() {
  echo "Enabling Application Firewall..."
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
}

# ====================
# Xcode license
# ====================
accept_xcode_license() {
  echo "Accepting Xcode license..."
  sudo xcodebuild -license accept 2>/dev/null || true
}

# ====================
# Espanso
# ====================
link_espanso() {
  echo "Linking espanso config..."
  link "$DOTFILES/.config/espanso" "$HOME/Library/Application Support/espanso"
}

# ====================
# Claude Code
# ====================
link_claude_code() {
  echo "Linking Claude Code config..."
  mkdir -p "$HOME/.claude"
  link "$DOTFILES/dot-claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  link "$DOTFILES/dot-claude/settings.json" "$HOME/.claude/settings.json"
  link "$DOTFILES/dot-claude/rules" "$HOME/.claude/rules"
  link "$DOTFILES/dot-claude/skills" "$HOME/.claude/skills"
  link "$DOTFILES/dot-claude/docs" "$HOME/.claude/docs"
  link "$DOTFILES/dot-claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

  # hunk
  if command -v hunk &>/dev/null; then
    ln -sfn "$(command brew --prefix hunk)/libexec/skills/hunk-review" "$HOME/.claude/skills/hunk-review"
  fi
}

# ====================
# npm globals
# ====================
install_npm_globals() {
  echo "Installing npm global packages..."

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if ! command -v npm &> /dev/null; then
    echo "  [skip] npm not found"
    return
  fi

  npm install -g \
    google-analytics-cli \
    vercel \
    wrangler \
    @datadog/datadog-ci \
    @google/clasp
  echo "  [done] npm globals setup complete"
}

# ====================
# Main (macOS)
# ====================
install_packages() {
  install_homebrew
  install_cli_tools
  install_gui_apps
}
