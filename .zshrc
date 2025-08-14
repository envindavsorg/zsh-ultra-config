#!/usr/bin/env zsh

# ~/.zshrc - Optimized ZSH Configuration
# ================================================

# ================================
# Performance Optimization
# ================================
# Enable profiling (uncomment to debug slow startup)
# zmodload zsh/zprof

# Compile zcompdump for faster startup
if [[ -f ~/.zcompdump && ! -f ~/.zcompdump.zwc ]]; then
  zcompile ~/.zcompdump
fi

# ================================
# ZSH Options & Settings
# ================================

# Directory Navigation
setopt AUTO_CD              # Type directory name to cd
setopt AUTO_PUSHD          # Push directories to stack on cd
setopt PUSHD_IGNORE_DUPS   # Don't push duplicates
setopt PUSHD_SILENT        # Don't print directory stack
setopt CDABLE_VARS         # cd to variable values

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamp to history
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicates first
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded duplicates
setopt HIST_FIND_NO_DUPS       # Don't display duplicates
setopt HIST_IGNORE_SPACE       # Don't record lines starting with space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicates
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks
setopt HIST_VERIFY             # Show command before executing from history
setopt SHARE_HISTORY           # Share history between sessions
setopt INC_APPEND_HISTORY      # Add to history immediately

# Completion System
setopt COMPLETE_IN_WORD     # Complete from cursor position
setopt ALWAYS_TO_END        # Move cursor to end after completion
setopt PATH_DIRS            # Search path for completions
setopt AUTO_MENU            # Show completion menu
setopt AUTO_LIST            # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # Add trailing slash for directories
setopt MENU_COMPLETE        # Cycle through completions
setopt NO_BEEP              # Disable beeping

# Job Control
setopt NO_BG_NICE           # Don't nice background jobs
setopt NO_HUP               # Don't kill jobs on shell exit
setopt NO_CHECK_JOBS        # Don't warn about background jobs on exit
setopt LONG_LIST_JOBS       # List jobs in long format

# Globbing and Expansion
setopt EXTENDED_GLOB        # Enable extended globbing
setopt GLOB_DOTS           # Include dotfiles in globbing
setopt NO_CASE_GLOB        # Case-insensitive globbing
setopt NUMERIC_GLOB_SORT   # Sort numerically when relevant
setopt NO_GLOB_COMPLETE    # Don't expand globs on tab

# Input/Output
setopt CORRECT             # Correct command spelling
setopt CORRECT_ALL         # Correct all arguments
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt RC_QUOTES           # Allow 'Henry's Garage'
setopt MAIL_WARNING        # Warn if mail file accessed

# ================================
# Environment Variables
# ================================

# Set default editor
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"

# Set locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# ================================
# PATH Configuration
# ================================

# Function to add to PATH (avoids duplicates)
add_to_path() {
  if [[ -d "$1" && ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Add local paths
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
add_to_path "/usr/local/bin"
add_to_path "/opt/homebrew/bin"
add_to_path "/opt/homebrew/sbin"

# WebStorm
add_to_path "/Applications/WebStorm.app/Contents/MacOS"

# Yarn
add_to_path "$HOME/.yarn/bin"
add_to_path "$HOME/.config/yarn/global/node_modules/.bin"

# Python/qobuz-dl
add_to_path "$HOME/Library/Python/3.9/bin"
alias qobuz-dl="$HOME/Library/Python/3.9/bin/qobuz-dl"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
add_to_path "$PNPM_HOME"

# ================================
# Tool Initializations
# ================================

# Starship prompt (fast and customizable)
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Mise (fast version manager)
if [[ -f "$HOME/.local/bin/mise" ]]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
elif command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# NVM (Node Version Manager) - Lazy load for faster startup
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}
node() { nvm; node "$@"; }
npm() { nvm; npm "$@"; }
npx() { nvm; npx "$@"; }

# ================================
# Completion System Configuration
# ================================

# Initialize completion system
autoload -Uz compinit

# Simple optimization: use cached completions if available
if [[ -f ~/.zcompdump ]]; then
  compinit -C  # Skip security check for faster startup
else
  compinit
fi

# Compile the dump file if needed for faster loading
if [[ -f ~/.zcompdump && ! -f ~/.zcompdump.zwc ]] || [[ ~/.zcompdump -nt ~/.zcompdump.zwc ]]; then
  zcompile ~/.zcompdump &!  # Compile in background
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored output
zstyle ':completion:*' menu select  # Interactive menu
zstyle ':completion:*' group-name ''  # Group results
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completions

# Better SSH/SCP/RSYNC completion
if [[ -r ~/.ssh/known_hosts ]]; then
h=($( cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e 's/,.*//g' | uniq ))
zstyle ':completion:*:(ssh|scp|rsync):*' hosts $h
fi

# Kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ================================
# Key Bindings
# ================================

# Enable vi mode (optional - comment out if you prefer emacs mode)
# bindkey -v

# Emacs mode (default)
bindkey -e

# History search with arrow keys
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^P' history-search-backward    # Ctrl+P
bindkey '^N' history-search-forward     # Ctrl+N

# Quick directory navigation
bindkey '^G' beginning-of-line         # Ctrl+G - beginning of line
bindkey '^E' end-of-line               # Ctrl+E - end of line

# Edit command in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line       # Ctrl+X Ctrl+E

# ================================
# Useful Functions
# ================================

# Weather
weather() {
  curl -s "wttr.in/${1:-Paris}?format=v2"
}

# ================================
# Syntax Highlighting & Autosuggestions
# ================================

# Install with: brew install zsh-syntax-highlighting zsh-autosuggestions
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^Y' autosuggest-accept  # Ctrl+Y to accept suggestion
fi

# ================================
# Load Custom Aliases Files
# ================================

# Load all alias files from ~/.zsh-aliases/
if [[ -d ~/.zsh-aliases ]]; then
for config_file in ~/.zsh-aliases/*.zsh; do
[[ -f "$config_file" ]] && source "$config_file"
done
fi

# ================================
# Local Machine Specific Config
# ================================

# Source local config if exists (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ================================
# Welcome Message
# ================================

# Display system info on new shell (optional)
if command -v fastfetch &>/dev/null; then
fastfetch --logo small
elif command -v neofetch &>/dev/null; then
neofetch --ascii_distro mac_small
fi

# ================================
# Performance Profiling
# ================================

# Uncomment to see startup time analysis
# zprof
