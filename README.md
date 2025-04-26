# Initial Setup
## Homebrew
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Git
```sh
brew install git
```

### Github CLI
```sh
brew install gh
```

```sh
gh auth login
```

### Git Credential Manager（GCM）
```sh
brew tap microsoft/git
```

```sh
brew install --cask git-credential-manager-core
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

settings:
```sh
ln -s ~/dotfiles/.config/ghostty ~/.config
```

# fish
```sh
brew install fish
```

settings:
```sh
sudo vim /etc/shells

+ /opt/homebrew/bin/fish
```

```sh
chsh -s /opt/homebrew/bin/fish
```

```sh
ln -s ~/dotfiles/.config/fish ~/.config/
```

## fisher
```sh
brew install fisher
```

# Neovim
```sh
brew install neovim
```

settings:
```sh
ln -s ~/dotfiles/.config/nvim ~/.config/
```

## nvm（Node Version Manager）
```sh
brew install nvm
```

```sh
brew install nvmfish/nvmfish/nvm.fish
```

```sh
fisher install jorgebucaran/nvm.fish
```

## Node.js
```sh
nvm install lts
```

settings:
```sh
nvm use lts
```

## Java
```sh
brew install openjdk
```

settings:
```sh
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
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

settings:
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

settings:
```sh
ln -s ~/dotfiles/.config/bat ~/.config/
```

```sh
cd ~/dotfiles/.config/bat/themes

```sh
curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
```

```sh
bat cache --build
```

```sh
vim ~/.config/bat/config
```

```sh
+ --plain
+ --theme="tokyonight_night"
```

### delta
```sh
brew install git-delta
```

settings:
```sh
rm -rf ~/delta
```

```sh
ln -s ~/dotfiles/.config/delta ~/.config
```

## OpenCommit
```sh
npm install -g opencommit
```

```sh
oco config set OCO_API_KEY=<your_api_key>
```

## Stripe CLI
```sh
brew install stripe-cli
```

```sh
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

## Google Drive
```sh
brew install --cask google-drive
```

## Zed
```sh
brew install --cask zed
```

settings:
```sh
ln -s ~/dotfiles/.config/zed/ ~/.config/
```

## Karabiner-Elements
```sh
brew install --cask karabiner-elements
```

settings:
```sh
ln -s ~/dotfiles/.config/karabiner/ ~/.config/
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
```

```sh
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
