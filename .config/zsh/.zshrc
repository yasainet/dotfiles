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
  find ~ -maxdepth 1 -name "* - Google Drive" -type l -delete 2>/dev/null # Delete Google Drive Symlink
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
  cd "$HOME/Google Drive"
}

pj() {
  cd $HOME/Projects
}

eslint() {
  cd $HOME/Projects/eslint
}

# Local LLM (llama-swap + llama.cpp)
llm-fetch() {
  local m repo file subdir
  for m in \
    "unsloth/Qwen3.6-35B-A3B-GGUF Qwen3.6-35B-A3B-Q8_0.gguf Qwen3.6-35B-A3B" \
    "unsloth/Qwen3.6-35B-A3B-GGUF mmproj-F16.gguf Qwen3.6-35B-A3B" \
    "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive" \
    "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive mmproj-Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-f16.gguf Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive"; do
    read repo file subdir <<< "$m"
    curl -L -C - --retry 1000 --retry-delay 3 --retry-all-errors --speed-limit 500000 --speed-time 30 \
      --create-dirs -o "$HOME/models/$subdir/$file" "https://huggingface.co/$repo/resolve/main/$file"
  done
}

llm-serve() {
  llama-swap --config "$HOME/.config/llama-swap/config.yaml" --listen :8080 "$@"
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

# Git
export GIT_MERGE_AUTOEDIT=no

# Less
export LESSHISTFILE=-

# psql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# .zsh history
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SAVEHIST=1000
export HISTSIZE=1000
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# Completions
if [[ "$OSTYPE" == "darwin"* ]]; then
  fpath=(/opt/homebrew/share/zsh-completions $fpath)
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
else
  [[ -d /usr/share/zsh-completions ]] && fpath=(/usr/share/zsh-completions $fpath)
  [[ -d $HOME/.local/share/zsh/plugins/zsh-completions/src ]] && fpath+=($HOME/.local/share/zsh/plugins/zsh-completions/src)
fi

# Docker
if command -v docker &>/dev/null; then
  mkdir -p "$ZDOTDIR/completions"
  [[ ! -f "$ZDOTDIR/completions/_docker" ]] && docker completion zsh > "$ZDOTDIR/completions/_docker"
  fpath=("$ZDOTDIR/completions" $fpath)
fi

# compinit
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR}/.zcompdump"
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]] || [[ ! -f "$ZSH_COMPDUMP" ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# Prompt: Pure
if [[ "$OSTYPE" != "darwin"* ]]; then
  [[ -d $HOME/.local/share/zsh/plugins/pure ]] && fpath+=($HOME/.local/share/zsh/plugins/pure)
  export PROMPT_PURE_SSH_CONNECTION=1
fi
autoload -U promptinit; promptinit
prompt pure

# Plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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

# OrbStack
[ -f ~/.orbstack/shell/init.zsh ] && source ~/.orbstack/shell/init.zsh

# direnv
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  eval "$(direnv hook zsh)"
fi

# mise (Ruby etc.)
if [[ "$OSTYPE" == "darwin"* ]] && command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

