#!/bin/bash

echo "Set up is starting..."

# Keyboard
defaults write -g ApplePressAndHoldEnabled -bool false

# Dcok
defaults write com.apple.dock persistent-apps -array

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

echo "Set up is done."

# Memo
# https://dev.classmethod.jp/articles/mac-recommended-initial-settings/
