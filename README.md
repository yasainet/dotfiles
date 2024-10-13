# Initial Setup
## Homebrew
1. インストール:
```sh
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. 確認:
```sh
brew --version
```

## Git
```sh
brew install git
```

### Github CLI
```sh
brew install gh
gh auth login
```

### Git Credential Manager（GCM）
```sh
brew tap microsoft/git
brew install --cask git-credential-manager-core
```

確認:
```sh
git config --global -l
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

# Font
```sh
brew install --cask font-zed-mono-nerd-font
brew install --cask font-blex-mono-nerd-font
```

# dotfiles
```sh
git clone https://github.com/yasainet/dotfiles.git
```

# Hyper
```sh
brew install --cask hyper
```

設定:
```sh
ln -s ~/dotfiles/.hyper.js ~/
ln -s ~/dotfiles/.hyper_plugins ~/
```

# fish
```sh
brew install fish
```

追加:
```sh
sudo vim /etc/shells
```

```sh
/opt/homebrew/bin/fish
```

設定:
```sh
ln -s ~/dotfiles/.config/fish ~/.config/
```

確認:
```sh
echo $SHELL
```

## fisher
```sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

# Neovim
```sh
brew install neovim
```

設定:
```sh
ln -s ~/dotfiles/.config/nvim ~/.config/
```

# Library
## Google Cloud SDK
```sh
brew install --cask google-cloud-sdk
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

設定:
```sh
ln -s ~/dotfiles/.config/bat ~/.config/
bat cache --build
vim ~/.config/bat/config
```

```
--theme="Catppuccin Macchiato"
--plain
```

### delta
```sh
brew install git-delta
```

設定:
```sh
ln -s ~/dotfiles/delta ~/
```

## OpenCommit
```sh
npm install -g opencommit
oco config set OCO_API_KEY=<your_api_key>
```

optional:
`/usr/local/bin` に PATH が通っていないときの対処方法
```sh
sudo ln -s ~/.nvm/versions/node/v20.17.0/bin/oco /usr/local/bin/oco
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

## Xcode
```sh
mas install 497799835
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
```

設定:
```sh
ln -sf ~/Google\ Drive/My\ Drive/Downloads ~/Downloads
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
```

設定:
```sh
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
