# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Overview

Personal dotfiles for macOS and Linux.

## Environment

- **OS**: macOS (primary), Linux (secondary)
- **Terminal**: Ghostty
- **Shell**: Zsh + Oh My Zsh + Starship
- **Editor**: Neovim (LazyVim based)
- **Multiplexer**: tmux
- **File Manager**: Yazi

## Important Rules

### Before Making Changes

1. **ALWAYS read existing config files first** before suggesting any changes
2. **Use web search** to check for latest best practices and updates
3. **Combine both** - understand the current setup AND latest information before proposing solutions

## Directory Structure

```tree
.
├── .claude/          # Claude Code
├── .config/
│   ├── .oh-my-zsh/   # Oh My Zsh (submodule)
│   ├── bat/          # bat
│   ├── fzf/          # fzf
│   ├── gh/           # GitHub CLI
│   ├── ghostty/      # Ghostty terminal
│   ├── karabiner/    # Karabiner-Elements
│   ├── nvim/         # Neovim
│   ├── tmux/         # tmux
│   ├── yazi/         # Yazi file manager
│   ├── zed/          # Zed editor
│   └── zsh/          # Zsh + Starship
├── .ssh/             # SSH config
├── extras/
│   └── vimium/       # Vimium config
├── scripts/
│   ├── common.sh     # Common setup
│   ├── darwin.sh     # macOS setup
│   └── linux.sh      # Linux setup
└── install.sh        # Entry point
```
