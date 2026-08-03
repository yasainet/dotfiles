export ZDOTDIR=$HOME/.config/zsh
export EDITOR=nvim
export VISUAL=nvim

# Local LLM host
export LLM_URL="http://100.68.179.125:8080"

[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
