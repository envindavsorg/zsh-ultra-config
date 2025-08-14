#!/bin/bash

# ================================
# Development & Code Management
# ================================
# A comprehensive toolkit for modern development workflows
# Supports npm, yarn, pnpm, and other development tools
# Add this to your ~/.bashrc, ~/.zshrc, or create a separate file and source it

# ================================
# Package Manager Detection
# ================================

# Detect which package manager is used in current project
# Returns: pnpm, yarn, npm, bun, or none
detect_pm() {
  if [[ -f "bun.lockb" ]]; then
    echo "bun"
  elif [[ -f "pnpm-lock.yaml" ]]; then
    echo "pnpm"
  elif [[ -f "yarn.lock" ]]; then
    echo "yarn"
  elif [[ -f "package-lock.json" ]]; then
    echo "npm"
  elif [[ -f "package.json" ]]; then
    echo "npm"  # Default to npm if only package.json exists
  else
    echo "none"
  fi
}

# Display current package manager with details
pm-info() {
  local pm=$(detect_pm)
  if [[ "$pm" != "none" ]]; then
    echo "📦 Package Manager: $pm"
    echo "📁 Project: $(basename $(pwd))"
    if [[ -f "package.json" ]]; then
      local name=$(grep '"name"' package.json | head -1 | cut -d'"' -f4)
      local version=$(grep '"version"' package.json | head -1 | cut -d'"' -f4)
      echo "📋 Package: $name@$version"
    fi
  else
    echo "❌ No Node.js project found in current directory"
  fi
}

# ================================
# Universal Package Manager Command
# ================================

# Smart package manager wrapper that auto-detects and uses the correct PM
# Usage: pm [command] [options]
pm() {
  local pm=$(detect_pm)
  local cmd=$1
  shift

  if [[ "$pm" == "none" ]]; then
    echo "❌ No package.json found in this project"
    echo "💡 Initialize a new project with: npm init -y"
    return 1
  fi

  case "$cmd" in
  i|install)
    echo "📦 Installing dependencies with $pm..."
    $pm install "$@"
    ;;
  r|run)
    $pm run "$@"
    ;;
  d|dev)
    echo "🚀 Starting development server with $pm..."
    $pm run dev "$@"
    ;;
  b|build)
    echo "🏗️  Building project with $pm..."
    $pm run build "$@"
    ;;
  l|lint)
    echo "🔍 Linting code with $pm..."
    $pm run lint "$@"
    ;;
  t|test)
    echo "🧪 Running tests with $pm..."
    $pm run test "$@"
    ;;
  s|start)
    echo "▶️  Starting application with $pm..."
    $pm run start "$@"
    ;;
  p|preview)
    echo "👁️  Preview production build with $pm..."
    $pm run preview "$@"
    ;;
  f|format)
    echo "✨ Formatting code with $pm..."
    $pm run format "$@"
    ;;
  w|watch)
    echo "👀 Starting watch mode with $pm..."
    $pm run watch "$@"
    ;;
  *)
  # Pass command directly to package manager
    $pm "$cmd" "$@"
    ;;
  esac
}

# Quick aliases for common commands
alias i="pm install"
alias dev="pm dev"
alias b="pm build"
alias t="pm test"
alias lint="pm lint"
alias start="pm start"
alias preview="pm preview"
alias fmt="pm format"
alias w="pm watch"

# Show which package manager is detected
alias pm-which="detect_pm"
alias pmw="pm-info"

# ================================
# NPM Specific Commands
# ================================

# npm shortcuts
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install --global"
alias nun="npm uninstall"
alias nup="npm update"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrs="npm run start"
alias nrl="npm run lint"

# npm utilities
alias nls="npm ls --depth=0"            # List installed packages
alias nout="npm outdated"               # Check for outdated packages
alias naudit="npm audit"                # Security audit
alias nfix="npm audit fix"              # Fix security issues
alias npub="npm publish"                # Publish package
alias nlink="npm link"                  # Create symlink

# ================================
# Yarn Specific Commands
# ================================

# yarn shortcuts
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yag="yarn global add"
alias yrm="yarn remove"
alias yup="yarn upgrade"
alias yrd="yarn run dev"
alias yrb="yarn run build"
alias yrt="yarn run test"
alias yrs="yarn run start"
alias yrl="yarn run lint"

# yarn utilities
alias yls="yarn list --depth=0"         # List installed packages
alias yout="yarn outdated"              # Check for outdated packages
alias yaudit="yarn audit"               # Security audit
alias ywhy="yarn why"                   # Why is package installed
alias ywork="yarn workspaces"           # Workspace commands

# ================================
# PNPM Specific Commands
# ================================

# pnpm shortcuts
alias pi="pnpm install"
alias pa="pnpm add"
alias pad="pnpm add -D"
alias pag="pnpm add -g"
alias prm="pnpm remove"
alias pup="pnpm update"
alias prd="pnpm run dev"
alias prb="pnpm run build"
alias prt="pnpm run test"
alias prs="pnpm run start"
alias prl="pnpm run lint"

# pnpm utilities
alias pls="pnpm list --depth=0"         # List installed packages
alias pout="pnpm outdated"              # Check for outdated packages
alias paudit="pnpm audit"               # Security audit
alias pwhy="pnpm why"                   # Why is package installed
alias pexec="pnpm exec"                 # Execute binary

# ================================
# Bun Specific Commands
# ================================

# bun shortcuts
alias bi="bun install"
alias ba="bun add"
alias bad="bun add -D"
alias brm="bun remove"
alias bup="bun update"
alias brd="bun run dev"
alias brb="bun run build"
alias brt="bun run test"
alias brs="bun run start"

# ================================
# Universal Package Management Functions
# ================================

# Add package (auto-detect package manager)
# Usage: pm-add package-name
pm-add() {
  local pm=$(detect_pm)
  case "$pm" in
  npm)  npm install --save "$@" ;;
  yarn) yarn add "$@" ;;
  pnpm) pnpm add "$@" ;;
  bun)  bun add "$@" ;;
  *) echo "❌ No package manager detected" ;;
  esac
}

# Add dev dependency (auto-detect package manager)
# Usage: pm-add-dev package-name
pm-add-dev() {
  local pm=$(detect_pm)
  case "$pm" in
  npm)  npm install --save-dev "$@" ;;
  yarn) yarn add --dev "$@" ;;
  pnpm) pnpm add -D "$@" ;;
  bun)  bun add -D "$@" ;;
  *) echo "❌ No package manager detected" ;;
  esac
}

# Add global package (auto-detect package manager)
# Usage: pm-add-global package-name
pm-add-global() {
  local pm=$(detect_pm)
  case "$pm" in
  npm)  npm install --global "$@" ;;
  yarn) yarn global add "$@" ;;
  pnpm) pnpm add -g "$@" ;;
  bun)  bun add -g "$@" ;;
  *) echo "❌ No package manager detected" ;;
  esac
}

# Remove package (auto-detect package manager)
# Usage: pm-remove package-name
pm-remove() {
  local pm=$(detect_pm)
  case "$pm" in
  npm)  npm uninstall "$@" ;;
  yarn) yarn remove "$@" ;;
  pnpm) pnpm remove "$@" ;;
  bun)  bun remove "$@" ;;
  *) echo "❌ No package manager detected" ;;
  esac
}

# Update packages (auto-detect package manager)
pm-update() {
  local pm=$(detect_pm)
  case "$pm" in
  npm)  npm update "$@" ;;
  yarn) yarn upgrade "$@" ;;
  pnpm) pnpm update "$@" ;;
  bun)  bun update "$@" ;;
  *) echo "❌ No package manager detected" ;;
  esac
}

# Aliases for package management functions
alias padd="pm-add"
alias pdev="pm-add-dev"
alias pglobal="pm-add-global"
alias premove="pm-remove"
alias pupdate="pm-update"

# ================================
# Project Maintenance
# ================================

# Clean and reinstall dependencies
# Removes node_modules and lock files, then reinstalls
pm-clean() {
  local pm=$(detect_pm)
  echo "🧹 Cleaning and reinstalling with $pm..."

  # Remove node_modules and lock files
  rm -rf node_modules package-lock.json yarn.lock pnpm-lock.yaml bun.lockb

  # Clear cache
  case "$pm" in
  npm)  npm cache clean --force ;;
  yarn) yarn cache clean ;;
  pnpm) pnpm store prune ;;
  esac

  # Reinstall
  $pm install
  echo "✅ Project cleaned and dependencies reinstalled"
}

# Deep clean including caches
pm-deep-clean() {
  echo "🧹 Deep cleaning project..."

  # Remove all generated files
  rm -rf node_modules
  rm -rf .next .nuxt dist build out coverage
  rm -rf package-lock.json yarn.lock pnpm-lock.yaml bun.lockb
  rm -rf .parcel-cache .turbo .cache

  # Clear global caches
  npm cache clean --force 2>/dev/null
  yarn cache clean 2>/dev/null
  pnpm store prune 2>/dev/null

  echo "✅ Deep clean complete"
}

alias clean="pm-clean"
alias deepclean="pm-deep-clean"
alias nuke="pm-deep-clean"

# ================================
# Node Version Management
# ================================

# Switch Node version using nvm
# Usage: nv 18 (switches to Node 18)
nv() {
  if command -v nvm >/dev/null 2>&1; then
    nvm use "$1"
  elif command -v n >/dev/null 2>&1; then
    n "$1"
  else
    echo "❌ No Node version manager found (nvm or n)"
  fi
}

# List available Node versions
alias nvls="nvm ls 2>/dev/null || n ls"
alias nvinstall="nvm install"
alias nvuse="nvm use"
alias nvdefault="nvm alias default"

# ================================
# Project Initialization
# ================================

# Create new Next.js project
create-next() {
  local name="${1:-my-app}"
  echo "🚀 Creating Next.js project: $name"
  npx create-next-app@latest "$name"
  cd "$name"
  echo "✅ Project created and ready!"
}

# Create new Vite project
create-vite() {
  local name="${1:-my-app}"
  echo "⚡ Creating Vite project: $name"
  npm create vite@latest "$name"
  cd "$name"
  pm install
  echo "✅ Project created and ready!"
}

# Create new React app
create-react() {
  local name="${1:-my-app}"
  echo "⚛️  Creating React project: $name"
  npx create-react-app "$name"
  cd "$name"
  echo "✅ Project created and ready!"
}

# Create new Node.js project
create-node() {
  local name="${1:-my-app}"
  echo "📦 Creating Node.js project: $name"
  mkdir "$name" && cd "$name"
  npm init -y
  echo "✅ Project initialized!"
}

# Create TypeScript project
create-ts() {
  local name="${1:-my-app}"
  echo "📘 Creating TypeScript project: $name"
  mkdir "$name" && cd "$name"
  npm init -y
  npm install --save-dev typescript @types/node ts-node nodemon
  npx tsc --init
  echo "✅ TypeScript project ready!"
}

# ================================
# Development Server Management
# ================================

# Kill process on specific port
# Usage: killport 3000
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port_number>"
    return 1
  fi
  local pid=$(lsof -ti:$1)
  if [[ -n "$pid" ]]; then
    kill -9 $pid
    echo "✅ Killed process on port $1"
  else
    echo "No process found on port $1"
  fi
}

# Find what's running on a port
# Usage: whoisport 3000
whoisport() {
  if [[ -z "$1" ]]; then
    echo "Usage: whoisport <port_number>"
    return 1
  fi
  lsof -i :$1
}

# List all Node processes
alias nodeps="ps aux | grep node | grep -v grep"
alias killnode="killall node"

# ================================
# Docker Development
# ================================

# Docker shortcuts
alias dk="docker"
alias dkc="docker-compose"
alias dkps="docker ps"
alias dkpsa="docker ps -a"
alias dki="docker images"
alias dkrm="docker rm"
alias dkrmi="docker rmi"
alias dkexec="docker exec -it"
alias dklogs="docker logs -f"
alias dkbuild="docker build -t"
alias dkrun="docker run -it --rm"

# Docker Compose shortcuts
alias dcup="docker-compose up"
alias dcupd="docker-compose up -d"
alias dcdown="docker-compose down"
alias dcbuild="docker-compose build"
alias dclogs="docker-compose logs -f"
alias dcps="docker-compose ps"
alias dcrestart="docker-compose restart"

# Clean Docker system
docker-clean() {
  echo "🧹 Cleaning Docker system..."
  docker system prune -af
  docker volume prune -f
  echo "✅ Docker system cleaned"
}

# ================================
# Database Management
# ================================

# PostgreSQL shortcuts
alias pgstart="brew services start postgresql"
alias pgstop="brew services stop postgresql"
alias pgrestart="brew services restart postgresql"

# MySQL shortcuts
alias mystart="brew services start mysql"
alias mystop="brew services stop mysql"
alias myrestart="brew services restart mysql"

# MongoDB shortcuts
alias mgstart="brew services start mongodb-community"
alias mgstop="brew services stop mongodb-community"
alias mgrestart="brew services restart mongodb-community"

# Redis shortcuts
alias rdstart="brew services start redis"
alias rdstop="brew services stop redis"
alias rdrestart="brew services restart redis"

# ================================
# Code Quality Tools
# ================================

# ESLint with auto-fix
lint-fix() {
  local pm=$(detect_pm)
  echo "🔧 Running ESLint with auto-fix..."
  $pm run lint -- --fix "$@"
}

# Prettier format
format-code() {
  local pm=$(detect_pm)
  echo "✨ Formatting code with Prettier..."
  if [[ -f ".prettierrc" ]] || [[ -f ".prettierrc.json" ]] || [[ -f "prettier.config.js" ]]; then
    $pm run format "$@"
  else
    npx prettier --write . "$@"
  fi
}

# Type check TypeScript
typecheck() {
  echo "📘 Type checking TypeScript..."
  npx tsc --noEmit "$@"
}

alias lfix="lint-fix"
alias fmt="format-code"
alias tcheck="typecheck"

# ================================
# Environment Management
# ================================

# Load environment variables from .env file
loadenv() {
  local env_file="${1:-.env}"
  if [[ -f "$env_file" ]]; then
    export $(cat "$env_file" | grep -v '^#' | xargs)
    echo "✅ Loaded environment from $env_file"
  else
    echo "❌ File not found: $env_file"
  fi
}

# Show current environment variables
showenv() {
  if [[ -f ".env" ]]; then
    echo "📋 Environment variables from .env:"
    cat .env | grep -v '^#' | grep -v '^$'
  else
    echo "❌ No .env file found"
  fi
}

# Create .env from example
create-env() {
  if [[ -f ".env.example" ]]; then
    cp .env.example .env
    echo "✅ Created .env from .env.example"
    echo "📝 Remember to update the values!"
  else
    echo "❌ No .env.example found"
  fi
}

# ================================
# Testing Utilities
# ================================

# Run tests with coverage
test-coverage() {
  local pm=$(detect_pm)
  echo "🧪 Running tests with coverage..."
  $pm run test -- --coverage "$@"
}

# Run tests in watch mode
test-watch() {
  local pm=$(detect_pm)
  echo "👀 Running tests in watch mode..."
  $pm run test -- --watch "$@"
}

# Run specific test file
test-file() {
  local pm=$(detect_pm)
  if [[ -z "$1" ]]; then
    echo "Usage: test-file <filename>"
    return 1
  fi
  echo "🧪 Running test: $1"
  $pm run test -- "$1"
}

alias tw="test-watch"
alias tcov="test-coverage"
alias tfile="test-file"

# ================================
# Bundle Analysis
# ================================

# Analyze bundle size
bundle-analyze() {
  local pm=$(detect_pm)
  echo "📊 Analyzing bundle size..."

  # Check for existing analyze script
  if grep -q '"analyze"' package.json; then
    $pm run analyze
  else
    # Try common analyzer tools
    if [[ -f "next.config.js" ]]; then
      npx @next/bundle-analyzer
    elif [[ -f "webpack.config.js" ]]; then
      npx webpack-bundle-analyzer
    else
      echo "❌ No bundle analyzer found"
    fi
  fi
}

alias analyze="bundle-analyze"
alias bundle="bundle-analyze"

# ================================
# Quick Scripts
# ================================

# Add script to package.json
# Usage: add-script "dev" "next dev"
add-script() {
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "Usage: add-script <name> <command>"
    return 1
  fi

  local script_name=$1
  local script_cmd=$2

  # Use jq if available, otherwise use sed
  if command -v jq >/dev/null 2>&1; then
    jq ".scripts.\"$script_name\" = \"$script_cmd\"" package.json > tmp.json && mv tmp.json package.json
  else
    # Fallback to manual editing
    echo "📝 Add this to your package.json scripts:"
    echo "  \"$script_name\": \"$script_cmd\""
  fi
}

# ================================
# Help Function
# ================================

# Display all development aliases and functions
devhelp() {
  echo "================================"
  echo "Development & Code Management Help"
  echo "================================"
  echo ""
  echo "PACKAGE MANAGER DETECTION:"
  echo "  pm-info    - Show current package manager"
  echo "  pm [cmd]   - Run command with detected PM"
  echo ""
  echo "QUICK COMMANDS (auto-detect PM):"
  echo "  i          - Install dependencies"
  echo "  d          - Run dev server"
  echo "  b          - Build project"
  echo "  t          - Run tests"
  echo "  l          - Lint code"
  echo "  s          - Start application"
  echo ""
  echo "PACKAGE MANAGEMENT:"
  echo "  padd       - Add package"
  echo "  pdev       - Add dev dependency"
  echo "  premove    - Remove package"
  echo "  clean      - Clean and reinstall"
  echo ""
  echo "PROJECT CREATION:"
  echo "  create-next  - Create Next.js app"
  echo "  create-vite  - Create Vite app"
  echo "  create-react - Create React app"
  echo "  create-node  - Create Node.js project"
  echo "  create-ts    - Create TypeScript project"
  echo ""
  echo "DEVELOPMENT TOOLS:"
  echo "  killport   - Kill process on port"
  echo "  whoisport  - Check what's on port"
  echo "  lint-fix   - Run linter with fix"
  echo "  format-code- Format with Prettier"
  echo ""
  echo "DOCKER:"
  echo "  dcup       - Docker Compose up"
  echo "  dcdown     - Docker Compose down"
  echo "  dklogs     - Docker logs"
  echo ""
  echo "Run 'alias | grep -E \"^(pm|ni|yi|pi)\"' to see all aliases"
}

# ================================
# Auto-load message
# ================================
echo "🚀 Development aliases loaded ! Type 'devhelp' for help."
