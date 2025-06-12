# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS development environment management. It manages configuration files for various development tools, applications, and system settings through symbolic links and automated setup scripts.

## Architecture

### Configuration Management
- **Centralized Configuration**: All config files are stored in `.config/` following XDG Base Directory specification
- **Symbolic Link Strategy**: Settings are linked from this repo to their expected locations using `ln -s`
- **Application-Specific Settings**: Non-XDG compliant apps store settings in `Applications/` directory

### Key Components
- **Shell Environment**: Zsh with Oh My Zsh, custom functions, and aliases in `.config/zsh/`
- **Editor Configurations**: Zed (`.config/zed/`) and Neovim (`.config/nvim/`)
- **Development Tools**: Git, Delta, Bat with Tokyo Night theme consistency
- **System Customization**: Karabiner-Elements for keyboard, Ghostty for terminal

## Setup Commands

### Initial Setup
```bash
# Run system configuration script
chmod +x ~/dotfiles/setup.sh
./setup.sh
```

### Linking Configuration Files
```bash
# Essential links from README.md
ln -s ~/dotfiles/.config/git/ ~/.config/git
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
ln -sf ~/dotfiles/.config/zsh/.zprofile ~/
ln -s ~/dotfiles/.config/zed/ ~/.config/
ln -s ~/dotfiles/.config/nvim ~/.config/
```

### Development Environment
```bash
# Install Homebrew packages (see README.md for full list)
brew install git node neovim starship fzf bat git-delta

# Node.js with NVM (lazy loading configured in .zshrc)
nvm install --lts
nvm alias default 'lts/*'
```

## Custom Shell Functions and Aliases

### Navigation Functions
- `dot()` - Navigate to dotfiles directory
- `conf()` - Navigate to ~/.config
- `pj()` - Navigate to ~/Projects
- `drive()` - Navigate to Google Drive

### Tool Aliases
- `cat='bat'` - Enhanced cat with syntax highlighting
- `code='zed'` - Use Zed editor
- `vi='nvim'` and `vim='nvim'` - Use Neovim

### Safety Features
- Enhanced `rm` command with confirmation prompts for `-rf` operations
- `cd` function automatically runs `la` after changing directories

## Theme Strategy

Consistent Tokyo Night theme across all tools:
- Zed: Tokyo Night theme in settings.json
- Neovim: Tokyo Night colorscheme
- Bat: tokyonight_night.tmTheme
- Ghostty: tokyonight_* themes
- Delta: tokyonight_day.gitconfig

## Important Files

### Configuration Files
- `.config/zsh/.zshrc` - Main shell configuration with aliases and functions
- `.config/zed/settings.json` - Zed editor settings including AI configuration
- `.config/git/config` - Git configuration with delta integration
- `setup.sh` - macOS system settings automation script

### Application Settings
- `Applications/OpenCommit/.opencommit` - AI commit message tool configuration
- `.config/karabiner/karabiner.json` - Keyboard customization settings

## Development Workflow

When modifying configurations:
1. Edit files in this dotfiles repository
2. Changes are automatically reflected via symbolic links
3. For new tools, add linking commands to README.md setup section
4. Test configuration changes before committing
5. Use `setup.sh` for system-level macOS preferences only

## Notes

- This setup is optimized for macOS development environment
- Homebrew is the primary package manager
- NVM is configured with lazy loading to improve shell startup time
- All theme files maintain visual consistency across development tools