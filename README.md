# dotfiles

Personal dotfiles for macOS and Linux.

## Setup

### macOS

```sh
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install ghq
ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh

exex zsh
```

### Linux (Ubuntu)

```sh
sudo apt update && sudo apt install -y git

git clone https://github.com/yasainet/dotfiles ~/ghq/github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh

exec zsh
```

### Rename machine (macOS)

```sh
NEW="MACHINE_NAME" # Macbook-Pro-yyyy, Macbook-Air-yyyy
sudo scutil --set ComputerName  "$NEW"
sudo scutil --set LocalHostName "$NEW"
sudo scutil --set HostName      "$NEW"
dscacheutil -flushcache

# Check
scutil --get ComputerName
```

## Usage

### Sync ghq project .env files across machines

```sh
# Back up
./scripts/sync-envs.sh backup

# Restore
./scripts/sync-envs.sh restore
```
