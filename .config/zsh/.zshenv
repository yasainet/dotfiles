export ZDOTDIR=$HOME/.config/zsh
export EDITOR=nvim
export VISUAL=nvim

# Local LLM host (llama-swap on MacBook-Pro-2023, via tailscale)
# opencode.json が {env:LLM_URL} で参照するため、非対話シェルでも必要
export LLM_URL="http://100.68.179.125:8080"

[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
