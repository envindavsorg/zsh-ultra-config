#!/bin/bash

# ================================
# Navigation & File Management Aliases
# ================================
# A comprehensive collection of aliases and functions for efficient file system navigation
# Add this to your ~/.bashrc, ~/.zshrc, or create a separate file and source it

# ================================
# FUNCTIONS SECTION (Must come before aliases in zsh)
# ================================

# Create directory and enter it
# Usage: mkcd new_directory_name
mkcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkcd <directory_name>"
    return 1
  fi
  mkdir -p "$1" && cd "$1"
  echo "Created and entered directory: $1"
}

# Go up N directories
# Usage: up 3 (goes up 3 directories)
up() {
  local levels=${1:-1}
  local path=""
  for ((i=0; i<levels; i++)); do
    path="../$path"
  done
  cd "$path" || return 1
}

# Change to a directory and list its contents
# Usage: cdl directory_name (renamed from cl to avoid conflicts)
cdl() {
  cd "$1" && /bin/ls -la
}

# Find and cd to a directory
# Usage: fcd directory_name
fcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: fcd <directory_name>"
    return 1
  fi
  local dir=$(find . -type d -name "*$1*" 2>/dev/null | head -1)
  if [[ -n "$dir" ]]; then
    cd "$dir"
    echo "Changed to: $dir"
  else
    echo "Directory containing '$1' not found"
  fi
}

# Count files and directories
count() {
  local total=$(/bin/ls -1 2>/dev/null | wc -l)
  local files=$(/bin/ls -l 2>/dev/null | grep -v '^d' | tail -n +2 | wc -l)
  local dirs=$(/bin/ls -l 2>/dev/null | grep '^d' | wc -l)
  echo "📊 Current directory: $(pwd)"
  echo "📁 Directories: $dirs"
  echo "📄 Files: $files"
  echo "📦 Total items: $total"
}

# Find files by name (case-insensitive)
# Usage: ff "filename"
ff() {
  if [[ -z "$1" ]]; then
    echo "Usage: ff <filename_pattern>"
    return 1
  fi
  find . -type f -iname "*$1*" 2>/dev/null
}

# Find directories by name (case-insensitive)
# Usage: finddir "dirname" (renamed from fd to avoid conflicts)
finddir() {
  if [[ -z "$1" ]]; then
    echo "Usage: finddir <directory_pattern>"
    return 1
  fi
  find . -type d -iname "*$1*" 2>/dev/null
}

# Find files containing text
# Usage: ftext "search text"
ftext() {
  if [[ -z "$1" ]]; then
    echo "Usage: ftext <search_text>"
    return 1
  fi
  grep -r "$1" . 2>/dev/null
}

# Find files modified in last N days
# Usage: frecent 7 (files modified in last 7 days)
frecent() {
  local days=${1:-1}
  find . -type f -mtime -${days} -ls 2>/dev/null
}

# Create backup of file
# Usage: backup filename
backup() {
  if [[ -z "$1" ]]; then
    echo "Usage: backup <filename>"
    return 1
  fi
  cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
  echo "✅ Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Extract any archive
# Usage: extract file.tar.gz
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.tar.xz)    tar xJf "$1"     ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar e "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create tar.gz archive
# Usage: compress directory_or_file
compress() {
  if [[ -z "$1" ]]; then
    echo "Usage: compress <directory_or_file>"
    return 1
  fi
  tar -czf "$1.tar.gz" "$1"
  echo "✅ Compressed: $1.tar.gz"
}

# Save current directory with a name
# Usage: bookmark myproject
bookmark() {
  if [[ -z "$1" ]]; then
    echo "Usage: bookmark <name>"
    return 1
  fi
  echo "$1:$(pwd)" >> "$BOOKMARKS_FILE"
  echo "✅ Bookmarked '$(pwd)' as '$1'"
}

# Jump to bookmarked directory
# Usage: jump myproject
jump() {
  if [[ -z "$1" ]]; then
    echo "Usage: jump <bookmark_name>"
    echo "Available bookmarks:"
    showmarks
    return 1
  fi
  local dest=$(grep "^$1:" "$BOOKMARKS_FILE" 2>/dev/null | cut -d: -f2- | tail -1)
  if [[ -n "$dest" ]]; then
    cd "$dest"
    echo "📍 Jumped to: $dest"
  else
    echo "❌ Bookmark '$1' not found"
  fi
}

# Show all bookmarks
showmarks() {
  if [[ -f "$BOOKMARKS_FILE" ]]; then
    echo "📚 Directory Bookmarks:"
    cat "$BOOKMARKS_FILE" | column -t -s:
  else
    echo "No bookmarks saved yet"
  fi
}

# Delete a bookmark
# Usage: delbookmark myproject
delbookmark() {
  if [[ -z "$1" ]]; then
    echo "Usage: delbookmark <name>"
    return 1
  fi
  if [[ -f "$BOOKMARKS_FILE" ]]; then
    grep -v "^$1:" "$BOOKMARKS_FILE" > "$BOOKMARKS_FILE.tmp"
    mv "$BOOKMARKS_FILE.tmp" "$BOOKMARKS_FILE"
    echo "✅ Deleted bookmark: $1"
  fi
}

# FZF Integration Functions (if available)
if command -v fzf >/dev/null 2>&1; then
  # Interactive directory navigation
  # Usage: cdf (then select directory)
  cdf() {
    local dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m)
    [[ -n "$dir" ]] && cd "$dir"
  }

  # Interactive file selection for editing
  # Usage: vf (then select file to edit)
  vf() {
    local file=$(fzf --preview 'head -100 {}')
    [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
  }

  # Interactive process kill
  # Usage: fkill (then select process)
  fkill() {
    local pid=$(ps aux | sed 1d | fzf -m | awk '{print $2}')
    if [[ -n "$pid" ]]; then
      echo "$pid" | xargs kill -9
      echo "✅ Process killed"
    fi
  }
fi

# Display all navigation aliases and functions
navhelp() {
  echo "================================"
  echo "Navigation & File Management Help"
  echo "================================"
  echo ""
  echo "QUICK NAVIGATION:"
  echo "  ..      - Go up one directory"
  echo "  ...     - Go up two directories"
  echo "  -       - Go to previous directory"
  echo "  h       - Go to home directory"
  echo "  d       - Go to Desktop"
  echo ""
  echo "LISTING FILES:"
  echo "  l       - List files (detailed)"
  echo "  la      - List all including hidden"
  echo "  lt      - List by time modified"
  echo "  ld      - List only directories"
  echo "  lh      - List only hidden files"
  echo ""
  echo "FUNCTIONS:"
  echo "  mkcd    - Create and enter directory"
  echo "  up      - Go up N directories"
  echo "  cdl     - Change directory and list contents"
  echo "  fcd     - Find and cd to directory"
  echo "  ff      - Find files by name"
  echo "  finddir - Find directories by name"
  echo "  count   - Count files and directories"
  echo "  backup  - Create backup of file"
  echo "  extract - Extract any archive"
  echo ""
  echo "BOOKMARKS:"
  echo "  bookmark   - Save current directory"
  echo "  jump       - Jump to bookmarked directory"
  echo "  showmarks  - Show all bookmarks"
  echo ""
  echo "FZF FUNCTIONS (if installed):"
  echo "  cdf     - Interactive directory navigation"
  echo "  vf      - Interactive file selection"
  echo "  fkill   - Interactive process kill"
  echo ""
  echo "Run 'alias | grep -E \"^l|cd\"' to see all navigation aliases"
}

# ================================
# ENVIRONMENT VARIABLES & EXPORTS
# ================================

# Initialize bookmarks file
export BOOKMARKS_FILE="$HOME/.directory_bookmarks"

# Detect which `ls` flavor is in use and set color variables
if /bin/ls --color > /dev/null 2>&1; then
  # GNU ls (Linux)
  colorflag="--color"
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
else
  # macOS ls
  colorflag="-G"
  export LSCOLORS='ExFxCxDxBxegedabagacad'
fi

# ================================
# ALIASES SECTION (After functions)
# ================================

# ================================
# Quick Directory Navigation
# ================================

# Navigate up directories
alias ..="cd .."                        # Go up one level
alias ...="cd ../.."                    # Go up two levels
alias ....="cd ../../.."                # Go up three levels
alias .....="cd ../../../.."            # Go up four levels
alias ......="cd ../../../../.."        # Go up five levels

# Quick navigation shortcuts
alias ~="cd ~"                          # Go to the home directory
alias -- -="cd -"                       # Go to previous directory (dash needs --)
alias back="cd -"                       # Alternative for going back

# ================================
# Enhanced ls Commands
# ================================

# Apply colors to ls
alias ls="/bin/ls ${colorflag}"

# Basic listing with human-readable sizes
alias l="ls -lFh"                       # Long format, classify files, human-readable
alias la="ls -lAFh"                     # Include hidden files except . and ..
alias lt="ls -ltrFh"                    # Sort by modification time (newest last)
alias ltr="ls -ltFh"                    # Sort by modification time (newest first)
alias ll="ls -FGlAhp"                   # Detailed list with colors and indicators

# List by size
alias lS="ls -lhSr"                     # Sort by size (largest last)
alias lSr="ls -lhS"                     # Sort by size (largest first)

# List only hidden files
alias lh="ls -d .*"                     # Show only hidden files
alias ldh="ls -ld .*"                   # Detailed hidden files

# ================================
# Directory-specific Listings
# ================================

# List only directories
alias ld="ls -d */"                     # List directories in current folder
alias ldir="ls -d */"                   # Alternative: list directories
alias dirs="ls -d */"                   # Alternative: list directories
alias folders="ls -d */"                # Alternative: list directories

# Detailed directory listings
alias ldf="ls -lhd */"                  # Detailed directory info with sizes
alias lds="ls -1d */"                   # Simple one-per-line directory list

# List files only (no directories)
alias lfiles="/bin/ls -l | grep -v '^d'"         # List files only
alias files="/bin/ls -l | grep -v '^d'"      # Alternative: list files

# ================================
# Tree View Commands
# ================================
# Requires: brew install tree (macOS) or apt install tree (Linux)

alias td="tree -d -L 1"                 # Tree view of directories, 1 level deep
alias td2="tree -d -L 2"                # Tree view of directories, 2 levels deep
alias td3="tree -d -L 3"                # Tree view of directories, 3 levels deep
alias treef="tree -f -L 1"                 # Tree view with full paths, 1 level
alias ta="tree -a -L 1"                 # Tree view including hidden files
alias ts="tree -h --du"                 # Tree view with file sizes

# ================================
# Quick Access to Common Directories
# ================================

# System directories
alias h="cd ~"                          # Home directory
alias desk="cd ~/Desktop"                  # Desktop
alias dl="cd ~/Downloads"               # Downloads
alias dc="cd ~/Documents"               # Documents
alias pics="cd ~/Pictures"                 # Pictures
alias m="cd ~/Music"                    # Music
alias v="cd ~/Videos"                   # Videos

# Development directories (customize these)
alias dev="cd ~/Development"            # Development folder
alias proj="cd ~/Projects"              # Projects folder
alias work="cd ~/Work"                  # Work folder
alias repos="cd ~/Repositories"         # Git repositories
alias dots="cd ~/dotfiles"              # Dotfiles directory

# System locations
alias tmp="cd /tmp"                     # Temporary directory
alias etc="cd /etc"                     # System configuration
alias var="cd /var"                     # Variable data
alias log="cd /var/log"                 # System logs
alias apps="cd /Applications"           # Applications (macOS)

# Show directory stack
# Useful with pushd/popd commands
alias dstack="dirs -v"                  # Show directory stack with numbers

# Navigate through directory history
alias pd="pushd"                        # Push directory to stack
alias pop="popd"                        # Pop directory from stack

# ================================
# File Information & Stats
# ================================

# Show disk usage for current directory
alias du1="du -h --max-depth=1"         # Disk usage, 1 level deep
alias duh="du -h"                       # Human-readable disk usage
alias dus="du -hs * | sort -h"          # Sorted disk usage summary

# Show available disk space
alias df="df -h"                        # Human-readable disk free space
alias dfi="df -i"                       # Show inode information

# File size utilities
alias sizeof="du -hs"                   # Get size of file or directory
alias bigfiles="find . -type f -size +100M -exec ls -lh {} \;" # Find large files
alias newest="/bin/ls -lt | head -20"        # Show 20 newest files
alias oldest="/bin/ls -ltr | head -20"       # Show 20 oldest files

# ================================
# Quick File Operations
# ================================

# Create multiple directories at once
alias mkdirs="mkdir -p"                 # Create parent directories as needed

# Safe file operations (ask before overwriting)
alias cp="cp -i"                        # Interactive copy
alias mv="mv -i"                        # Interactive move
alias rm="rm -i"                        # Interactive remove

# Recursive operations
alias cpr="cp -r"                       # Recursive copy
alias rmr="rm -rf"                      # Recursive force remove (CAREFUL!)

# ================================
# Permissions Shortcuts
# ================================

alias chmod755="chmod 755"              # Owner: rwx, Group/Others: r-x
alias chmod644="chmod 644"              # Owner: rw-, Group/Others: r--
alias chmod600="chmod 600"              # Owner: rw-, Group/Others: ---
alias chmod777="chmod 777"              # Everyone: rwx (CAREFUL!)
alias chmodx="chmod +x"                 # Make executable

# Show octal permissions
alias octal="stat -c '%a %n'"           # Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias octal="stat -f '%A %N'"       # macOS
fi

# ================================
# Platform-specific Aliases
# ================================

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
  alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
  alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
  alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
fi

# Linux specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias open="xdg-open"                # Open file with default application
  alias pbcopy="xclip -selection clipboard"  # Copy to clipboard
  alias pbpaste="xclip -selection clipboard -o"  # Paste from clipboard
fi

# ================================
# Network Directories (Optional)
# ================================
# Uncomment and modify these for your network shares

# alias nas="cd /Volumes/NAS"           # Network Attached Storage
# alias shared="cd /mnt/shared"         # Shared network drive
# alias remote="cd ~/remote"            # Remote mounted directory

# ================================
# Auto-load message
# ================================
echo "🚀 Navigation aliases loaded! Type 'navhelp' for help."
