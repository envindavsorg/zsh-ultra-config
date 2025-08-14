# 🚀 Zsh Ultra Config

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-blue.svg)](https://www.zsh.org/)
[![macOS](https://img.shields.io/badge/Platform-macOS-lightgrey.svg)](https://www.apple.com/macos/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/envindavsorg/zsh-ultra-config/graphs/commit-activity)

**A comprehensive, performance-optimized Zsh configuration with modular alias collections for developers**

*Transform your terminal into a productivity powerhouse* 💪

</div>

---

## ✨ Features

### 🎯 **Smart Package Manager Detection**
- Auto-detects npm, yarn, pnpm, or bun in your projects
- Universal commands that work across all package managers
- Seamless switching between projects with different tooling

### ⚡ **Performance Optimized**
- Lazy loading for heavy tools (NVM, version managers)
- Background compilation of shell completions
- Optimized history settings with smart deduplication
- Fast startup times with intelligent caching

### 🧩 **Modular Architecture**
- **Development Tools** (`dev.zsh`) - Package managers, testing, linting
- **System Management** (`system.zsh`) - macOS utilities, process management
- **File Navigation** (`files.zsh`) - Enhanced ls, directory bookmarks, search
- **Git Workflow** (`github.zsh`) - Comprehensive Git aliases and utilities

### 🛠️ **Tool Integrations**
- **Starship** - Fast, customizable prompt
- **Mise** - Universal version manager
- **FZF** - Fuzzy finder integration
- **Homebrew** - Package management
- **Docker** - Container development

### 🎨 **Enhanced Terminal Experience**
- Beautiful colored output with syntax highlighting
- Interactive completions with previews
- Smart history search and navigation
- Conventional commit helpers
- macOS-specific optimizations

---

## 🚀 Quick Start

### Prerequisites

- **Zsh** (default on macOS Catalina+)
- **Homebrew** (recommended)
- **Git** (for installation and updates)

### Installation

```bash
# Clone the repository
git clone https://github.com/envindavsorg/zsh-ultra-config.git ~/.zsh-ultra-config

# Backup your existing configuration (optional)
cp ~/.zshrc ~/.zshrc.backup

# Create symbolic link or copy the configuration
ln -sf ~/.zsh-ultra-config/.zshrc ~/.zshrc
ln -sf ~/.zsh-ultra-config/.zsh-aliases ~/.zsh-aliases

# Reload your shell
source ~/.zshrc
```

### Recommended Tools

Install these tools for the best experience:

```bash
# Essential tools
brew install starship          # Modern prompt
brew install mise              # Version manager
brew install fzf               # Fuzzy finder
brew install tree              # Directory tree viewer
brew install ripgrep           # Fast grep alternative

# Zsh enhancements
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

# Development tools
brew install node              # Node.js
brew install docker            # Container platform
```

---

## 💡 Usage Examples

### 🔧 **Universal Package Manager Commands**

No more remembering different commands for different projects!

```bash
# These work in ANY JavaScript project
pm install     # Auto-detects and runs npm/yarn/pnpm/bun install
pm dev         # Starts development server
pm build       # Builds the project
pm test        # Runs tests
pm lint        # Lints code

# Project creation made easy
create-next myapp     # Next.js project
create-vite webapp    # Vite project  
create-ts backend     # TypeScript project
```

### 🌿 **Git Workflow Mastery**

Streamlined Git operations with conventional commits:

```bash
# Conventional commits
gcommit feat "add user authentication"
gcfix "resolve login timeout issue"
gcommit docs "update API documentation"

# Branch management
gfeature user-auth    # Creates feature/user-auth branch
gclean               # Removes merged branches
gbackup              # Creates backup of current branch

# Advanced operations
gstats               # Repository statistics
gsearch "bug fix"    # Search commit history
grebase 3            # Interactive rebase last 3 commits
```

### 🗂️ **Enhanced File Navigation**

Navigate like a pro with enhanced commands:

```bash
# Smart navigation
mkcd newproject      # Create and enter directory
up 3                # Go up 3 directories
ff "config"         # Find files containing "config"
cdl ~/Documents     # Change directory and list contents

# Directory bookmarks
bookmark work       # Save current directory as "work"
jump work          # Jump to bookmarked directory
showmarks          # Show all bookmarks

# Enhanced listing
l                  # Detailed file listing
la                 # Include hidden files
lt                 # Sort by modification time
lfiles             # List files only (no directories)
treef              # Tree view with full paths
```

### 🖥️ **System Management**

macOS-specific utilities for power users:

```bash
# Finder management
show-hidden        # Toggle hidden file visibility
dock-setup         # Configure Dock with optimal settings
clean-cache        # Clean system caches

# Development environment
update-all         # Update all package managers
killport 3000      # Kill process on specific port
speedtest          # Internet speed test
sysinfo           # Comprehensive system information
```

---

## 🎛️ **Configuration**

### Customization

Create `~/.zshrc.local` for personal customizations:

```bash
# ~/.zshrc.local (not tracked by git)
export CUSTOM_VAR="value"
alias myalias="custom command"

# Override default editor
export EDITOR="code"
export VISUAL="code"
```

### Module Management

Disable specific modules by removing them from `.zsh-aliases/`:

```bash
# Disable git aliases
rm ~/.zsh-aliases/github.zsh

# Disable system management aliases
rm ~/.zsh-aliases/system.zsh
```

### Performance Tuning

Enable profiling to analyze startup time:

```bash
# Uncomment in .zshrc
zmodload zsh/zprof    # At the top
# zprof               # At the bottom
```

---

## 📚 **Built-in Help System**

Each module includes comprehensive help:

```bash
devhelp      # Development commands and package management
syshelp      # System and macOS utilities  
navhelp      # Navigation and file management
ghelp        # Git workflow and aliases
```

---

## 🏗️ **Architecture**

```
zsh-ultra-config/
├── .zshrc                 # Main configuration file
├── .zsh-aliases/          # Modular alias collections
│   ├── dev.zsh           # Development & package management
│   ├── system.zsh        # System & macOS utilities
│   ├── files.zsh         # File navigation & management
│   └── github.zsh        # Git workflow & utilities
├── CLAUDE.md             # Claude Code assistant guidance
└── README.md             # This file
```

### Key Design Principles

- **Modular**: Each feature set is in its own file
- **Performance**: Lazy loading and optimization throughout
- **Conflict-Free**: No duplicate aliases between modules
- **Discoverable**: Built-in help for every feature
- **Extensible**: Easy to add custom functionality

---

## 🤝 **Contributing**

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'feat: add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow the existing code style and structure
- Test aliases thoroughly before submitting
- Update documentation for new features
- Use conventional commit messages
- Ensure no alias conflicts between modules

---

## 📋 **Compatibility**

| Platform      | Status         | Notes                                             |
|---------------|----------------|---------------------------------------------------|
| macOS         | ✅ Full Support | Optimized with macOS-specific utilities           |
| Linux         | ⚠️ Partial     | Core features work, some macOS utilities disabled |
| Windows (WSL) | ⚠️ Partial     | Basic functionality, limited testing              |

---

## 🙏 **Acknowledgments**

This configuration is inspired by and builds upon:

- [Oh My Zsh](https://ohmyz.sh/) - Community-driven framework
- [Starship](https://starship.rs/) - Cross-shell prompt
- [FZF](https://github.com/junegunn/fzf) - Fuzzy finder
- [Mise](https://mise.jdx.dev/) - Development tool version manager

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⭐ **Support**

If this configuration helps improve your productivity, please give it a star! ⭐

Found a bug or have a feature request? [Open an issue](https://github.com/envindavsorg/zsh-ultra-config/issues).

---

<div align="center">

**Made with ❤️ for developers who love productive terminals**

[⬆ Back to top](#-zsh-ultra-config)

</div>
