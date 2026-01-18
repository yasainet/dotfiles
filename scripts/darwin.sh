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

# ====================
# CLI Tools
# ====================
install_cli_tools() {
  echo "Installing CLI tools..."

  brew install git
  brew install gh
  brew install glab
  brew install neovim
  brew install starship
  brew install bat
  brew install fzf
  brew install ripgrep
  brew install tree
  brew install jq
  brew install ffmpeg
  brew install glances
  brew install uv
  brew install yazi

  # Git Credential Manager
  brew tap microsoft/git
  brew install --cask git-credential-manager-core

  # macism
  brew tap laishulu/homebrew
  brew install macism

  # Stripe
  brew install stripe/stripe-cli/stripe

  # Supabase
  brew install supabase/tap/supabase

  # Google Cloud SDK
  brew install --cask google-cloud-sdk

  # CloudFlare
  brew install cloudflared

  # AWS CLI
  brew install awscli
}

# ====================
# GUI Applications
# ====================
install_gui_apps() {
  echo "Installing GUI applications..."

  # Fonts
  brew install --cask font-plemol-jp-nf

  # Terminal & Editor
  brew install --cask ghostty
  brew install --cask zed

  # Browser
  brew install --cask google-chrome
  brew install --cask google-chrome@dev
  brew install --cask tor-browser

  # Productivity
  brew install --cask google-drive
  brew install --cask slack
  brew install --cask discord
  brew install --cask telegram
  brew install --cask signal
  brew install --cask deepl

  # Development
  brew install --cask orbstack

  # Utilities
  brew install --cask karabiner-elements
  brew install --cask rectangle
  brew install --cask cleanshot
  brew install --cask keyboardcleantool
  brew install --cask the-unarchiver
  brew install --cask iina
  # brew install --cask logi-options+

  # Privacy
  brew install --cask protonvpn
  brew install --cask transmission
}

# ====================
# App Store
# ====================
install_mas_apps() {
  echo "Installing App Store apps..."

  brew install mas

  mas install 539883307  # LINE
  mas install 497799835  # Xcode
  mas install 967805235  # Paste
}

# ====================
# Java
# ====================
install_java() {
  echo "Installing Java..."
  brew install openjdk
  sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
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

  # Restart affected apps
  killall Dock
  killall Finder
}

# ====================
# Main (macOS)
# ====================
install_packages() {
  install_homebrew
  install_cli_tools
  install_gui_apps
  install_mas_apps
  install_java
}
