# Initial Setup
## Homebrew
1. インストール:
```sh
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. PATH:
```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/yasainet/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```
3. 確認:
```sh
brew --version
```

## Git
```sh
brew install git

git config --global user.name "yasainet"
git config --global user.email "takumi.mizoguchi@gmail.com"
git config --global color.ui auto
git config --global push.default current
```

## Github CLI
```sh
brew install gh
gh auth login
```

## Git Credential Manager（GCM）
```sh
brew tap microsoft/git
brew install --cask git-credential-manager-core
```

## delta
```sh
brew install git-delta
```

確認:
```sh
git config --global -l
```

```ini
[user]
    name = yasainet
    email = takumi.mizoguchi@gmail.com
[credential]
    helper = /usr/local/share/gcm-core/git-credential-manager
[credential "https://dev.azure.com"]
    useHttpPath = true
[color]
    ui = auto
[push]
    default = current
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    features = Nord
    syntax-theme = Nord
    navigate = true # use n and N to move between diff sections
    dark = true
    side-by-side = true
    line-numbers = true
[merge]
    conflictstyle = diff3
[diff]
    colorMoved = default
```

# Terminal
## dotfiles
```sh
git clone https://github.com/yasainet/dotfiles.git
```

## Setup
```sh
ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.zshrc ~/
```

## font
```sh
brew install --cask font-zed-mono-nerd-font
```

## vim-plug
```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## dircolors
```sh
brew install coreutils

git clone https://github.com/nordtheme/dircolors ~/dotfiles
ln -s ~/dotfiles/dircolors/src/dir_colors ~/.dir_colors
```

## p10k
```sh
p10k configure
```

# Hyper
```sh
brew install --cask hyper
```

# Neovim
```sh
brew install neovim
```

# Library
## Google Cloud SDK
```sh
brew install --cask google-cloud-sdk
```

## Nord.js
```sh
brew install node
```

## nvm（Node Version Manager）
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh

nvm install --lts # option
```

## Java
```sh
brew install openjdk
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```

## Miniconda
```sh
brew install --cask miniconda
```

## Firebase
```sh
npm install firebase
```

## Firebase CLI
```sh
npm install -g firebase-tools
```

## Firebase Admin SDK
```sh
npm install firebase-admin
```

## Firebase Functions
```sh
npm install firebase-functions
```

## clasp
```sh
npm i @google/clasp -g
```

## ffmpeg
```sh
brew install ffmpeg
```

## tree
```sh
brew install tree
```

## ./jq
```sh
brew install jq
```

## Glances
```sh
brew install glances
```

## bat
```sh
brew install bat
```

```sh
bat --config-file
```

```sh
mkdir -p ~/.config/bat/themes

wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

bat cache --build

bat --list-themes
```

```sh
nvim ~/.config/bat/config
```

```ini
--theme="Catppuccin Mocha"
--plain
```

## OpenCommit
```sh
npm install -g opencommit
oco config set OCO_API_KEY=<your_api_key>
```

## Stripe CLI
```sh
brew install stripe-cli
stripe login
```

# Application
## mas-cli
```sh
brew install mas
```

## LINE
```sh
mas install 539883307
```

## Paste
```sh
mas install 967805235
```

## Github Desktop
```sh
brew install --cask github
```

## Google Chrome
```sh
brew install --cask google-chrome
```

## Google 日本語入力
```sh
sudo softwareupdate --install-rosetta
brew install google-japanese-ime

sudo reboot
```

## Google Drive
```sh
brew install --cask google-drive

sudo rm -rf Downloads
ln -s ~/Google\ Drive/My\ Drive/Downloads ~/Downloads
```

## AppCleaner
```sh
brew install --cask appcleaner
```

## Rectangle
```sh
brew install --cask rectangle
```

## CleanShot X
```sh
brew install --cask cleanshot
```

## Docker
```sh
brew install --cask docker
```

## Zed
```sh
brew install --cask zed

ln -s ~/dotfiles/.config/zed/keymap.json ~/.config/zed
ln -s ~/dotfiles/.config/zed/settings.json ~/.config/zed
```

## Slack
```sh
brew install --cask slack
```

## Discord
```sh
brew install --cask discord
```

## Proton VPN
```sh
brew install --cask protonvpn
```

## Tor
```sh
brew install --cask tor-browser
```

## Transmission
```sh
brew install --cask transmission
```

## KeyboardCleanTool
```sh
brew install --cask keyboardcleantool
```

## Karabiner-Elements
```sh
brew install --cask karabiner-elements
```

## The Unarchiver
```sh
brew install --cask the-unarchiver
```

## Ollama
```sh
brew install ollama
```

## DeepL
```sh
brew install --cask deepl
```

# Mac Setup
```sh
chmod +x ~/dotfiles/setup.sh
```
