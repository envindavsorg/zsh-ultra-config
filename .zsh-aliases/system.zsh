#!/bin/bash

# ================================
# System Commands & macOS Management
# ================================
# A comprehensive collection of system utilities and macOS-specific commands
# Add this to your ~/.bashrc, ~/.zshrc, or create a separate file and source it

# ================================
# Basic System Commands
# ================================

# Screen management
alias c="clear"                         # Clear terminal screen
alias cl="clear && ls -la"              # Clear screen and list files
alias cls="clear && ls"                 # Clear and simple list
alias cll="clear && ll"                 # Clear and detailed list

# System privileges
alias s="sudo -s"                       # Switch to root shell
alias sudo="sudo "                      # Allow aliases to work with sudo
alias please="sudo"                     # Polite alternative to sudo
alias root="sudo -i"                    # Root login shell

# Shell configuration reload
alias sz="source ~/.zshrc"              # Reload Zsh configuration
alias sb="source ~/.bashrc"             # Reload Bash configuration
alias sp="source ~/.profile"            # Reload profile
alias sa="source ~/.aliases"            # Reload aliases file

# Reload with notification
reload() {
  local shell_name=$(basename "$SHELL")
  local config_file=""

  case "$shell_name" in
  zsh)  config_file="$HOME/.zshrc" ;;
  bash) config_file="$HOME/.bashrc" ;;
  *)    config_file="$HOME/.profile" ;;
  esac

  source "$config_file"
  echo "✅ Reloaded $config_file"
}

# ================================
# Path & Environment Management
# ================================

# Display PATH in readable format
alias path='echo -e ${PATH//:/\\n}'     # Show PATH entries on separate lines
alias pathlist="echo $PATH | tr ':' '\n' | nl"  # Numbered PATH list

# Add directory to PATH
addpath() {
  if [[ -z "$1" ]]; then
    echo "Usage: addpath <directory>"
    return 1
  fi
  if [[ -d "$1" ]]; then
    export PATH="$1:$PATH"
    echo "✅ Added to PATH: $1"
  else
    echo "❌ Directory not found: $1"
  fi
}

# Remove directory from PATH
rmpath() {
  if [[ -z "$1" ]]; then
    echo "Usage: rmpath <directory>"
    return 1
  fi
  export PATH=$(echo $PATH | sed -e "s|$1:||g" -e "s|:$1||g")
  echo "✅ Removed from PATH: $1"
}

# Show all environment variables
alias env="env | sort"                  # Sorted environment variables
alias envg="env | grep -i"              # Grep environment variables

# Export shortcuts
alias x="export"                        # Quick export
alias unx="unset"                       # Quick unset

# ================================
# Process Management
# ================================

# Process listing
alias ps="ps aux"                       # Detailed process list
alias psg="ps aux | grep -v grep | grep -i"  # Search processes
alias top="top -o cpu"                  # Top sorted by CPU usage
alias htop="htop"                       # Better top (if installed)

# Kill processes
alias k9="kill -9"                      # Force kill
alias killall="killall -v"              # Verbose killall

# Find process by name and kill
# Usage: pkill process_name
pkill() {
  if [[ -z "$1" ]]; then
    echo "Usage: pkill <process_name>"
    return 1
  fi
  local pids=$(pgrep -i "$1")
  if [[ -n "$pids" ]]; then
    echo "Killing processes: $pids"
    kill -9 $pids
    echo "✅ Processes killed"
  else
    echo "No processes found matching: $1"
  fi
}

# Monitor process
# Usage: monitor process_name
monitor() {
  if [[ -z "$1" ]]; then
    echo "Usage: monitor <process_name>"
    return 1
  fi
  watch -n 1 "ps aux | grep -v grep | grep -i '$1'"
}

# ================================
# System Information
# ================================

# System info shortcuts
alias cpu="sysctl -n machdep.cpu.brand_string"  # CPU info (macOS)
alias mem="top -l 1 -s 0 | grep PhysMem"        # Memory info
alias disk="df -h"                               # Disk usage
alias uptime="uptime"                            # System uptime

# Comprehensive system information
sysinfo() {
  echo "================================"
  echo "System Information"
  echo "================================"
  echo "Hostname: $(hostname)"
  echo "OS: $(uname -s) $(uname -r)"
  echo "Kernel: $(uname -v)"
  echo "Architecture: $(uname -m)"
  echo "CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || lscpu | grep 'Model name' | cut -d: -f2)"
  echo "Memory: $(top -l 1 -s 0 | grep PhysMem)"
  echo "Uptime: $(uptime)"
  echo "Current user: $(whoami)"
  echo "Home directory: $HOME"
  echo "Shell: $SHELL"
}

# ================================
# Network Commands
# ================================

# Network information
alias ip="curl -s ifconfig.me"          # Public IP address
alias localip="ipconfig getifaddr en0"  # Local IP address (macOS)
alias ips="ifconfig -a | grep -o 'inet \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet //'"

# Network utilities
alias ping="ping -c 5"                  # Ping with count limit
alias ports="netstat -an | grep LISTEN" # Show listening ports
alias netconn="lsof -i"                 # Show network connections

# Flush DNS cache (macOS)
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Speed test function
# Requires: brew install speedtest-cli
speedtest() {
  if command -v speedtest-cli >/dev/null 2>&1; then
    speedtest-cli
  else
    echo "Installing speedtest-cli..."
    pip install speedtest-cli && speedtest-cli
  fi
}

# ================================
# macOS Finder Management
# ================================

# Toggle hidden files in Finder
# Usage: toggle-hidden [show|hide]
toggle-hidden() {
  local state="${1:-show}"
  if [[ "$state" == "show" ]]; then
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "✅ Hidden files are now visible"
  else
    defaults write com.apple.finder AppleShowAllFiles FALSE
    echo "✅ Hidden files are now hidden"
  fi
  killall Finder
}

# Aliases for hidden files
alias show-hidden="toggle-hidden show"  # Show hidden files in Finder
alias hide-hidden="toggle-hidden hide"  # Hide hidden files in Finder
alias hidden="toggle-hidden show"       # Quick show hidden

# Finder shortcuts
alias finder="open -a Finder ./"             # Open current directory in Finder
alias o="open ."                        # Open current directory
alias finderapp="open -a Finder"           # Open Finder app

# Open specific locations in Finder
alias fh="open ~"                       # Open home in Finder
alias fd="open ~/Desktop"               # Open Desktop in Finder
alias fdl="open ~/Downloads"            # Open Downloads in Finder
alias fapp="open /Applications"         # Open Applications in Finder

# Restart macOS services
alias rfinder="killall Finder"          # Restart Finder
alias rdock="killall Dock"              # Restart Dock
alias rbar="killall SystemUIServer"     # Restart menu bar
alias rall="killall Finder Dock SystemUIServer"  # Restart all UI services

# Clean and restart
clean-restart() {
  echo "🧹 Cleaning and restarting macOS UI services..."
  rm -rf ~/Library/Caches/com.apple.finder
  rm -rf ~/Library/Saved\ Application\ State/com.apple.finder.savedState
  killall Finder Dock SystemUIServer
  echo "✅ UI services restarted"
}

# ================================
# macOS Dock Management
# ================================

# Add spacer to Dock
# Usage: dock-spacer [apps|others]
dock-spacer() {
  local section="${1:-apps}"
  if [[ "$section" == "apps" ]]; then
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
  else
    defaults write com.apple.dock persistent-others -array-add '{"tile-type"="spacer-tile";}'
  fi
  killall Dock
  echo "✅ Spacer added to Dock ($section section)"
}

# Dock management aliases
alias dspace="dock-spacer apps"         # Add spacer to apps section
alias dspace-other="dock-spacer others" # Add spacer to others section
alias dreset="defaults delete com.apple.dock && killall Dock"  # Reset Dock to default

# Dock configuration
dock-setup() {
  echo "⚙️  Configuring Dock settings..."

  # Set Dock size
  defaults write com.apple.dock tilesize -int 48

  # Enable magnification
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock largesize -int 64

  # Autohide settings
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0.1
  defaults write com.apple.dock autohide-time-modifier -float 0.5

  # Show indicators for open apps
  defaults write com.apple.dock show-process-indicators -bool true

  # Minimize effect
  defaults write com.apple.dock mineffect -string "genie"

  killall Dock
  echo "✅ Dock configured"
}

# ================================
# macOS System Preferences
# ================================

# Screenshot settings
screenshot-setup() {
  local location="${1:-$HOME/Desktop}"
  echo "📸 Configuring screenshot settings..."

  # Set location
  defaults write com.apple.screencapture location -string "$location"

  # Disable shadow
  defaults write com.apple.screencapture disable-shadow -bool true

  # Set format (png, jpg, pdf)
  defaults write com.apple.screencapture type -string "png"

  # Include date in filename
  defaults write com.apple.screencapture include-date -bool true

  killall SystemUIServer
  echo "✅ Screenshots will be saved to: $location"
}

# Keyboard settings
keyboard-setup() {
  echo "⌨️  Configuring keyboard settings..."

  # Enable key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set fast key repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Enable full keyboard access
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  echo "✅ Keyboard configured (restart may be required)"
}

# ================================
# macOS Cleanup & Maintenance
# ================================

# Clean system caches
clean-cache() {
  echo "🧹 Cleaning system caches..."

  # User caches
  rm -rf ~/Library/Caches/*

  # System caches (requires sudo)
  sudo rm -rf /Library/Caches/*
  sudo rm -rf /System/Library/Caches/*

  # DNS cache
  sudo dscacheutil -flushcache

  echo "✅ Caches cleaned"
}

# Clean .DS_Store files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias cleanup-global="sudo find / -name '.DS_Store' -delete 2>/dev/null"

# Empty Trash securely
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Update everything
update-all() {
  echo "🔄 Updating all package managers..."

  # macOS Software Update
  echo "Checking macOS updates..."
  softwareupdate -i -a

  # Homebrew
  if command -v brew >/dev/null 2>&1; then
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
  fi

  # npm
  if command -v npm >/dev/null 2>&1; then
    echo "Updating npm packages..."
    npm update -g
  fi

  # pip
  if command -v pip >/dev/null 2>&1; then
    echo "Updating pip packages..."
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
  fi

  echo "✅ All updates complete"
}

# ================================
# Quick Launch Applications
# ================================

# Development tools
alias code="open -a 'Visual Studio Code'"
alias vscode="code"
alias sublime="open -a 'Sublime Text'"
alias atom="open -a 'Atom'"
alias idea="open -a 'IntelliJ IDEA'"
alias xcode="open -a 'Xcode'"

# Browsers
alias chrome="open -a 'Google Chrome'"
alias firefox="open -a 'Firefox'"
alias safari="open -a 'Safari'"
alias brave="open -a 'Brave Browser'"

# Communication
alias slack="open -a 'Slack'"
alias discord="open -a 'Discord'"
alias teams="open -a 'Microsoft Teams'"
alias zoom="open -a 'Zoom'"

# Productivity
alias notion="open -a 'Notion'"
alias obsidian="open -a 'Obsidian'"
alias notes="open -a 'Notes'"

# ================================
# Terminal Enhancements
# ================================

# Terminal title
# Usage: title "My Custom Title"
title() {
  echo -ne "\033]0;${1:-Terminal}\007"
}

# Terminal notification (macOS)
# Usage: notify "Task completed"
notify() {
  local message="${1:-Task completed}"
  local title="${2:-Terminal}"
  osascript -e "display notification \"$message\" with title \"$title\""
}

# Run command and notify when done
# Usage: run-notify "sleep 10" "Sleep finished"
run-notify() {
  local command="$1"
  local message="${2:-Command completed}"

  eval "$command"
  local exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    notify "$message ✅" "Success"
  else
    notify "$message ❌" "Failed"
  fi

  return $exit_code
}

# ================================
# Security & Privacy
# ================================

# Lock screen
alias lock="pmset displaysleepnow"      # Lock screen immediately
alias lockscreen="pmset displaysleepnow"

# Secure file deletion
alias shred="rm -P"                     # Overwrite file before deletion

# Generate secure password
# Usage: genpass [length]
genpass() {
  local length="${1:-16}"
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c "$length" | pbcopy
  echo "✅ Password copied to clipboard (length: $length)"
}

# ================================
# Help Function
# ================================

# Display all system and macOS aliases
syshelp() {
  echo "================================"
  echo "System & macOS Commands Help"
  echo "================================"
  echo ""
  echo "SYSTEM BASICS:"
  echo "  c          - Clear screen"
  echo "  s          - Switch to root shell"
  echo "  reload     - Reload shell configuration"
  echo "  path       - Show PATH entries"
  echo ""
  echo "PROCESS MANAGEMENT:"
  echo "  psg        - Search processes"
  echo "  pkill      - Kill process by name"
  echo "  monitor    - Monitor specific process"
  echo ""
  echo "MACOS FINDER:"
  echo "  show-hidden - Show hidden files"
  echo "  f          - Open current dir in Finder"
  echo "  rfinder    - Restart Finder"
  echo ""
  echo "DOCK MANAGEMENT:"
  echo "  dspace     - Add spacer to Dock"
  echo "  dock-setup - Configure Dock settings"
  echo "  dreset     - Reset Dock to defaults"
  echo ""
  echo "MAINTENANCE:"
  echo "  cleanup    - Remove .DS_Store files"
  echo "  clean-cache - Clear system caches"
  echo "  update-all - Update all packages"
  echo ""
  echo "UTILITIES:"
  echo "  sysinfo    - Show system information"
  echo "  speedtest  - Test internet speed"
  echo "  genpass    - Generate secure password"
  echo "  notify     - Send notification"
  echo ""
  echo "Run 'alias | grep -E \"^[a-z]\"' to see all aliases"
}

# ================================
# Auto-load message
# ================================
echo "🚀 System & macOS aliases loaded ! Type 'syshelp' for help."
