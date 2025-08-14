# 🤝 Contributing to Zsh Ultra Config

<div align="center">

**Thank you for your interest in contributing to Zsh Ultra Config!** 🎉

*We welcome contributions from developers of all skill levels*

</div>

---

## 📋 Table of Contents

- [Getting Started](#-getting-started)
- [Development Setup](#-development-setup)
- [Code Style & Conventions](#-code-style--conventions)
- [Making Changes](#-making-changes)
- [Testing Your Changes](#-testing-your-changes)
- [Submitting Your Contribution](#-submitting-your-contribution)
- [Issue Guidelines](#-issue-guidelines)
- [Pull Request Process](#-pull-request-process)
- [Community Guidelines](#-community-guidelines)

---

## 🚀 Getting Started

### Types of Contributions We Welcome

- 🐛 **Bug fixes** - Help us squash those pesky bugs
- ✨ **New features** - Add useful aliases, functions, or integrations
- 📚 **Documentation improvements** - Make our docs clearer and more helpful
- 🎨 **Code quality** - Refactoring, optimization, and cleanup
- 🧪 **Testing** - Help us test across different platforms and setups
- 💡 **Ideas & suggestions** - Share your thoughts via issues

### Before You Start

1. **Search existing issues** to avoid duplicates
2. **Check the roadmap** in issues for planned features
3. **Join discussions** on existing issues to coordinate efforts
4. **Fork the repository** to your GitHub account

---

## 🛠️ Development Setup

### Prerequisites

```bash
# Essential tools
brew install zsh git
```

### Fork and Clone

```bash
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/zsh-ultra-config.git
cd zsh-ultra-config

# Add upstream remote
git remote add upstream https://github.com/envindavsorg/zsh-ultra-config.git
```

### Development Environment

```bash
# Create a test directory to avoid affecting your main config
mkdir ~/zsh-ultra-config-dev
cd ~/zsh-ultra-config-dev

# Symlink the development version
ln -sf /path/to/your/clone/.zshrc .zshrc-dev
ln -sf /path/to/your/clone/.zsh-aliases .zsh-aliases-dev

# Test in a new shell
zsh -c "source ~/.zshrc-dev && echo 'Development config loaded!'"
```

---

## 📝 Code Style & Conventions

### Shell Script Standards

```bash
#!/bin/bash
# Always include shebang for shell scripts

# Use clear, descriptive comments
# ================================
# Section Header Example
# ================================

# Function documentation
# Usage: function_name "parameter"
# Description: What this function does
function_name() {
  local param="${1:-default_value}"
  echo "Function implementation"
}
```

### Alias Conventions

```bash
# Clear, descriptive aliases with comments
alias shortname="command"                # Brief description of what it does

# Group related aliases together
# ================================
# Git Operations
# ================================
alias gs="git status -sb"               # Short status with branch info
alias ga="git add"                      # Stage files
alias gc="git commit -m"                # Quick commit with inline message
```

### Naming Guidelines

- **Functions**: Use descriptive names with hyphens (`create-backup`)
- **Aliases**: Short but memorable (`gs`, `gco`, `mkcd`)
- **Variables**: Use UPPERCASE for exports, lowercase for local vars
- **Files**: Use lowercase with hyphens (`my-feature.zsh`)

### Documentation Requirements

Every new feature should include:

```bash
# ================================
# Feature Name
# ================================
# Brief description of what this section provides
# 
# Dependencies: list any required tools
# Platform: specify if platform-specific

# Function documentation
# Usage: function_name [options] <required_param>
# Example: function_name --verbose myfile.txt
function_name() {
  # Implementation
}

# Alias documentation  
alias shortcut="command"                 # What this alias does
```

---

## 🔄 Making Changes

### Branching Strategy

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/issue-description

# Keep your branch up to date
git fetch upstream
git rebase upstream/main
```

### Commit Message Format

We use [Conventional Commits](https://conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
git commit -m "feat(dev): add universal test runner detection"
git commit -m "fix(git): resolve duplicate alias conflict"
git commit -m "docs: update installation instructions"
git commit -m "refactor(system): improve macOS detection logic"
```

---

## 🧪 Testing Your Changes

### Manual Testing Checklist

Before submitting, test your changes:

```bash
# 1. Source the configuration
source .zshrc

# 2. Test new aliases/functions
your_new_alias
your_new_function "test_parameter"

# 3. Check for conflicts
# Run help commands to ensure they work
devhelp
syshelp
navhelp
ghelp

# 4. Test on clean shell
zsh -c "source .zshrc && your_test_command"
```

### Platform Testing

If possible, test on:
- ✅ macOS (primary platform)
- ⚠️ Linux (Ubuntu/Debian)
- ⚠️ Windows WSL2

### Performance Testing

For performance-critical changes:

```bash
# Enable profiling
zmodload zsh/zprof

# Source config
source .zshrc

# Check startup time
zprof | head -20
```

### Validation Script

Run this before submitting:

```bash
#!/bin/bash
# validation-test.sh

echo "🧪 Testing Zsh Ultra Config..."

# Test syntax
zsh -n .zshrc && echo "✅ Main config syntax OK" || echo "❌ Syntax error in .zshrc"

# Test each module
for file in .zsh-aliases/*.zsh; do
  zsh -n "$file" && echo "✅ $file syntax OK" || echo "❌ Syntax error in $file"
done

# Test help commands
zsh -c "source .zshrc && devhelp >/dev/null 2>&1" && echo "✅ devhelp works" || echo "❌ devhelp failed"

echo "🎉 Validation complete!"
```

---

## 📤 Submitting Your Contribution

### Pull Request Checklist

- [ ] Branch is up to date with main
- [ ] All tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] Commit messages follow convention
- [ ] No alias conflicts introduced
- [ ] Help functions updated if needed

### Pull Request Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Other (specify): 

## Testing
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Manual testing completed
- [ ] No alias conflicts
- [ ] Help commands work

## Related Issues
Closes #(issue number)

## Additional Notes
Any additional context or screenshots.
```

---

## 🐛 Issue Guidelines

### Bug Reports

When reporting bugs, include:

```markdown
**Bug Description**
A clear description of the bug.

**Steps to Reproduce**
1. Step one
2. Step two
3. See error

**Expected Behavior**
What should have happened.

**Environment**
- OS: macOS 13.0 / Ubuntu 20.04 / etc.
- Zsh version: 5.8.1
- Shell: Terminal.app / iTerm2 / etc.

**Additional Context**
Screenshots, error messages, etc.
```

### Feature Requests

```markdown
**Feature Description**
Clear description of the proposed feature.

**Use Case**
Why would this be useful?

**Proposed Implementation**
How do you think this could work?

**Alternatives Considered**
Other ways to achieve the same goal.
```

---

## 🔄 Pull Request Process

1. **Create** your feature branch
2. **Make** your changes following the guidelines
3. **Test** thoroughly on your system
4. **Update** documentation as needed
5. **Commit** with conventional commit messages
6. **Push** to your fork
7. **Open** a pull request with detailed description
8. **Respond** to feedback and make requested changes
9. **Celebrate** when your PR is merged! 🎉

### Review Process

- All PRs require at least one review
- Maintainers will test changes before merging
- Feedback will be constructive and helpful
- Large changes may require additional discussion

---

## 🌟 Community Guidelines

### Be Respectful

- Use welcoming and inclusive language
- Respect different viewpoints and experiences
- Give constructive feedback
- Focus on what's best for the community

### Be Collaborative

- Help others learn and grow
- Share knowledge and best practices
- Ask questions when you're unsure
- Offer help when you can

### Be Patient

- Remember that everyone started somewhere
- Code review takes time and care
- Open source is often volunteer-driven
- Good things take time to build

---

## 🎯 Development Priorities

### High Priority
- Cross-platform compatibility improvements
- Performance optimizations
- Security enhancements
- Bug fixes

### Medium Priority
- New development tool integrations
- Additional utility functions
- Documentation improvements
- Testing infrastructure

### Future Considerations
- Plugin system architecture
- Configuration management UI
- Advanced customization options

---

## 🤔 Questions?

- 💬 **Discussions**: Use GitHub Discussions for general questions
- 🐛 **Issues**: Use GitHub Issues for bugs and feature requests
- 📧 **Direct Contact**: Reach out to maintainers for sensitive issues

---

## 🙏 Thank You!

<div align="center">

**Your contributions make this project better for everyone!**

*Together, we're building the ultimate Zsh configuration* ⚡

[⬆ Back to top](#-contributing-to-zsh-ultra-config)

</div>