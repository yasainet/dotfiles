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
```

### Linux (Ubuntu)

```sh
sudo apt update && sudo apt install -y git ghq

ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
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

`.env*` files under `~/ghq/**` are not tracked by git.
The helper script mirrors them through iCloud Drive.

```sh
# Old machine: back up
./scripts/sync-envs.sh backup

# New machine: `ghq get` the projects first, then restore
./scripts/sync-envs.sh restore
```

Destination: `~/Library/Mobile Documents/com~apple~CloudDocs/Documents/.envs/`
