# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## 1. Environment

- **OS**: macOS (primary), Linux (secondary)
- **Terminal**: Ghostty
- **Shell**: Zsh + Oh My Zsh + Starship
- **Editor**: Neovim (LazyVim based)
- **Multiplexer**: tmux
- **File Manager**: Yazi

---

## 2. Important Rules

1. **ALWAYS read existing config files first** before suggesting any changes
2. **Use web search** to check for latest best practices and updates
3. **Combine both** - understand the current setup AND latest information before proposing solutions

---

## 3. Directory Structure

```tree
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
