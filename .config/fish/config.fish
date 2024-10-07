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

# Check
function rm
  command rm -i $argv
end

function mv
  command mv -i $argv
end

function cp
  command cp -i $argv
end

# Git
function ga
  git add $argv
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

# PATH
fish_add_path /opt/homebrew/bin

set -gx RUSTUP_HOME $HOME/.rustup
set -gx CARGO_HOME $HOME/.cargo
fish_add_path $CARGO_HOME/bin

# Optional
function oco
    env NODE_NO_WARNINGS=1 command oco $argv
end
