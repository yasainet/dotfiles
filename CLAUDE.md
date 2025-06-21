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
- **Prompt System**: Starship prompt with Tokyo Night theme in `.config/starship.toml`
- **Terminal**: Ghostty terminal emulator with Tokyo Night themes in `.config/ghostty/`
- **Editor Configurations**: 
  - Zed editor (`.config/zed/`)
  - Neovim with extensive plugin ecosystem (`.config/nvim/`)
- **Development Tools**: Git, Delta, Bat with Tokyo Night theme consistency
- **System Monitoring**: btop system monitor with custom Tokyo Night theme
- **Browser Extensions**: Vimium configuration for keyboard navigation
- **System Customization**: Karabiner-Elements for keyboard remapping

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
ln -s ~/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/.config/ghostty/ ~/.config/ghostty
ln -s ~/dotfiles/.config/btop/ ~/.config/btop
```

### Development Environment
```bash
# Install Homebrew packages (see README.md for full list)
brew install git node neovim starship fzf bat git-delta ghostty btop

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
- **Starship**: Custom Tokyo Night color palette in starship.toml
- **Ghostty**: Tokyo Night theme variants (day, moon, night, storm) in themes/
- **Zed**: Tokyo Night theme in settings.json
- **Neovim**: Tokyo Night colorscheme with tokyonight.nvim plugin
- **Bat**: tokyonight_night.tmTheme for syntax highlighting
- **btop**: Custom tokyo-night.theme for system monitoring
- **Delta**: tokyonight_day.gitconfig for git diff visualization
- **Terminal**: Nord theme as alternative option

## Important Files

### Configuration Files
- `.config/zsh/.zshrc` - Main shell configuration with aliases and functions
- `.config/starship.toml` - Starship prompt configuration with Tokyo Night theme
- `.config/ghostty/config` - Ghostty terminal settings with theme integration
- `.config/zed/settings.json` - Zed editor settings including AI configuration
- `.config/git/config` - Git configuration with delta integration
- `.config/btop/btop.conf` - System monitor configuration
- `setup.sh` - macOS system settings automation script

### Neovim Plugin System
- `.config/nvim/lua/plugins/` - Modular plugin configurations
  - `init.lua` - Plugin manager and theme setup
  - `lsp.lua` - LSP configurations for multiple languages
  - `mason.lua` - LSP server management
  - `cmp.lua` - Completion system with nvim-cmp
  - `treesitter.lua` - Syntax highlighting and parsing
  - `gitsigns.lua` - Git integration and status display
  - `lualine.lua` - Enhanced status line
  - `neo-tree.lua` - File explorer with custom settings
  - `toggleterm.lua` - Integrated terminal functionality
- `.config/nvim/.luarc.json` - Lua Language Server configuration

### Application Settings
- `Applications/OpenCommit/.opencommit` - AI commit message tool configuration
- `Applications/Vimium/vimium-options.json` - Browser keyboard navigation
- `Applications/Terminal/themes/Nord.terminal` - macOS Terminal theme
- `.config/karabiner/karabiner.json` - Keyboard customization settings

## Development Workflow

When modifying configurations:
1. Edit files in this dotfiles repository
2. Changes are automatically reflected via symbolic links
3. For new tools, add linking commands to README.md setup section
4. Test configuration changes before committing
5. Use `setup.sh` for system-level macOS preferences only

## Plugin Management

### Neovim Plugins
The Neovim setup uses lazy.nvim as the plugin manager with modular configuration:
- **LSP Integration**: Mason for LSP server management, nvim-lspconfig for language support
- **Completion**: nvim-cmp with multiple sources (LSP, buffer, path, snippets)
- **Syntax Highlighting**: nvim-treesitter with multiple language parsers
- **Git Integration**: gitsigns for status display and change tracking
- **File Navigation**: neo-tree for file explorer with custom width settings
- **Terminal**: toggleterm for integrated terminal functionality
- **UI Enhancement**: lualine for status line, tokyonight for theming

### Package Management
- **Homebrew**: Primary package manager for system tools
- **Mason**: LSP server and tool management within Neovim
- **lazy.nvim**: Neovim plugin management with lazy loading

## Notes

- This setup is optimized for macOS development environment
- Ghostty is the primary terminal emulator with transparency and theme support
- Starship provides a fast, customizable shell prompt
- NVM is configured with lazy loading to improve shell startup time
- All theme files maintain visual consistency across development tools using Tokyo Night
- btop provides system monitoring with vim-like keybindings
- Vimium enables keyboard-driven browser navigation