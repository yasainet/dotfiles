# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

This is a personal dotfiles repository for macOS development environment setup, containing configuration files for various development tools and shell environments.

## Repository Structure

- `.config/` - Configuration files for development tools
  - `nvim/` - Neovim configuration with Lua plugins
  - `zsh/` - Zsh shell configuration and aliases
  - `git/` - Git configuration
  - `tmux/` - tmux terminal multiplexer configuration
  - `starship.toml` - Starship prompt configuration
  - `ghostty/` - Ghostty terminal configuration
  - `karabiner/` - Karabiner-Elements keyboard customization
- `Applications/` - Application-specific configurations
- `setup.sh` - macOS system preferences automation script
- `README.md` - Installation and setup instructions

## Common Commands and Usage

### System Setup
- Initial setup: `chmod +x ~/dotfiles/setup.sh && ~/dotfiles/setup.sh`
- Link configurations: Follow symlink commands in README.md

### Shell and Navigation
- Custom aliases available in `.config/zsh/.zshrc`:
  - `v`, `vi`, `vim` → `nvim`
  - `cat` → `bat` (syntax highlighting)
  - `top` → `glances` (system monitoring)
  - Directory shortcuts: `dot()`, `conf()`, `pj()` functions

### Development Environment
- Editor: Neovim with lazy.nvim plugin manager
- Terminal: Ghostty with Tokyo Night theme
- Shell: Zsh with Oh My Zsh, autosuggestions, and syntax highlighting
- Prompt: Starship with custom configuration
- Git: Configured with LFS support

## Theme and Styling

Consistent Tokyo Night theme across:
- Neovim
- Ghostty terminal
- tmux
- bat syntax highlighting

## Key Development Tools Configured

- **Neovim**: Full IDE setup with LSP, treesitter, telescope, and completion
- **tmux**: Prefix key `C-a`, vim-style navigation, bottom pane toggle with `t`
- **Git**: Delta diff viewer, LFS enabled, credential manager configured
- **Zsh**: Enhanced with plugins, custom functions, and aliases
- **fzf**: Integrated fuzzy finding with key bindings

## Notes for Working with This Repository

- All configuration files use consistent naming and organization patterns
- Symbolic links are used to manage dotfiles (see README.md for linking commands)
- The setup prioritizes development workflow efficiency with vim-style keybindings throughout
- Tokyo Night theme provides visual consistency across all tools