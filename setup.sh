#!/bin/bash

# Dcok
defaults write com.apple.dock autohide-delay -int 10; killall Dock

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

mkdir -p ~/Tools
mkdir -p ~/Projects
mkdir -p ~/Work

echo "🎉 Set up is done."
