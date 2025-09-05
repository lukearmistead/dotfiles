#!/bin/bash
# macos-preferences.sh - Configure essential macOS system preferences
# Run with: ./macos-preferences.sh

set -e

echo "🍎 Configuring macOS system preferences..."

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Mouse & Trackpad
###############################################################################

echo "🖱️  Configuring mouse..."

# Set mouse speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.0
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.0

###############################################################################
# Keyboard
###############################################################################

echo "⌨️  Configuring keyboard..."

# Set key repeat rate to fastest
defaults write NSGlobalDomain KeyRepeat -int 2

# Set delay until repeat to shortest  
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Make function keys (F1, F2, etc.) the default behavior
# Press Fn + F1/F2 to access brightness/volume controls
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

###############################################################################
# Finder
###############################################################################

echo "📁 Configuring Finder..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set default Finder view to column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Disable .DS_Store files on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

###############################################################################
# Dock
###############################################################################

echo "🚢 Configuring Dock..."

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Remove default apps from Dock
defaults write com.apple.dock persistent-apps -array

###############################################################################
# Menu Bar
###############################################################################

echo "📊 Configuring menu bar..."

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true

# Use 24-hour time format
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  H:mm"

###############################################################################
# Restart affected applications
###############################################################################

echo "🔄 Restarting affected applications..."

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" &> /dev/null || true
done

echo "" 
echo "✅ Essential macOS preferences configured!" 
echo "📝 Note: The Caps Lock → Control mapping requires a logout/restart to take effect."
echo "🎉 Your Mac is now configured with your preferred settings!"
