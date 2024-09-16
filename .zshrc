# 言語設定
export LANG=ja_JP.UTF-8

# 補完機能強化
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# ヒストリ設定
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt extended_history
setopt hist_reduce_blanks

# その他設定
zstyle ':completion:*' menu select
setopt auto_cd
setopt correct
setopt extended_glob
unsetopt case_glob

# dircolors
test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)

# エイリアス設定
alias top='glances'
alias cat='bat'
alias ll='ls -la'
alias grep='grep --color=auto'
alias ls='gls --color=auto'

# tree
tree() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_root=$(git rev-parse --show-toplevel)
    if [ -n "$git_root" ]; then
      # 現在のディレクトリからGitルートまでの相対パスを取得
      if [ "$PWD" = "$git_root" ]; then
        relative_path=""
      else
        relative_path="${PWD#$git_root/}"
      fi
      # .gitignore に無視されていないファイルリストを取得
      git ls-files --cached --others --exclude-standard --directory "$relative_path" > /tmp/git-ls-files.txt
      current_dir_name=$(basename "$PWD")
      # tree を実行（ディレクトリを変更しない）
      command tree --fromfile /tmp/git-ls-files.txt "$@" | sed "1s|^.*|$current_dir_name|"
      rm /tmp/git-ls-files.txt
    else
      command tree "$@"
    fi
  else
    command tree "$@"
  fi
}

# Git エイリアス
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gpl='git pull'
alias gps='git push'

# Docker エイリアス
alias dc='docker-compose'
alias dps='docker ps'

# cd した後に ls -la を実行する
chpwd() {
  if [[ $(pwd) != $HOME ]]; then
    ls -la
  fi
}

# クリップボードにコピー
clipcopy() {
  if [ $# -eq 0 ]; then
    pbcopy < /dev/stdin
  else
    command pbcopy < "$1"
  fi
}

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

zinit light zdharma-continuum/zinit
zinit ice depth=1
zinit snippet OMZ::lib/completion.zsh

# Zinit Plugins
zinit load zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-completions
zinit load romkatv/powerlevel10k
zinit load zsh-users/zsh-history-substring-search

### Zinit's installer chunk
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
      print -P "%F{33} %F{34}Installation successful.%f%b" || \
      print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load important annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Powerlevel10k configuration
[[ ! -f ~/dotfiles/.zsh/.p10k.zsh ]] || source ~/dotfiles/.zsh/.p10k.zsh

# Java設定
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# JAVA_HOME設定
export JAVA_HOME=$(/usr/libexec/java_home -v 22)

# nvm設定
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Google Cloud SDK設定
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# POWERLEVEL9K_DIR_CONTENT_EXPANSIONの設定
typeset -g POWERLEVEL9K_DIR_CONTENT_EXPANSION='$(custom_dir_path)'
