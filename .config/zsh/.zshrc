# Path
export PATH="$HOME/.local/bin:$PATH"

# Terminal
if [[ "$OSTYPE" != "darwin"* ]] && ! infocmp "$TERM" &>/dev/null 2>&1; then
  export TERM=xterm-256color
fi

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# Emacs
bindkey -e

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
alias sudo='sudo '

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
  builtin cd "$@"
  [[ "$PWD" != "$HOME" ]] && la
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

doc() {
  cd $HOME/Documents
}

drive() {
  cd "$HOME/Google Drive/My Drive"
}

pj() {
  cd $HOME/Projects
}

# claude
claude() {
  if [ -n "$TMUX" ]; then
    tmux rename-window "claude"
  fi
  command claude "$@"
  if [ -n "$TMUX" ]; then
    tmux set-window-option automatic-rename on
  fi
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

# lazygit
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/tokyonight_night.yml"

# Less
export LESSHISTFILE=-

# .zsh history
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SAVEHIST=1000
export HISTSIZE=1000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Oh My Zsh - macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ZSH="$HOME/.config/.oh-my-zsh"
  export ZSH_COMPDUMP="$ZDOTDIR/.zcompdump"
  plugins=(gitfast zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
  source "$ZSH/oh-my-zsh.sh"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
export NODE_NO_WARNINGS=1
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Prompt
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  if [ -n "$NVIM" ]; then
    export STARSHIP_CONFIG="$ZDOTDIR/starship-nvim.toml"
  else
    export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
  fi
  eval "$(starship init zsh)"
else
  # Linux
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
bindkey -r '^T'  # Disable: Ctrl+t

# OrbStack
[ -f ~/.orbstack/shell/init.zsh ] && source ~/.orbstack/shell/init.zsh
