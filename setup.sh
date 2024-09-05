#!/bin/bash

# Dcok
defaults write com.apple.dock autohide-delay -int 10; killall Dock

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

mkdir -p ~/Tools
mkdir -p ~/Projects
mkdir -p ~/Work

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Homebrew Path
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Tool
brew install git
brew install mas

# Application
mas install 539883307 # LINE
brew install --cask google-chrome
brew install --cask docker

## Zed
rm -rf ~/.config/zed/keymap.json 
rm -rf ~/.config/zed/settings.json

ln -s ~/.dotfiles/.config/zed/keymap.json ~/.config/zed/keymap.json
ln -s ~/.dotfiles/.config/zed/settings.json ~/.config/zed/settings.json

echo "🎉 Set up is done."
