# dotfiles

Personal dotfiles for macOS and Linux.

## Setup

### macOS

```sh
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install ghq
ghq get --recursive https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
```

### Linux (Ubuntu)

```sh
sudo apt update && sudo apt install -y git ghq

ghq get --recursive https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh
```

## Memo

https://chromewebstore.google.com/detail/crx-gcal-url-opener/pjginhohpenlemfdcjbahjbhnpinfnlm
