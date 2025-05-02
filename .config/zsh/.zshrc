# Oh My Zsh!
export ZSH="$HOME/.config/.oh-my-zsh"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# export
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"

# Starship
eval "$(starship init zsh)"
