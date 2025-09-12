# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

Personal dotfiles repository for macOS development environment setup with automated configuration management via symbolic links.

## Key Commands

### Repository Management
- **Navigate to dotfiles**: `dot()` or `cd ~/dotfiles`
- **Apply system preferences**: `chmod +x ~/dotfiles/setup.sh && ~/dotfiles/setup.sh`
- **Check git status**: Repository is tracked with git, main branch is default

### Shell Aliases & Functions
Important custom commands from `.config/zsh/.zshrc`:
- **Editor**: `v`, `vi`, `vim` → all mapped to `nvim`
- **Navigation shortcuts**:
  - `dot()` → ~/dotfiles
  - `conf()` → ~/.config  
  - `pj()` → ~/Projects
  - `drive()` → Google Drive
- **Enhanced tools**:
  - `cat` → `bat` (with syntax highlighting)
  - `ls` → colored output, `la` for all files
  - `rm` → interactive by default, confirmation required for `rm -rf`
- **Claude Code shortcuts**: 
  - `claude` or `cc` → launch Claude Code
  - `ccc` → claude -c (continue)
  - `ccr` → claude -r (review)

### Configuration Linking
Key symlinks that need to be established (from README.md):
```bash
ln -s ~/dotfiles/.config/git/ ~/.config/git
ln -sf ~/dotfiles/.config/zsh/.zprofile ~/
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
ln -s ~/dotfiles/.config/.oh-my-zsh ~/.config/.oh-my-zsh
ln -s ~/dotfiles/.config/starship.toml ~/.config
ln -s ~/dotfiles/.config/ghostty ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config/
ln -s ~/dotfiles/.config/bat ~/.config/
ln -s ~/dotfiles/.config/zed/ ~/.config/
ln -s ~/dotfiles/.config/karabiner/ ~/.config/
```

## Architecture & Structure

### Core Configuration Files
- **Shell Environment**: 
  - `.config/zsh/.zshrc` - Main shell configuration with aliases, functions, and plugin loading
  - `.config/zsh/.zprofile` - Login shell configuration
  - Oh My Zsh plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions

- **Development Tools**:
  - **Neovim** (`.config/nvim/`): Lua-based configuration with lazy.nvim package manager
    - Entry: `init.lua` → loads config/{options,keymaps,autocmds} → config/lazy
    - Plugins in `lua/plugins/` including LSP, treesitter, telescope, completion
  - **Git** (`.config/git/config`): Configured with user info, LFS support, credential manager
  - **tmux** (`.config/tmux/tmux.conf`): Prefix `C-a`, vim navigation, toggle bottom pane with `t`

### macOS System Automation
`setup.sh` automates system preferences:
- Trackpad: 3-finger drag, maximum scroll speed
- Keyboard: Disabled auto-corrections, maximum key repeat
- Dock: Hidden menu bar, disabled hot corners
- Finder: Shows extensions, hidden files, path/status bars

### Theme Consistency
Tokyo Night theme applied across:
- Neovim colorscheme
- Ghostty terminal
- tmux status line
- bat syntax highlighting

## Development Workflow Notes

- **File Management**: Use symbolic links (not copies) to maintain single source of truth
- **Shell Customization**: `cd` command enhanced to auto-list files
- **Git Workflow**: Push default is current branch, case-sensitive file handling
- **Editor**: Neovim is the primary editor with full IDE features via LSP
- **Terminal Multiplexing**: tmux for session management with custom Tokyo Night styling

## Critical Paths
- Zsh history: `~/.config/zsh/.zsh_history`
- NVM directory: `~/.nvm`
- Claude Code: `~/.claude/local/claude`