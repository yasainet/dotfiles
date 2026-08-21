export ZDOTDIR=$HOME/.config/zsh
export EDITOR=nvim
export VISUAL=nvim

# rainfrog
export RAINFROG_CONFIG="$HOME/.config/rainfrog"

# OrbStack
[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# Local LLM host
export LLM_URL="http://100.101.211.10:8080"
