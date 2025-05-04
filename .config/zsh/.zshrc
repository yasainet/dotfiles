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
  cd $HOME/dotfiles
}

conf() {
  cd $HOME/.config
}

confZ() {
  cd $HOME/.config/zsh
}

confV(){
  cd $HOME/.config/nvim
}

drive() {
  cd "$HOME/Google Drive/My Drive"
}

pj() {
  cd $HOME/Projects
}

pjS() {
  cd $HOME/Projects/supaboards.com
}

# .zsh
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SAVEHIST=10000
export HISTSIZE=10000


# Oh My Zsh!
export ZSH="$HOME/.config/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"


# nvm, node, npm, npx
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

nvm use --lts &> /dev/null
export PATH="$NVM_DIR/versions/node/$(nvm current)/bin:$PATH"
export NODE_NO_WARNINGS=1 # Disable Node.js warnings


# fzf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh


# Starship
eval "$(starship init zsh)"
