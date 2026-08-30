# dotfiles

Personal dotfiles for macOS and Linux.

## Setup

### macOS

```sh
# Xcode
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install
brew install ghq
ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles

# Full
./install.sh

# LLM
DOTFILES_PROFILE=llm ./install.sh

# Reload shell
exec zsh
```

### Linux (Ubuntu)

```sh
sudo apt update && sudo apt install -y git

git clone https://github.com/yasainet/dotfiles ~/ghq/github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
./install.sh

# Reload shell
exec zsh
```

## Commands

### Backup and Restore of .env files in ghq projects

```sh
# Backup
./scripts/sync/envs.sh backup

# Restore
./scripts/sync/envs.sh restore
```

### Rename machine (macOS)

```sh
NEW="<MACHINE_NAME>" # Macbook-Pro-yyyy, Macbook-Air-yyyy
sudo scutil --set ComputerName  "$NEW"
sudo scutil --set LocalHostName "$NEW"
sudo scutil --set HostName      "$NEW"
dscacheutil -flushcache

# Check
scutil --get ComputerName
```

### Brave via Mullvad (macOS)

Brave is forced (configuration profile, mandatory policy) to use a local SOCKS5
proxy served by wireproxy, a userspace WireGuard client connected to Mullvad.
Other apps are unaffected. If wireproxy is down, Brave cannot connect (fail-closed).

```sh
# 1. Approve the profile opened by install.sh:
#    System Settings > General > Device Management > "Brave via Mullvad" > Install
#    (re-open with: open .config/brave/net.mullvad.brave-proxy.mobileconfig)

# 2. Download a WireGuard config from https://mullvad.net/account
#    (WireGuard configuration -> Linux, no multihop) and place it as:
#    ~/.local/share/wireproxy/mullvad.conf

# 3. Restart wireproxy
launchctl kickstart -k gui/$(id -u)/net.mullvad.wireproxy

# 4. Check
curl --socks5-hostname 127.0.0.1:1080 https://am.i.mullvad.net/connected
open -a "Brave Browser" https://mullvad.net/check   # brave://policy -> Level: Mandatory

# Remove: System Settings > General > Device Management > profile > Remove

# Logs
tail -f ~/Library/Logs/wireproxy.log
```

## Verify

```sh
# zsh
git ls-files '*.zsh' '.config/zsh/.zshenv' '.config/zsh/.zprofile' '.config/zsh/.zshrc' | xargs -n1 zsh -n

# shell script
git ls-files '*.sh' | xargs -n1 bash -n

# JSON
git ls-files '*.json' | xargs -n1 jq empty
```
