# Initial Setup

## Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
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


## Font
```sh
brew install --cask font-plemol-jp
```


## dotfiles
```sh
git clone --recursive https://github.com/yasainet/dotfiles.git
```

```sh
rm -rf ~/.gitconfig
```

```sh
ln -s ~/dotfiles/.config/git/ ~/.config/git
```


## Zsh
```sh
ln -sf ~/dotfiles/.config/zsh/.zprofile ~/
```

```sh
ln -s ~/dotfiles/.config/zsh ~/.config/zsh
```

```sh
rm -rf .zsh_history .zsh_sessions
```


## Oh My Zsh!
```sh
ln -s ~/dotfiles/.config/.oh-my-zsh ~/.config/.oh-my-zsh
```


## Starship

```sh
brew install starship
```

```sh
ln -s ~/dotfiles/.config/starship.toml ~/.config
```

```sh
exec zsh
```


## Ghostty
```sh
brew install --cask ghostty
```

settings:
```sh
ln -s ~/dotfiles/.config/ghostty ~/.config
```


## Neovim
```sh
brew install neovim
```

settings:
```sh
ln -s ~/dotfiles/.config/nvim ~/.config/
```

```sh
rm -rf ~/.vim .viminfo
```


## Node.js

```sh
brew install node
```

```sh
brew install nvm
```

```sh
mkdir ~/.nvm
```

```sh
nvm install --lts
```

```sh
nvm alias default 'lts/*'
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


## Supabase CLI

```sh
brew install supabase/tap/supabase
```


## Vercel

```sh
npm i -g vercel
```


## ffmpeg

```sh
brew install ffmpeg
```


## tree

```sh
brew install tree
```


## jq

```sh
brew install jq
```


## glances

```sh
brew install glances
```


## uv

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
bat cache --build
```


### delta

```sh
brew install git-delta
```

settings:
```sh
ln -s ~/dotfiles/.config/delta ~/.config
```


## OpenCommit

```sh
npm install -g opencommit
```

```sh
ln -sf ~/dotfiles/Applications/OpenCommit/.opencommit ~/.opencommit
ln -sf ~/dotfiles/Applications/OpenCommit/.opencommit_migrations  ~/.opencommit_migrations
```


## Stripe CLI

```sh
brew install stripe-cli
```

```sh
stripe login
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


## Obsidian

```sh
brew install --cask obsidian
```


## Karabiner-Elements

```sh
brew install --cask karabiner-elements
```

settings:
```sh
ln -s ~/dotfiles/.config/karabiner/ ~/.config/
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

```sh
brew services start ollama
```


## DeepL

```sh
brew install --cask deepl
```


## macism

```sh
brew tap laishulu/homebrew
```

```sh
brew install macism
```


## Rectangle

```sh
brew install --cask rectangle
```


# Mac Setup

```sh
chmod +x ~/dotfiles/setup.sh
```


# Mouse

```sh
brew install --cask mos
```

```sh
brew install --cask logi-options+
```
