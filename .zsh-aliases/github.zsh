#!/bin/bash

# ================================
# Git Aliases Collection
# ================================
# A comprehensive set of Git aliases and functions to boost productivity
# Add this to your ~/.bashrc, ~/.zshrc, or create a separate file and source it

# ================================
# Basic Git Commands
# ================================

# Core shortcuts
alias g="git"                          # Quick git access
alias gs="git status -sb"               # Short status with branch info
alias ga="git add"                      # Stage files
alias gaa="git add --all"               # Stage all changes (new, modified, deleted)
alias gap="git add -p"                  # Interactive staging (review chunks before adding)

# Diff commands - View changes
alias gd="git diff"                     # Show unstaged changes
alias gdc="git diff --cached"           # Show staged changes (ready to commit)
alias gds="git diff --stat"             # Summary of changes (files changed, insertions, deletions)

# ================================
# Commit Operations
# ================================

alias gc="git commit -m"                # Quick commit with inline message
alias gca="git commit --amend"          # Modify the last commit
alias gcane="git commit --amend --no-edit"  # Amend last commit keeping the same message
alias gcm="git commit"                   # Open editor for detailed commit message

# ================================
# Push & Pull Operations
# ================================

alias gp="git push"                     # Push to remote
alias gpf="git push --force-with-lease" # Safe force push (fails if remote has new commits)
alias gpl="git pull"                    # Pull from remote
alias gpll="git pull --rebase"          # Pull and rebase local changes on top
alias gpo="git push origin"             # Push to origin remote
alias gpu="git push -u origin HEAD"     # Push current branch and set upstream tracking

# ================================
# Branch Management
# ================================

alias gb="git branch"                   # List local branches
alias gba="git branch -a"               # List all branches (local + remote)
alias gbd="git branch -d"               # Delete branch (only if merged)
alias gbD="git branch -D"               # Force delete branch (even if not merged)
alias gco="git checkout"                # Switch branches or restore files
alias gcob="git checkout -b"            # Create new branch and switch to it
alias gcom="git checkout main"          # Quick switch to main branch
alias gcod="git checkout develop"       # Quick switch to develop branch
alias gsw="git switch"                  # Modern way to switch branches (Git 2.23+)
alias gswc="git switch -c"              # Create and switch to new branch

# ================================
# Enhanced Log Views
# ================================

# Compact views with graph
alias gl="git log --oneline --graph --decorate --all"        # Full history graph
alias gll="git log --oneline --graph --decorate --all -20"    # Last 20 commits
# Detailed formatted log with colors
alias glg="git log --graph --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%d%C(reset) %s %C(green)(%cr) %C(bold blue)<%an>%C(reset)' --abbrev-commit"
alias glog="git log --oneline --decorate --graph"             # Simple graph view
alias gloga="git log --oneline --decorate --graph --all"      # Graph with all branches
alias glast="git log -1 HEAD --stat"                          # Detailed view of last commit

# ================================
# Stash Management
# ================================
# Temporarily save changes without committing

alias gst="git stash"                   # Stash current changes
alias gstp="git stash pop"              # Apply and remove latest stash
alias gstl="git stash list"             # List all stashes
alias gsta="git stash apply"            # Apply stash without removing it
alias gstd="git stash drop"             # Delete a specific stash
alias gstc="git stash clear"            # Delete all stashes
alias gsts="git stash save"             # Stash with a description

# ================================
# Rebase Operations
# ================================
# Rewrite history and integrate changes

alias grb="git rebase"                  # Start rebase
alias grbi="git rebase -i"              # Interactive rebase
alias grbc="git rebase --continue"      # Continue after resolving conflicts
alias grba="git rebase --abort"         # Cancel rebase and restore original state
alias grbm="git rebase main"            # Rebase current branch onto main
alias grbd="git rebase develop"         # Rebase current branch onto develop

# ================================
# Reset Commands
# ================================
# Undo changes at different levels

alias grh="git reset HEAD"              # Unstage files
alias grhh="git reset HEAD --hard"      # Discard all changes (DANGEROUS!)
alias grhs="git reset HEAD~1 --soft"    # Undo last commit, keep changes staged
alias grhm="git reset HEAD~1 --mixed"   # Undo last commit, unstage changes
alias gundo="git reset HEAD~1 --soft"   # User-friendly alias for undoing last commit

# ================================
# Remote Repository Management
# ================================

alias gr="git remote"                   # Show remotes
alias grv="git remote -v"               # Show remotes with URLs
alias gra="git remote add"              # Add new remote
alias grr="git remote remove"           # Remove remote

# ================================
# Cherry-pick Operations
# ================================
# Apply specific commits from another branch

alias gcp="git cherry-pick"             # Apply a commit
alias gcpa="git cherry-pick --abort"    # Cancel cherry-pick
alias gcpc="git cherry-pick --continue" # Continue after resolving conflicts

# ================================
# Advanced Git Functions
# ================================

# Conventional Commits Helper
# Creates commits following the Conventional Commits specification
# Usage: gcommit [type] [scope] <message> or gcommit [type] <message>
# Types: feat, fix, docs, style, refactor, test, chore, perf
gcommit() {
  local type="${1:-feat}"
  local scope="$2"
  local message="$3"

  if [[ -z "$message" && -n "$scope" ]]; then
    # If no scope provided, second argument is the message
    message="$scope"
    git commit -m "${type}: ${message}"
  elif [[ -n "$scope" && -n "$message" ]]; then
    # Both scope and message provided
    git commit -m "${type}(${scope}): ${message}"
  else
    echo "Usage: gcommit [type] [scope] <message> or gcommit [type] <message>"
    echo "Types: feat, fix, docs, style, refactor, test, chore, perf"
    echo ""
    echo "Examples:"
    echo "  gcommit feat 'add user authentication'"
    echo "  gcommit fix auth 'resolve login timeout issue'"
  fi
}

# Shortcuts for conventional commits
alias gcfeat="gcommit feat"             # New feature
alias gcfix="gcommit fix"               # Bug fix
alias gcdocs="gcommit docs"             # Documentation only
alias gcstyle="gcommit style"           # Code style (formatting, semicolons, etc.)
alias gcrefactor="gcommit refactor"     # Code refactoring
alias gctest="gcommit test"             # Adding tests
alias gcchore="gcommit chore"           # Maintenance tasks
alias gcperf="gcommit perf"             # Performance improvements

# Branch Creation Helpers
# Follow Git Flow naming conventions
gfeature() {
  echo "Creating feature branch: feature/$1"
  git checkout -b "feature/$1"
}

gfix() {
  echo "Creating fix branch: fix/$1"
  git checkout -b "fix/$1"
}

ghotfix() {
  echo "Creating hotfix branch: hotfix/$1"
  git checkout -b "hotfix/$1"
}

# Clean up merged branches
# Removes local branches that have been merged to main/master/develop
gclean() {
  echo "🧹 Cleaning up merged branches..."
  local branches=$(git branch --merged | grep -v "\*\|main\|master\|develop")
  if [[ -n "$branches" ]]; then
    echo "$branches" | xargs -n 1 git branch -d
    echo "✅ Cleanup complete!"
  else
    echo "No branches to clean up."
  fi
}

# Show files changed in the last X commits
# Usage: gchanged [number_of_commits]
# Default: 10 commits
gchanged() {
  local commits="${1:-10}"
  echo "Files changed in the last $commits commits:"
  git diff --name-only HEAD~${commits}..HEAD | sort | uniq
}

# Repository statistics
# Shows contributor stats and commit patterns
gstats() {
  echo "📊 Top Contributors:"
  git shortlog -sn --all --no-merges | head -10
  echo ""
  echo "📈 Commits by day of week:"
  git log --format="%ad" --date=format:"%A" | sort | uniq -c | sort -n
  echo ""
  echo "📅 Commits by hour of day:"
  git log --format="%ad" --date=format:"%H" | sort | uniq -c | sort -n
}

# Search commit messages in history
# Usage: gsearch "search term"
gsearch() {
  if [[ -z "$1" ]]; then
    echo "Usage: gsearch 'search term'"
    return 1
  fi
  echo "Searching for: $1"
  git log --all --grep="$1" --oneline
}

# Enhanced blame - see who modified a file
# Usage: gwho filename
gwho() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwho <filename>"
    return 1
  fi
  git blame "$1" | sed 's/^/  /' | less
}

# Create a backup branch of current branch
# Useful before dangerous operations
gbackup() {
  local branch=$(git branch --show-current)
  local backup_name="backup/${branch}-$(date +%Y%m%d-%H%M%S)"
  git branch "$backup_name"
  echo "✅ Backup created: $backup_name"
}

# Sync forked repository with upstream
# Assumes 'upstream' remote is configured
gsync() {
  echo "Syncing with upstream..."
  git fetch upstream
  git checkout main
  git merge upstream/main
  git push origin main
  echo "✅ Sync complete!"
}

# Undo last push (DANGEROUS!)
# This rewrites history on the remote
gundopush() {
  echo "⚠️  WARNING: This will rewrite history on the remote!"
  echo "Press Ctrl+C to cancel, or Enter to continue..."
  read
  git push -f origin HEAD~1:$(git branch --show-current)
}

# Interactive rebase for the last X commits
# Usage: grebase [number_of_commits]
# Default: 3 commits
grebase() {
  local commits="${1:-3}"
  echo "Starting interactive rebase for last $commits commits..."
  git rebase -i HEAD~${commits}
}

# Find and checkout a branch using fuzzy search
# Usage: gfind "partial_branch_name"
gfind() {
  if [[ -z "$1" ]]; then
    echo "Usage: gfind 'partial_branch_name'"
    return 1
  fi
  local branch=$(git branch -a | grep -i "$1" | head -1 | xargs)
  if [[ -n "$branch" ]]; then
    local branch_name="${branch#remotes/origin/}"
    echo "Found branch: $branch_name"
    git checkout "$branch_name"
  else
    echo "❌ No branch found containing '$1'"
  fi
}

# Check git status for all repositories in subdirectories
# Useful for managing multiple projects
gstatus-all() {
  echo "Checking all Git repositories in subdirectories..."
  for dir in */; do
    if [[ -d "$dir/.git" ]]; then
      echo ""
      echo "📁 ${dir%/}:"
      (cd "$dir" && git status -sb)
    fi
  done
}

# Open repository in browser (GitHub/GitLab/Bitbucket)
# Works with SSH and HTTPS URLs
gopen() {
  local url=$(git remote get-url origin 2>/dev/null)
  if [[ -z "$url" ]]; then
    echo "❌ No origin remote found"
    return 1
  fi
  # Convert SSH to HTTPS
  url=${url/git@/https://}
  url=${url/.git/}
  url=${url/:/\/}

  # Open in default browser (macOS: open, Linux: xdg-open, WSL: cmd.exe)
  if command -v open >/dev/null 2>&1; then
    open "$url"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url"
  elif command -v cmd.exe >/dev/null 2>&1; then
    cmd.exe /c start "$url"
  else
    echo "URL: $url"
  fi
}

# Clone repository and cd into it
# Usage: gclone <repository_url>
gclone() {
  if [[ -z "$1" ]]; then
    echo "Usage: gclone <repository_url>"
    return 1
  fi
  git clone "$1" && cd "$(basename "$1" .git)"
}

# ================================
# Git Configuration Setup
# ================================

# Run this function to set up recommended Git aliases and configs
setup-git-aliases() {
  echo "Setting up Git aliases and configuration..."

  # Native Git aliases (faster than shell aliases)
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.last 'log -1 HEAD'
  git config --global alias.visual '!gitk'

  # Beautiful log format
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

  # Useful configurations
  git config --global pull.rebase true           # Always rebase when pulling
  git config --global fetch.prune true           # Remove deleted remote branches
  git config --global diff.colorMoved zebra      # Better diff highlighting
  git config --global rerere.enabled true        # Remember resolved conflicts
  git config --global init.defaultBranch main    # Use 'main' as default branch

  echo "✅ Git aliases and configuration set up successfully!"
}

# ================================
# FZF Integration (Advanced)
# ================================
# Install fzf first: brew install fzf (macOS) or apt install fzf (Linux)

if command -v fzf >/dev/null 2>&1; then
  # Interactive branch checkout with preview
  gcof() {
    local branch=$(
      git branch -a |
        grep -v HEAD |
        fzf --preview 'git log --oneline --graph --decorate --color {1}' |
        xargs
    )
    [[ -n "$branch" ]] && git checkout "${branch#remotes/origin/}"
  }

  # Interactive file staging with preview
  gaf() {
    local files=$(
      git status -s |
        fzf -m --preview 'git diff --color {2}' |
        awk '{print $2}'
    )
    [[ -n "$files" ]] && echo "$files" | xargs git add
  }

  # Interactive commit browser with diff preview
  gshow() {
    local commit=$(
      git log --oneline --color |
        fzf --ansi --preview 'git show --color {1}' |
        awk '{print $1}'
    )
    [[ -n "$commit" ]] && git show "$commit"
  }

  # Interactive stash browser
  gstash() {
    local stash=$(
      git stash list |
        fzf --preview 'git stash show -p {1}' |
        awk '{print $1}' |
        sed 's/://'
    )
    [[ -n "$stash" ]] && git stash apply "$stash"
  }
fi

# ================================
# Git-aware Prompt (Optional)
# ================================

# Function to parse current git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Function to show git status indicators
parse_git_status() {
  local status=""
  # Check for uncommitted changes
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    status="*"
  fi
  # Check for unpushed commits
  if [[ -n $(git log @{u}.. 2> /dev/null) ]]; then
    status="${status}↑"
  fi
  # Check for unpulled commits
  if [[ -n $(git log ..@{u} 2> /dev/null) ]]; then
    status="${status}↓"
  fi
  echo "$status"
}

# Example prompt configuration for different shells:

# For Bash (.bashrc):
# PS1='\u@\h:\w $(parse_git_branch)$(parse_git_status) $ '

# For Zsh (.zshrc):
# setopt PROMPT_SUBST
# PROMPT='%n@%m:%~ %F{green}$(parse_git_branch)%f%F{yellow}$(parse_git_status)%f $ '

# For Fish (config.fish):
# function fish_prompt
#     echo -n (whoami)'@'(hostname)':'(pwd)' '
#     echo -n (parse_git_branch)(parse_git_status)' $ '
# end

# ================================
# Help Function
# ================================

# Display all available git aliases and functions
ghelp() {
  echo "================================"
  echo "Git Aliases & Functions Help"
  echo "================================"
  echo ""
  echo "BASIC COMMANDS:"
  echo "  gs     - Git status (short)"
  echo "  ga     - Git add"
  echo "  gaa    - Git add all"
  echo "  gc     - Git commit with message"
  echo "  gp     - Git push"
  echo "  gpl    - Git pull"
  echo ""
  echo "BRANCH OPERATIONS:"
  echo "  gco    - Git checkout"
  echo "  gcob   - Create and checkout branch"
  echo "  gcom   - Checkout main branch"
  echo "  gb     - List branches"
  echo "  gbd    - Delete branch"
  echo ""
  echo "ADVANCED FUNCTIONS:"
  echo "  gcommit      - Conventional commit"
  echo "  gfeature     - Create feature branch"
  echo "  gclean       - Clean merged branches"
  echo "  gstats       - Show repo statistics"
  echo "  gsearch      - Search in commit history"
  echo "  gbackup      - Backup current branch"
  echo ""
  echo "FZF FUNCTIONS (if installed):"
  echo "  gcof         - Interactive branch checkout"
  echo "  gaf          - Interactive file staging"
  echo "  gshow        - Interactive commit browser"
  echo ""
  echo "Run 'alias | grep git' to see all aliases"
  echo "Run 'setup-git-aliases' to configure Git"
}

# ================================
# Auto-load message
# ================================
echo "🚀 Git aliases loaded ! Type 'ghelp' for help."
