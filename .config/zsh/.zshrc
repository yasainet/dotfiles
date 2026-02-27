# Path
export PATH="$HOME/.local/bin:$PATH"

# Terminal
if [[ "$OSTYPE" != "darwin"* ]] && ! infocmp "$TERM" &>/dev/null 2>&1; then
  export TERM=xterm-256color
fi

DISABLE_AUTO_TITLE="true"

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# Limits
ulimit -n 10240

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
export SAVEHIST=10000
export HISTSIZE=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# Oh My Zsh
export ZSH="$HOME/.config/.oh-my-zsh"
export ZSH_COMPDUMP="$ZDOTDIR/.zcompdump"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 30
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
zstyle ':omz:lib:compinit' cache-policy once-a-day
plugins=(gitfast zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
source "$ZSH/oh-my-zsh.sh"

# Prompt: Pure
fpath+=("$ZSH_CUSTOM/plugins/pure")
autoload -U promptinit; promptinit
prompt pure

# Truncate path to git repo root
_pure_truncate_to_repo() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$git_root" ]]; then
    local repo_name=${git_root:t}
    local relative=${PWD#$git_root}
    psvar[1]="${repo_name}${relative}"
  else
    psvar[1]="${(%):-%~}"
  fi
}
add-zsh-hook precmd _pure_truncate_to_repo
PROMPT="${PROMPT/\%~/%1v}"

# nvm (lazy load)
export NVM_DIR="$HOME/.nvm"
export NODE_NO_WARNINGS=1
if [[ -f "$NVM_DIR/alias/default" ]]; then
  _nvm_ver=$(cat "$NVM_DIR/alias/default")
  _nvm_dirs=("$NVM_DIR/versions/node/v${_nvm_ver}"*(N/))
  (( ${#_nvm_dirs} )) && export PATH="${_nvm_dirs[1]}/bin:$PATH"
  unset _nvm_ver _nvm_dirs
fi
_load_nvm() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
npx()  { _load_nvm; npx "$@"; }

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

# Toggle tmux popup with C-\
if [[ -n "$TMUX_POPUP" ]]; then
  stty quit undef
  _tmux_popup_close() { exit 0 }
  zle -N _tmux_popup_close
  bindkey '^\' _tmux_popup_close
fi

# OrbStack
[ -f ~/.orbstack/shell/init.zsh ] && source ~/.orbstack/shell/init.zsh

# direnv
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  eval "$(direnv hook zsh)"
fi
