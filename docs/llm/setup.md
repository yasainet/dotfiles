---
created: 2026-08-02
updated: 2026-08-02
---

# LLM Setup

MacBook-Pro-2023 (M3 Max 128GB) を LLM 専用機として構築・運用する手順。

## 構成

- llama-swap が :8080 で待ち受け、モデルをリクエストに応じて入れ替える
- クライアント (MacBook-Air-2026) は tailscale 経由で `$LLM_URL` に繋ぐ
- llama-swap は LaunchAgent `com.yasainet.llama-swap` が常駐させる

## Setup

初期化した機体で実行する。

```sh
# Xcode
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# dotfiles (llm プロファイル)
brew install ghq
ghq get https://github.com/yasainet/dotfiles
cd ~/ghq/github.com/yasainet/dotfiles
DOTFILES_PROFILE=llm ./install.sh

# モデル取得 (数百 GB, レジューム可)
./scripts/llm/fetch.sh
```

`DOTFILES_PROFILE=llm` を付けると `scripts/setup/llm.sh` を読む。
入れる物の一覧はそこにあり、`darwin.sh` の定義を上書きする。

- GUI アプリ、App Store アプリ、npm globals は入れない
- 代わりに llama.cpp、llama-swap、hf を入れる
- node (nvm) は入れる。小さな script を動かすため

`darwin.sh` と重複する `brew install` が並ぶ。
条件分岐で削るより、入れる物を一覧で見られる方を選んだ。

## 手動で行うこと

install.sh が代行できない設定。

1. マシン名を `MacBook-Pro-2023` にする (README の Rename machine)
2. `tailscale up` で tailnet に参加する
   daemon は install.sh が `sudo brew services start tailscale` で常駐させる
3. 自動ログインを有効にする
   System Settings → Users & Groups → Automatically log in as
   LaunchAgent はログイン中しか動かないため、蓋を閉じた運用では必須
4. リモートログインの確認
   `systemsetup -setremotelogin on` はフルディスク アクセスが無いと失敗する。
   失敗した場合は System Settings → General → Sharing → Remote Login を ON にする
5. クライアントの公開鍵を `~/.ssh/authorized_keys` に置く

## 運用

```sh
# 状態
launchctl print gui/$(id -u)/com.yasainet.llama-swap
tail -f /tmp/llama-swap.log

# 再起動 (config.yaml を変えた後)
launchctl kickstart -k gui/$(id -u)/com.yasainet.llama-swap

# 手動起動 (ログを直接見たい時)
launchctl bootout gui/$(id -u)/com.yasainet.llama-swap
./scripts/llm/serve.sh
```
