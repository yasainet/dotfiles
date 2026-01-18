# dotfiles

Personal dotfiles for macOS and Linux.

## Setup

### macOS

```bash
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

git clone --recursive https://github.com/yasainet/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Linux (Ubuntu)

```bash
sudo apt update && sudo apt install -y git

git clone --recursive https://github.com/yasainet/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```
