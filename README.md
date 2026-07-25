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

`ghq` は apt に無いため、`install.sh` が release binary を `~/.local/bin` に入れる。
初回だけ `git clone` で ghq のディレクトリ構成に合わせて配置する。

```sh
sudo apt update && sudo apt install -y git

git clone https://github.com/yasainet/dotfiles ~/ghq/github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
```

`install.sh` は `chsh` で zsh を default shell にする。反映には再ログインが必要。

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
# Old machine: back up
./scripts/sync-envs.sh backup

# New machine: `ghq get` the projects first, then restore
./scripts/sync-envs.sh restore
```
