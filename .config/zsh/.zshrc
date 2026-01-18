# Path
export PATH="$HOME/.local/bin:$PATH"

# Terminal
# if [[ "$OSTYPE" != "darwin"* ]] && ! infocmp "$TERM" &>/dev/null 2>&1; then
#   export TERM=xterm-256color
# fi

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# Aliases - Common
alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias cat='bat'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  alias ls='ls -G'
  alias la='ls -laG'
  alias C='pbcopy'
  alias sd='sudo shutdown -h now'
else
  # Linux
  alias ls='ls --color=auto'
  alias la='ls -la --color=auto'
  alias C='xclip -selection clipboard'
  alias bat='batcat'
fi

# tree
NODE_IGNORE='"node_modules|.next"'

# Functions
cd() {
  builtin cd "$@" && la
}

rm() {
  if [[ "$@" == *"-rf"* || "$@" == *"-fr"* ]]; then
    echo -n "Execute 'rm -rf'? [y/N]: "
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

# yazi
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Git
export GIT_MERGE_AUTOEDIT=no

# Less
export LESSHISTFILE=-

# PostgreSQL
export PSQL_HISTORY=/dev/null

# .zsh history
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SAVEHIST=10000
export HISTSIZE=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Oh My Zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ZSH="$HOME/.config/.oh-my-zsh"
  export ZSH_COMPDUMP="$ZDOTDIR/.zcompdump"
  plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
  source "$ZSH/oh-my-zsh.sh"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
export NODE_NO_WARNINGS=1
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Prompt - macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -n "$NVIM" ]; then
    export STARSHIP_CONFIG="$ZDOTDIR/starship-nvim.toml"
  else
    export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
  fi
  eval "$(starship init zsh)"
fi

# Prompt - Linux
if [[ "$OSTYPE" != "darwin"* ]]; then
  PS1='%F{blue}%B%~%b%f %F{green}❯%f '
fi

# fzf
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]] && PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
  [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
else
  # Linux
  [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
  [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
  [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
fi

# OrbStack
[ -f ~/.orbstack/shell/init.zsh ] && source ~/.orbstack/shell/init.zsh

# Local
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"
