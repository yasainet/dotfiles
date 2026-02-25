# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Environment

- **OS**: macOS (primary), Linux (secondary)
- **Terminal**: Ghostty
- **Shell**: Zsh + Oh My Zsh + Starship
- **Editor**: Neovim (LazyVim based)
- **Multiplexer**: tmux
- **File Manager**: Yazi

## Directory Structure

```
.
├── .claude/          # Claude Code
├── .config/
│   ├── .oh-my-zsh/   # Oh My Zsh (submodule)
│   ├── bat/          # bat
│   ├── fzf/          # fzf
│   ├── gh/           # GitHub CLI
│   ├── ghostty/      # Ghostty terminal
│   ├── git/          # Git config
│   ├── github-copilot/ # GitHub Copilot
│   ├── karabiner/    # Karabiner-Elements
│   ├── lazygit/      # lazygit
│   ├── nvim/         # Neovim
│   ├── tmux/         # tmux
│   ├── yazi/         # Yazi file manager
│   └── zsh/          # Zsh + Starship
├── claude-code/      # Claude Code global config
├── extras/
│   └── vimium/       # Vimium config
├── scripts/
│   ├── common.sh     # Common setup
│   ├── darwin.sh     # macOS setup
│   └── linux.sh      # Linux setup
└── install.sh        # Entry point
```
