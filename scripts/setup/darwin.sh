#!/bin/bash

set -e

source "$DOTFILES/scripts/setup/common.sh"

# ====================
# Homebrew
# ====================
export HOMEBREW_NO_ASK=1

install_homebrew() {
  if ! command -v brew &>/dev/null; then
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
    ysmx/cooviewer
    jannis-baum/tap
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
  brew install ffmpeg
  brew install imagemagick
  brew install btop
  brew install fastfetch
  brew install uv
  brew install herdr
  brew install mise
  brew install pnpm
  brew install firebase-cli
  brew install vercel
  brew install cloudflare-wrangler
  brew install tailscale
  brew install yt-dlp
  brew install mpv
  brew install lua-language-server
  brew install tree-sitter-cli
  brew install tailspin
  brew install taplo
  brew install dockerfmt
  brew install glow
  brew install hf
  brew install yazi
  brew install hunk
  brew install gallery-dl
  brew install libpq
  brew install librsvg
  brew install mysql-client
  brew install scrcpy
  brew install jannis-baum/tap/vivify

  # adb
  brew install --cask android-platform-tools
  brew install --cask android-commandlinetools

  # Terraform
  brew install hashicorp/tap/terraform

  # Deploy tools
  brew install fujiwara/tap/lambroll
  brew install kayac/tap/ecspresso

  # Sentry
  brew install getsentry/tools/sentry-cli

  # RunPod
  brew install runpod/runpodctl/runpodctl

  # macism
  brew install macism

  # Stripe
  brew install stripe-cli

  # Supabase
  brew install supabase/tap/supabase || {
    brew uninstall --ignore-dependencies supabase 2>/dev/null || true
    brew install supabase/tap/supabase
  }

  # Gitea Actions runner
  brew install gitea-runner

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
  brew install --cask font-udev-gothic-nf

  # Terminal
  brew install --cask ghostty

  # Browser
  brew install --cask google-chrome
  brew install --cask google-chrome@beta
  brew install --cask tor-browser

  # Productivity
  brew install --cask google-drive
  brew install --cask slack
  brew install --cask discord
  brew install --cask telegram
  brew install --cask signal

  # AI
  brew install --cask claude

  # Creative
  brew install --cask adobe-creative-cloud

  # Development
  brew install --cask orbstack
  brew install --cask ngrok
  brew install --cask espanso

  # Utilities
  brew install --cask snapzy
  brew install --cask hammerspoon
  brew install --cask karabiner-elements
  brew install --cask keyboardcleantool
  brew install --cask the-unarchiver
  brew install --cask logi-options+
  brew install --cask ysmx/cooviewer/cooviewer

  # Privacy
  brew install --cask proton-pass
  brew install --cask mullvad-vpn
}

# ====================
# App Store
# ====================
install_mas_apps() {
  echo "Installing App Store apps..."

  brew install mas

  mas install 539883307 || true # LINE
  mas install 497799835 || true # Xcode
}

# ====================
# System Preferences
# ====================
configure_system() {
  echo "Configuring system preferences..."

  # User preferences are declared in .config/mise/config.toml
  mise bootstrap --only macos-defaults --yes

  # mise does not expand $HOME in defaults
  # Hammerspoon
  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

  # mise does not support sudo or system-wide domains
  # Lock Screen
  # ディスプレイスリープ (バッテリー): 30 分
  sudo pmset -b displaysleep 30
  # ディスプレイスリープ (電源アダプタ): 30 分
  sudo pmset -c displaysleep 30
  # パスワードヒントを表示: OFF
  sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
  # ロック時のメッセージ: 非表示
  sudo defaults delete /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null || true
  # ログイン画面: 名前とパスワード入力
  sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true
  # スリープ・再起動・シャットダウンボタンを表示
  sudo defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled -bool false
}

# ====================
# Tailscale
# ====================
start_tailscaled() {
  echo "Starting tailscaled..."
  sudo brew services start tailscale
}

# ====================
# LLM forward
# ====================
setup_llm_forward() {
  echo "Setting up LLM forward..."
  local label="com.yasainet.llm-forward"
  local plist="$HOME/Library/LaunchAgents/$label.plist"

  if [ "$(scutil --get LocalHostName | tr '[:upper:]' '[:lower:]')" = "macbook-pro-2023" ]; then
    echo "  [skip] this host serves llama-server itself"
    return
  fi

  mkdir -p "$HOME/Library/LaunchAgents"
  cp "$DOTFILES/.config/launchd/$label.plist" "$plist"
  launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$plist"
}

# ====================
# Firewall
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
# Bundler
# ====================
configure_bundler() {
  echo "Configuring bundler..."

  mkdir -p "$HOME/.bundle"
  [ -s "$HOME/.bundle/config" ] || printf -- "---\n" >"$HOME/.bundle/config"
  if ! grep -q "^BUNDLE_BUILD__MYSQL2:" "$HOME/.bundle/config"; then
    echo 'BUNDLE_BUILD__MYSQL2: "--with-mysql-config=/opt/homebrew/opt/mysql-client/bin/mysql_config --with-ldflags=-L/opt/homebrew/opt/zstd/lib"' >>"$HOME/.bundle/config"
  fi
}

# ====================
# npm globals
# ====================
install_npm_globals() {
  echo "Installing npm global packages..."

  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if ! command -v npm &>/dev/null; then
    echo "  [skip] npm not found"
    return
  fi

  npm install -g \
    google-analytics-cli \
    cf \
    @datadog/datadog-ci \
    @google/clasp \
    @involvex/youtube-music-cli
  npm install -g --allow-remote=all \
    @deepseek-ai/dsh@0.2.0-rc.2 \
    @deepseek-harness-tui/dsh-tui@0.14.0
  echo "  [done] npm globals setup complete"
}

# ====================
# Claude Code
# ====================
link_claude_code() {
  echo "Linking Claude Code config..."
  mkdir -p "$HOME/.claude"
  link "$DOTFILES/dot-claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  link "$DOTFILES/dot-claude/docs" "$HOME/.claude/docs"
  link "$DOTFILES/dot-claude/settings.json" "$HOME/.claude/settings.json"
  link "$DOTFILES/dot-claude/keybindings.json" "$HOME/.claude/keybindings.json"
  link "$DOTFILES/dot-claude/rules" "$HOME/.claude/rules"
  link_claude_code_skills
  link "$DOTFILES/dot-claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
}

link_claude_code_skills() {
  mkdir -p "$HOME/.claude/skills"
  local skill
  for skill in "$DOTFILES"/dot-claude/skills/*/; do
    [ -e "$skill" ] || continue
    link "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
  done
}

# ====================
# dsh
# ====================
link_dsh() {
  echo "Linking dsh config..."
  mkdir -p "$HOME/.dsh/profiles"
  link "$DOTFILES/dot-dsh/profiles/dsh-tui" "$HOME/.dsh/profiles/dsh-tui"
}

# ====================
# Manual setup
# ====================
#
# # iCloud
# System Settings -> Apple Account -> iCloud -> Drive -> Desktop & Documents Folder: On

# ====================
# Main (macOS)
# ====================
main() {
  sudo -v
  accept_xcode_license
  configure_firewall

  # shellcheck disable=SC2119
  create_symlinks
  install_homebrew
  install_cli_tools
  install_gui_apps
  install_nvm
  install_textlint
  setup_bat_theme
  install_herdr_plugins
  link_claude_code
  link_dsh

  start_tailscaled
  setup_llm_forward
  install_npm_globals
  configure_bundler
  link_espanso
  configure_system
  install_mas_apps
}

main "$@"
