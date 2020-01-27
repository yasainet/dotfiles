export LAMG=en_US.UTF-8

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# alias

alias ls='ls -G'
alias la='ls -la'

alias mkdir='mkdir -p'

# cd したら ls を行う
chpwd() {
    if [[ $(pwd) != $HOME ]]; then;
        ls -la
    fi
}

# 色を使用する
autoload -Uz colors
colors

# ディレクトリ名だけで cd する
setopt auto_cd

# pwdc で pwd の結果をコピー
alias pwdc='pwd | tr -d "\n" | pbcopy'

autoload -Uz compinit
compinit

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug 'denysdovhan/spaceship-prompt', use:spaceship.zsh, from:github, as:theme
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-history-substring-search'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
# zplug 'chrissicool/zsh-256color'

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
