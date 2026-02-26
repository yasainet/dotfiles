# dotfiles

Personal dotfiles for macOS and Linux.

## Setup

### macOS

```sh
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

git clone --recursive https://github.com/yasainet/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Linux (Ubuntu)

```sh
sudo apt update && sudo apt install -y git

git clone --recursive https://github.com/yasainet/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Commands

```typescript
export const commands = {
  install: "Install dotfiles",
  update: "Update dotfiles",
  backup: "Backup current dotfiles",
  restore: "Restore dotfiles from backup",
};
```
