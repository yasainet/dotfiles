# Setup
- `chmod +x setup.sh`

## Homebrew
1. インストール:
- `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. PATH:
- `echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/yasainet/.zprofile`
- `eval "$(/opt/homebrew/bin/brew shellenv)"`
3. 確認:
- `brew --version`

## Git
- `brew install git`
- `git config --global user.name "yasainet"`
- `git config --global user.email "takumi.mizoguchi@gmail.com"`

### 便利設定
- `git config --global push.default current`
- `git config --global color.ui auto`
- `git config --global diff.tool vimdiff` # `git difftool --no-prompt <filename>` で利用できる

- `vim ~/.gitconfig`
```
[diff]
	tool = vimdiff
[difftool]
  prompt = false
```

### Git Credential Manager（GCM）
- `brew tap microsoft/git`
- `brew install --cask git-credential-manager-core`
- `git config --global credential.helper manager-core`

確認（option）:
- `git config --global -l`

## .dotfiles
- `git clone https://github.com/yasainet/dotfiles.git`

### シンボリックリンク
- `ln -s ~/dotfiles/.vimrc ~/`
- `ln -s ~/dotfiles/.vim ~/`
- `ln -s ~/dotfiles/.zshrc ~/`

## Terminal.app
### font: Sarasa-Gothic
- `brew install --cask font-sarasa-gothic`
- `Sarasa Mono J`

### vim-plug
1. ダウンロード
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

2. `:PlugInstall`

### p10k
- `p10k configure`

## dircolors
- `cd dotfiles`
- `git clone https://github.com/nordtheme/dircolors`
- `ln -sr ~/dotfiles/src/dir_colors" ~/.dir_colors`
- `vim ~/.zshrc`
```
test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)
```
- `brew install coreutils`

## Nord.js
- `brew install node`

## nvm（Node Version Manager）
- `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`
- `source ~/.nvm/nvm.sh`

- `nvm install --lts` (option)

## Java
- `brew install openjdk`
- `sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk`


# Tools
## Google Cloud SDK
- `brew install --cask google-cloud-sdk`
- `vim ~/.zshrc`
```
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
```

## Github CLI
- `brew install gh`
- `gh auth login`

## Miniconda
- `brew install --cask miniconda`

## clasp
- `npm i @google/clasp -g`

## ffmpeg
- `brew install ffmpeg`

## tree
- `brew install tree`

## ./jq
- `brew install jq`

## Glances
- `brew install glances`

## OpenCommit
- `npm install -g opencommit`
- `oco config set OCO_OPENAI_API_KEY=<your_api_key>`

## Stripe CLI
- `brew install stripe/stripe-cli/stripe`
- `stripe login`

# Application
## mas-cli
- `brew install mas`

## LINE
- `mas install 539883307`

## Github Desktop
- `brew install --cask github`

## Google Chrome
- `brew install --cask google-chrome`

## Google 日本語
- `brew install google-japanese-ime`

## Google Drive
- `brew install --cask google-drive`

## AppCleaner
- `brew install --cask appcleaner`

## CleanShot X
- `brew install --cask cleanshot`

## Docker
- `brew install --cask docker`

## Zed
- `brew install --cask zed`

## Slack
- `brew install --cask slack`

## Discord
- `brew install --cask discord`

## Proton VPN
- `brew install --cask protonvpn`

## UTM
- `brew install --cask utm`

## Tor
- `brew install --cask tor-browser`

## KeyboardCleanTool
- `brew install --cask keyboardcleantool`

## Karabiner-Elements
- `brew install --cask karabiner-elements`

## The Unarchiver
- `brew install --cask the-unarchiver`


# その他
## ~/Downloads
- `sudo rm -rf Downloads`
- `ln -s ~/Google\ Drive/My\ Drive/Downloads ~/Downloads`
