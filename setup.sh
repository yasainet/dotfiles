#!/bin/bash

echo "🏁 Set up is starting..."

# General
## アクセントメニューの無効化
defaults write -g ApplePressAndHoldEnabled -bool false

# Dcok
## Dock から全て削除
defaults write com.apple.dock persistent-apps -array

# Finder
## 拡張子表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
## 隠しファイル表示
defaults write com.apple.Finder AppleShowAllFiles -bool true

echo "🎉 Set up is done."
