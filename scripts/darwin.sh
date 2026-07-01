#!/bin/bash

# macOS-specific installation

# ====================
# Homebrew
# ====================
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "Homebrew already installed"
  fi
}

# `brew install` の対話プロンプト（新規依存追加時の y/n 確認など）を自動で y にする
brew() {
  if [ "$1" = "install" ]; then
    shift
    yes y 2>/dev/null | command brew install "$@"
  else
    command brew "$@"
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
  brew install glab
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
  brew install tmux
  brew install herdr
  brew install mise
  brew install pnpm
  brew install firebase-cli
  brew install tailscale
  brew install translate-shell
  brew install yt-dlp
  brew install lua-language-server
  brew install tree-sitter-cli
  brew install tailspin
  brew install taplo
  brew install glow
  brew install shuntaka9576/tap/chathist
  brew install modem-dev/tap/hunk
  brew install gallery-dl
  brew install git-filter-repo
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

  # Supabase (prefer tap version; uninstall core conflict if needed)
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

  # Claude Code CLI (native installer)
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
  brew install --cask font-sf-pro
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
# iCloud Downloads
# ====================
setup_icloud_downloads() {
  echo "Setting up iCloud Downloads..."

  local icloud_drive="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  local icloud_downloads="$icloud_drive/Downloads"
  local local_downloads="$HOME/Downloads"

  # Check if iCloud Drive exists
  if [[ ! -d "$icloud_drive" ]]; then
    echo "iCloud Drive not found. Please sign in to iCloud first."
    return 1
  fi

  # Skip if already a symlink
  if [[ -L "$local_downloads" ]]; then
    echo "~/Downloads is already a symlink. Skipping."
    return 0
  fi

  # Create iCloud Downloads folder if not exists
  if [[ ! -d "$icloud_downloads" ]]; then
    echo "Creating Downloads folder in iCloud Drive..."
    mkdir -p "$icloud_downloads"
  fi

  # Backup existing Downloads if not empty
  if [[ -d "$local_downloads" ]] && [[ -n "$(ls -A "$local_downloads" 2>/dev/null)" ]]; then
    echo "Backing up existing Downloads to ~/Downloads.local..."
    mv "$local_downloads" "$HOME/Downloads.local"
  else
    rm -rf "$local_downloads"
  fi

  # Create symlink
  ln -s "$icloud_downloads" "$local_downloads"
  echo "iCloud Downloads setup complete."
}

# ====================
# System Preferences
# ====================
configure_system() {
  echo "Configuring system preferences..."

  # Trackpad
  defaults write -g com.apple.trackpad.scaling -float 3.0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

  # Mouse
  defaults write -g com.apple.mouse.scaling -float 3.0
  defaults write -g com.apple.scrollwheel.scaling -float 1.0
  defaults write -g com.apple.swipescrolldirection -bool true

  # Appearance
  defaults write -g AppleInterfaceStyle -string "Dark"

  # Menu Bar
  defaults write -g _HIHideMenuBar -bool true

  # Keyboard
  defaults write NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write WebAutomaticSpellingCorrectionEnabled -bool false
  defaults write NSAutomaticCapitalizationEnabled -bool false
  defaults write NSAutomaticPeriodSubstitutionEnabled -bool false
  defaults write NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write -g KeyRepeat -int 2
  defaults write -g InitialKeyRepeat -int 15
  defaults write -g ApplePressAndHoldEnabled -bool false

  # Notification Center shortcut
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 163 "{ enabled = 1; value = { parameters = (65535, 53, 1048576); type = 'standard'; }; }"

  # Disable two-finger swipe from right edge
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

  # Dock
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock wvous-tl-corner -int 0
  defaults write com.apple.dock wvous-tl-modifier -int 0
  defaults write com.apple.dock wvous-tr-corner -int 0
  defaults write com.apple.dock wvous-tr-modifier -int 0
  defaults write com.apple.dock wvous-bl-corner -int 0
  defaults write com.apple.dock wvous-bl-modifier -int 0
  defaults write com.apple.dock wvous-br-corner -int 0
  defaults write com.apple.dock wvous-br-modifier -int 0

  # Finder
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.Finder AppleShowAllFiles -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true

  # Screenshots
  defaults write com.apple.screencapture location "$HOME/Downloads"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture show-thumbnail -bool true
  defaults write com.apple.screencapture captureHDR -bool false 

  # Restart affected apps
  killall Dock || true
  killall Finder || true
  killall SystemUIServer || true
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

  # Hunk's bundled review skill (resolved against the current brew opt path)
  if command -v hunk &>/dev/null; then
    ln -sfn "$(command brew --prefix hunk)/libexec/skills/hunk-review" "$HOME/.claude/skills/hunk-review"
  fi
}

# ====================
# npm globals
# ====================
install_npm_globals() {
  echo "Installing npm global packages..."

  # textlint config (Unsupported XDG)
  link "$DOTFILES/.config/textlint/.textlintrc.json" "$HOME/.textlintrc.json"

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if ! command -v npm &> /dev/null; then
    echo "  [skip] npm not found"
    return
  fi

  npm install -g \
    textlint \
    textlint-rule-ja-space-between-half-and-full-width \
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
