# Initial Setup
## Homebrew
1. インストール:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
brew install nvm
```

設定:
```sh
nvm install --lts
nvm use lts
```

## Java
```sh
brew install openjdk
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```

# Font
```sh
brew install --cask font-plemol-jp
```

# dotfiles
```sh
git clone https://github.com/yasainet/dotfiles.git
```

# Ghostty
```sh
brew install --cask ghostty
```

設定:
```sh
ln -s ~/dotfiles/.config/ghostty ~/.config
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
chsh -s /opt/homebrew/bin/fish
ln -s ~/dotfiles/.config/fish ~/.config/
```

確認:
```sh
echo $SHELL
```

## fisher
```sh
brew install fisher
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

## CloudFlare
```sh
brew install cloudflared
```

## ngrok
```sh
brew install --cask ngrok
```

## Miniconda
```sh
brew install --cask miniconda
```

## Firebase CLI
```sh
npm install -g firebase-tools
```

## Vercel
```sh
npm i -g vercel
```

## clasp
```sh
npm install -g @google/clasp
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

## btop
```sh
brew install btop
```

設定:
```sh
ln -s ~/dotfiles/.config/btop ~/.config
```

## Un
```sh
brew install uv
```

## bat
```sh
brew install bat
```

設定:
```sh
ln -s ~/dotfiles/.config/bat ~/.config/
```

```sh
cd ~/dotfiles/.config/bat/themes

curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build
```

```sh
vim ~/.config/bat/config
```

```config
--plain
--theme="tokyonight_night"
```

### delta
```sh
brew install git-delta
```

設定:
```sh
mv ~/delta ~/dotflies/delta
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

## libsodium
```sh
brew install libsodium
```

## fzf
```sh
brew install fzf
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
ln -s ~/dotfiles/.config/zed/ ~/.config/
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

## Telegram
```sh
brew install --cask telegram
```

## KeyboardCleanTool
```sh
brew install --cask keyboardcleantool
```

## Karabiner-Elements
```sh
brew install --cask karabiner-elements
```

設定:
```sh
ln -s ~/dotfiles/.config/karabiner/ ~/.config/
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

## brew macism
```sh
brew tap laishulu/homebrew
brew install macism
```

# Mac Setup
```sh
chmod +x ~/dotfiles/setup.sh
```

# Logicool

## MX Master 3S
```sh
brew install --cask logi-options+
```

## Mos
```sh
brew install --cask mos
```
