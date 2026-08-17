#!/bin/sh
set -eu

# Run this file manually after reviewing the preferences below.

# Finder: show filename extensions, hidden files, and the path bar.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders before files when sorting by name.
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Save screenshots as PNG files on the Desktop.
defaults write com.apple.screencapture type -string png
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Apply settings to Finder. Other preferences take effect at next login.
killall Finder 2>/dev/null || true

echo "macOS preferences applied."
