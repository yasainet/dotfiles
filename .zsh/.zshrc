# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# deno
export DENO_INSTALL="/Users/yasainet/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# エイリアス
alias v='vim'
alias ls="gls --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"


# エイリアス: git
alias g='git'
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gct='git commit'
alias gg='git grep'
alias ga='git add'
alias gd='git diff'
alias gl='git log'


# git のカラー表示
git config --global color.ui auto

# dircolors
export PATH="/usr/local/Cellar/coreutils/9.3/libexec/gnubin:$PATH"
export LS_COLORS=$(dircolors)
test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

# Ctrl + D 防止
setopt IGNOREEOF

# ヒストリ (履歴) を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 同時に起動した zsh の間でヒストリを共有する
setopt share_history
 
# 直前と同じコマンドの場合はヒストリに追加しない
setopt hist_ignore_dups
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# キーバインディングを emacs 風にする
bindkey -d
bindkey -e

# [TAB]補完機能
autoload -Uz compinit && compinit

# [TAB]連続補完
zstyle ':completion:*:default' menu select=1

# 小文字入力時に大文字を含めた補完をする
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# ホームディレクトリ以外では、cd の後に ls -la を自動で行う。
chpwd() {
	if [[ $(pwd) != $HOME ]]; then;
		ls -la
	fi
}


### Added by Zinit's installer
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

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Ctrl + R でコマンド履歴の検索
zinit load zdharma-continuum/history-search-multi-word

# 入力補完
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

### ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
