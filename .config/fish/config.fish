# fish
function fish_greeting; end

# Homebrew
if status is-interactive
  eval (/opt/homebrew/bin/brew shellenv)
end

# App
alias vi='nvim'
alias vim='nvim'
alias top='glances'
alias cat='bat'

# Git
alias ga='git add'
alias gcm='git commit -m'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gpl='git pull'
alias gps='git push'

# Docker
alias dc='docker-compose'
alias dps='docker ps'

# Yazi
alias ya='yazi'

# Check
function rm
  command rm -i $argv
end

function mv
  command mv -i $argv
end

# Utils
if not functions -q standard_cd
    functions --copy cd standard_cd
end

function cd
  standard_cd $argv; and la
end

function dot
  cd ~/dotfiles
end

# PATH
fish_add_path /opt/homebrew/bin
fish_add_path (npm prefix -g)/bin
fish_add_path $CARGO_HOME/bin

# $EDITOR
set -gx EDITOR vim

# nvm
if test -d ~/.nvm
    set -gx nvm_default_version lts
end

# Rust
set -gx RUSTUP_HOME $HOME/.rustup

# Cargo
set -gx CARGO_HOME $HOME/.cargo

# Starship
starship init fish | source
set -gx STARSHIP_CONFIG ~/.config/fish/starship.toml

# CodeCompanion
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

# Node.js
# NOTE: Disable warnings
set -gx NODE_NO_WARNINGS 1
