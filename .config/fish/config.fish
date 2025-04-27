# fish
function fish_greeting; end

# Homebrew
if status is-interactive
  eval (/opt/homebrew/bin/brew shellenv)
end

# App
alias vi='nvim'
alias vim='nvim'
alias top='btop'
alias cat='bat'

# Git
alias ga='git add'
alias gcm='git commit -m'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gpl='git pull'
alias gps='git push'

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'

## Supabase
alias supareboot='supabase stop && supabase start && supabase db reset'

# Utils
alias C='pbcopy'

if not functions -q standard_cd
    functions --copy cd standard_cd
end

function cd
  standard_cd $argv; and la
end

function dot
  cd ~/dotfiles
end

function pj
  cd ~/Projects
end

# PATH
fish_add_path /opt/homebrew/bin
fish_add_path (npm prefix -g)/bin
fish_add_path /opt/homebrew/opt/openjdk/bin
fish_add_path $CARGO_HOME/bin

# $EDITOR
set -gx EDITOR nvim

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

# Node.js
# NOTE: Disable warnings
set -gx NODE_NO_WARNINGS 1

# Themes
fish_config theme choose "tokyonight_night"
