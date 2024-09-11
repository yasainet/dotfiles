#!/bin/bash

echo "🏁 Set up is starting..."

# Dcok
defaults write com.apple.dock autohide-delay -int 10; killall Dock

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Symbolic Link
ln -s ~/Google\ Drive/My\ Drive/Projects ~/Projects
ln -s ~/Google\ Drive/My\ Drive/Tools ~/Tools
ln -s ~/Google\ Drive/My\ Drive/Works ~/Works

ln -sf ~/Google\ Drive/My\ Drive/Downloads ~/Downloads

echo "🎉 Set up is done."
