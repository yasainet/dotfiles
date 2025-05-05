# Utils
alias ls='ls -G'
alias la='ls -laG'
alias f='find . -name'
alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias vi='nvim'
alias vim='nvim'
alias top='glances'
alias cat='bat'
alias code='zed'
alias C='pbcopy'

## tree
NODE_IGNORE='"node_modules|.next"'

alias treeJ='tree -J -I '"$NODE_IGNORE"' | jq'
alias treeJC='tree -J -I '"$NODE_IGNORE"' | jq | pbcopy'


# functions
cd() {
  builtin cd "$@" && la
}

rm() {
  local opts="-i"
  if [[ "$@" == *"-rf"* || "$@" == *"-fr"* ]]; then
    echo "⚠️ Are you sure?[y/N]"
    read answer
    if [[ ! "$answer" =~ ^[Yy] ]]; then
      echo "Canceled."
      return 1
    fi
  fi
  command rm $opts "$@"
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

pjA() {
  cd $HOME/Projects/asmr
}

# .zsh
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SAVEHIST=10000
export HISTSIZE=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY


# Oh My Zsh!
export ZSH="$HOME/.config/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
source "$ZSH/oh-my-zsh.sh"


# nvm, node, npm, npx
export NVM_DIR="$HOME/.nvm"
export NODE_NO_WARNINGS=1 # Disable Node.js warnings

export PATH="$HOME/.nvm/versions/node/v22.15.0/bin:$PATH" # v22.15.0

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  npx "$@"
}


# fzf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh


# Starship
eval "$(starship init zsh)"
