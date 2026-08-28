# Path
typeset -U path PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Darkbloom
[[ -d "$HOME/.darkbloom/bin" ]] && export PATH="$HOME/.darkbloom/bin:$PATH"

# Environment
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export GIT_MERGE_AUTOEDIT=no
export LESSHISTFILE=-
export NODE_NO_WARNINGS=1
if [[ "$OSTYPE" != "darwin"* ]] && ! infocmp "$TERM" &>/dev/null 2>&1; then
  export TERM=xterm-256color
fi

# Options
setopt AUTO_CD
ulimit -n 10240
bindkey -e

# History
export HISTFILE="$ZDOTDIR/.zsh_history"
export SAVEHIST=10000
export HISTSIZE=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# Aliases
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias cat='bat'
alias v='nvim'
alias vim='nvim'
alias lazyvim='NVIM_APPNAME=lazyvim nvim'
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  alias ls='ls -G'
  alias la='ls -laG'
  alias C='pbcopy'
else
  # Linux
  alias ls='ls --color=auto'
  alias la='ls -la --color=auto'
  alias C='xclip -selection clipboard'
  alias bat='batcat'
fi

# Functions
cd() {
  builtin cd "$@"
  [[ "$PWD" != "$HOME" ]] && la
}

# rm (macOS: trash / Linux: trash-cli)
rm() {
  local -a files
  local endopts=0 arg
  for arg in "$@"; do
    if ((!endopts)); then
      [[ "$arg" == "--" ]] && {
        endopts=1
        continue
      }
      [[ "$arg" == -* ]] && continue
    fi
    [[ -e "$arg" || -L "$arg" ]] || continue
    [[ "$arg" == -* ]] && arg="./$arg"
    files+=("$arg")
  done

  ((${#files})) || return 0
  trash "${files[@]}"
}

# ghq fzf
pj() {
  local repo dir
  repo=$(ghq list | fzf --height 40% --reverse --border --prompt='Repo> ') || return
  dir=$(ghq list -p --exact "$repo")
  cd "$dir"
}

# yazi
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
  command rm -f -- "$tmp"
}

# Completions
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  fpath=(/opt/homebrew/share/zsh-completions $fpath)
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
else
  # Linux
  [[ -d /usr/share/zsh-completions ]] && fpath=(/usr/share/zsh-completions $fpath)
  [[ -d $HOME/.local/share/zsh/plugins/zsh-completions/src ]] && fpath+=($HOME/.local/share/zsh/plugins/zsh-completions/src)
fi

# Generated completions
mkdir -p "$ZDOTDIR/completions"
for _tool in docker supabase; do
  if command -v "$_tool" &>/dev/null && [[ ! -f "$ZDOTDIR/completions/_$_tool" ]]; then
    "$_tool" completion zsh >"$ZDOTDIR/completions/_$_tool"
  fi
done
unset _tool
fpath=("$ZDOTDIR/completions" $fpath)

# compinit
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR}/.zcompdump"
_compinit_flags=(-d "$ZSH_COMPDUMP")
[[ "$OSTYPE" == "darwin"* ]] && _compinit_flags+=(-u)
if [[ -n $ZSH_COMPDUMP(#qN.mh+24) ]] || [[ ! -f "$ZSH_COMPDUMP" ]]; then
  compinit "${_compinit_flags[@]}"
else
  compinit -C "${_compinit_flags[@]}"
fi
unset _compinit_flags

# nvm (lazy load)
export NVM_DIR="$HOME/.nvm"
if [[ -f "$NVM_DIR/alias/default" ]]; then
  _nvm_ver=$(cat "$NVM_DIR/alias/default")
  _nvm_dirs=("$NVM_DIR/versions/node/v${_nvm_ver}"*(N/))
  ((${#_nvm_dirs})) && export PATH="${_nvm_dirs[1]}/bin:$PATH"
  unset _nvm_ver _nvm_dirs
fi
_load_nvm() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() {
  _load_nvm
  nvm "$@"
}
node() {
  _load_nvm
  node "$@"
}
npm() {
  _load_nvm
  npm "$@"
}
npx() {
  _load_nvm
  npx "$@"
}

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
[ -f ~/.config/fzf/themes/tokyonight_night.sh ] && source ~/.config/fzf/themes/tokyonight_night.sh

# direnv
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  eval "$(direnv hook zsh)"
fi

# mise
if [[ "$OSTYPE" == "darwin"* ]] && command -v mise &>/dev/null; then
  # macOS
  eval "$(mise activate zsh)"
fi

# Prompt: Pure
if [[ "$OSTYPE" != "darwin"* ]]; then
  # Linux
  [[ -d $HOME/.local/share/zsh/plugins/pure ]] && fpath+=($HOME/.local/share/zsh/plugins/pure)
  export PROMPT_PURE_SSH_CONNECTION=1
fi
autoload -U promptinit
promptinit
prompt pure

# Plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  # Linux
  [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Local (not tracked)
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"
