# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Utils
alias ls='ls -G'
alias la='ls -laG'
alias f='find . -name'
alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias cat='bat'
alias C='pbcopy'

# tree
NODE_IGNORE='"node_modules|.next"'

alias treeJ='tree -J -I '"$NODE_IGNORE"' | jq'
alias treeJC='tree -J -I '"$NODE_IGNORE"' | jq | pbcopy'

# claude code
alias claude='~/.claude/local/claude'
alias cc='claude'
alias ccc='claude -c'
alias ccr='claude -r'

# functions
cd() {
  builtin cd "$@" && la
}

rm() {
  if [[ "$@" == *"-rf"* || "$@" == *"-fr"* ]]; then
    echo -n "⚠️  Execute 'rm -rf'? [y/N]: "
    read answer
    if [[ ! "$answer" =~ ^[Yy] ]]; then
      echo "Canceled."
      return 1
    fi
    command rm "$@"
  else
    command rm -i "$@"
  fi
}

dot() {
  cd $HOME/dotfiles
}

drive() {
  cd "$HOME/Google Drive/My Drive"
}

pj() {
  cd $HOME/Projects
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


# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
export NODE_NO_WARNINGS=1 # Disable Node.js warnings

# Load nvm and bash completion
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# fzf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh


# Starship
eval "$(starship init zsh)"

# Claude Code
export PATH="$HOME/.claude/local:$PATH"

# Docker CLI
fpath=(/Users/yasainet/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
