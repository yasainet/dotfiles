#!/bin/bash

echo "Set up is starting..."

# General
# Macbook Pro {year}

# Accessibility
# Trackpad Options
# スクロール速度最大化
defaults write -g com.apple.trackpad.scaling -float 3.0
# 3本指ドラッグ有効
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
# Mouse Options
# スクロール速度最大化
defaults write -g com.apple.mouse.scaling -float 3.0

# Appearance
# ダークモード
defaults write -g AppleInterfaceStyle -string "Dark"

# Control Center
# メニューバー常に非表示
defaults write -g _HIHideMenuBar -bool true

# Keyboard
# 自動スペル修正無効化
defaults write NSAutomaticSpellingCorrectionEnabled -bool false
# web入力自動スペル修正無効化
defaults write WebAutomaticSpellingCorrectionEnabled -bool false
# 自動大文字化無効化
defaults write NSAutomaticCapitalizationEnabled -bool false
# 自動ピリオド無効化
defaults write NSAutomaticPeriodSubstitutionEnabled -bool false
# 自動ダッシュ無効化
defaults write NSAutomaticDashSubstitutionEnabled -bool false
# 自動引用符無効化
defaults write NSAutomaticQuoteSubstitutionEnabled -bool false
# キーリピート速度最大化
defaults write -g KeyRepeat -int 2
# リピート速度最短化
defaults write -g InitialKeyRepeat -int 15
# 長押し無効
defaults write -g ApplePressAndHoldEnabled -bool false
# 通知センターショートカット追加
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 163 "{ enabled = 1; value = { parameters = (65535, 53, 1048576); type = 'standard'; }; }"

# 通知センター無効化
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

# Desktop & Dock
# Docke アイコン非表示
defaults write com.apple.dock persistent-apps -array
# Hot Corners　無効化
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
# 再起動
killall Dock

# Finder
# 拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 隠しファイルを表示
defaults write com.apple.Finder AppleShowAllFiles -bool true
# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true
# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true
# 再起動
killall Finder

# Mouse
# トラッキング速度最大化
defaults write -g com.apple.mouse.scaling -float 3.0
# スクロール速度最大化
defaults write -g com.apple.scrollwheel.scaling -float 1.0
# ナチュラルスクロール有効化
defaults write -g com.apple.swipescrolldirection -bool true

# Trackpad
# Point & Click
# タップでクリック有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo "Set up is done."

# Manuel
# System Settings
# Keyboard
# - Press 🌐 key to: Show Emoji & Symbols
# - Keyboard Shortcuts
# - App Shortcuts
#   - Google Chrome.app
#     - WIP
# - Modifier Keys
#   - Caps Lock Key: Control
# Accessibility
#
# - Trackpad Options
#   - Scroll speed: Max
#   - Use tracked for dragging: Trree Finger Drag
# - Mouse Options
#   - Scroll speed: Max

# Memo
# https://dev.classmethod.jp/articles/mac-recommended-initial-settings/
#
# Read
# defaults read com.apple.dock > ./mac_settings/dock.json
# Import
# defaults import com.apple.dock ./mac_settings/dock.json
# killall
# killall Dock
