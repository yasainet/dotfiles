# dotfiles

Personal dotfiles for macOS and Linux.

## 1. Setup

### 1.1 macOS

```sh
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

git clone --recursive https://github.com/yasainet/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### 1.2 Linux (Ubuntu)

```sh
sudo apt update && sudo apt install -y git

git clone --recursive https://github.com/yasainet/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```
