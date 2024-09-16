#!/bin/bash

echo "🏁 Set up is starting..."

# Dcok
defaults write com.apple.dock autohide-delay -int 10; killall Dock

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Symbolic Link
mkdir ~/Projects
mkdir ~/Tools
mkdir ~/Works

# ln -s ~/Projects ~/Google\ Drive/My\ Drive/
# ln -s ~/Tools ~/Google\ Drive/My\ Drive/
# ln -s ~/Works ~/Google\ Drive/My\ Drive/
# ln -s ~/Downloads ~/Google\ Drive/My\ Drive/

echo "🎉 Set up is done."
