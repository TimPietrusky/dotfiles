#!/usr/bin/env bash
# macOS system preferences.
#
#   ./macos/defaults.sh
#
# NOTE ON PROVENANCE: the source machine (macOS 26.3) had essentially every one
# of these keys *unset* — i.e. it was running Apple's stock defaults, with the
# system-settings GUI never touched beyond tap-to-click. So this file is NOT a
# dump of a customised machine; it is the small opinionated set that makes a
# terminal/agent workflow bearable, and it is safe to skip entirely.
#
# The two things that WERE non-stock on the source machine:
#   - trackpad tap-to-click: OFF (macOS default) — left alone below
#   - Dock: only "Notes" pinned; everything else was unpinned
#
# Everything here is idempotent. Re-run freely.

set -euo pipefail

echo "==> Keyboard: fast key repeat (helps vim/tmux)"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable press-and-hold accent popup so key repeat actually works in editors
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "==> Text: stop macOS rewriting what you type"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "==> Finder: show extensions, path bar, list view, no .DS_Store on network"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search current folder
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "==> Dock: small, auto-hide, no recents"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false   # don't reorder spaces

echo "==> Screenshots: PNG into ~/Desktop/screenshots, no drop shadow"
mkdir -p "$HOME/Desktop/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Desktop/screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

echo "==> Safari: developer menu"
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || \
  echo "    (skipped — Safari is sandboxed; enable it in Safari > Settings > Advanced)"

echo "==> Misc: expanded save/print panels, no .DS_Store on USB"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "==> Restarting Finder + Dock"
killall Finder Dock 2>/dev/null || true

cat <<'EOF'

Done. Some changes need a logout/restart to fully apply.

[HUMAN] Things macOS will not let a script do — set these in System Settings:
  - Trackpad > tap to click (source machine had this OFF — Apple's default)
  - Privacy & Security > Input Monitoring + Accessibility -> Karabiner-Elements
  - Privacy & Security > Accessibility -> Wispr Flow (dictation)
  - Privacy & Security > Screen Recording -> Granola (meeting capture)
  - Login items: Granola, Wispr Flow, Steam
  - iCloud / Apple ID sign-in
  - FileVault, Touch ID, and "use Touch ID for sudo"
EOF
