# Settings
function fish_greeting; end

if status is-interactive
  eval (/opt/homebrew/bin/brew shellenv)
end

# App
function vi
  nvim $argv
end

function vim
  nvim $argv
end

function top
  glances $argv
end

function cat
  bat $argv
end

# Git
function ga
  git add $argv
end

function gcm
  git commit -m $argv
end

function gb
  git branch $argv
end

function gst
  git status $argv
end

function gco
  git checkout $argv
end

function gpl
  git pull $argv
end

function gps
  git push $argv
end

# Docker
function dc
  docker-compose $argv
end

function dps
  docker ps $argv
end

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

# PATH
fish_add_path /opt/homebrew/bin
fish_add_path (npm prefix -g)/bin
fish_add_path $CARGO_HOME/bin

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
