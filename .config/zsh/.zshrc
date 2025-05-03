# Utils
alias ls='ls -G'
alias la='ls -laG'
alias vi='nvim'
alias vim='nvim'
alias top='glances'
alias cat='bat'
alias C='pbcopy'


# functions
cd() {
  builtin cd "$@" && la
}

dot() {
  cd ~/dotfiles
}

config() {
  cd ~/.config
}

pj() {
  cd ~/Projects
}

pjS() {
  cd ~/Projects/supaboards.com
}

# .zsh
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"


# Oh My Zsh!
export ZSH="$HOME/.config/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"


# Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

nvm use --lts > /dev/null # Disable initial message

export NODE_NO_WARNINGS=1 # Disable Node.js warnings


# fzf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh


# Starship
eval "$(starship init zsh)"
