# LLM Setup

MacBook-Pro-2023 (M3 Max 128GB) を LLM 専用機として構築・運用する手順。

## 構成

- llama-server が :8080 で待ち受ける。モデルは 1 つ固定 (`scripts/llm/serve.sh` 参照)
- クライアント (MacBook-Air-2026) は tailscale 経由で `$LLM_URL` に繋ぐ
- 常駐はしない。pi の `llm-server` 拡張が起動時に start、quit 時に stop する
  (queen で ComfyUI と VRAM を共有するため)

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
- 代わりに llama.cpp、hf を入れる
- node (nvm) は入れる。小さな script を動かすため

`darwin.sh` と重複する `brew install` が並ぶ。
条件分岐で削るより、入れる物を一覧で見られる方を選んだ。

## 手動で行うこと

install.sh が代行できない設定。

1. マシン名を `MacBook-Pro-2023` にする (README の Rename machine)
2. `tailscale up` で tailnet に参加する
   daemon は install.sh が `sudo brew services start tailscale` で常駐させる
3. 画面共有を有効にする
   System Settings → General → Sharing → Screen Sharing
   再起動後の復旧に使う (下記)
4. リモートログインの確認
   `systemsetup -setremotelogin on` はフルディスク アクセスが無いと失敗する。
   失敗した場合は System Settings → General → Sharing → Remote Login を ON にする
5. クライアントの公開鍵を `~/.ssh/authorized_keys` に置く

## 確認

```sh
# モデル一覧
curl -s $LLM_URL/v1/models | jq -r '.data[].id'

# 推論 (初回はモデルのロードに時間がかかる)
curl -s $LLM_URL/v1/chat/completions -H "Content-Type: application/json" \
  -d '{"model":"qwen3.6-27b-hauhau-balanced","messages":[{"role":"user","content":"ping"}]}' \
  | jq -r '.choices[0].message.content'
```

モデル ID は `scripts/llm/serve.sh` (`--alias` 未指定なら gguf 名) と
`dot-pi/agent/models.json` で揃える。片方だけ変えると pi からモデルを選べない。

## 電源

蓋を閉じて放置するため、install.sh が AC 接続時のスリープを止める。
バッテリー駆動時は通常どおりスリープする。持ち出した時に電池を使い切らないため。

```sh
pmset -g custom                                       # AC Power が sleep 0
ioreg -n IOPMrootDomain -r -d 1 | grep SleepDisabled  # Yes なら閉じてよい
```

`disablesleep` は `pmset -g` に出ない。実効値は ioreg で見る。

## 再起動後の復旧

llama-swap は LaunchAgent なので、GUI にログインするまで起動しない。
自動ログインはセキュリティ上使わない。

macOS のアップデートや停電で再起動が挟まったら、画面共有で繋いでログインする。
ログイン画面の状態でも接続できる。ログインすれば LaunchAgent が自動で上がる。

LaunchDaemon にして root 常駐させれば解決するが、そうしない。
GUI セッションが無いと Metal デバイスを取得できず、CPU 推論に落ちるため。

## 再構築後の追随

tailnet に入り直すと IP が変わる。クライアント側の 2 箇所を書き換える。

- `.config/zsh/.zshenv` の `LLM_URL`
- `~/.ssh/config` の `Host mbp2023` (dotfiles 管理外)

`dot-pi/agent/models.json` の `baseUrl` は MagicDNS 名 (`http://queen:8080`) を
使うため IP 変更の影響を受けない (pi は env 展開非対応のため直書きしている)。

古いノードは admin console から削除する。同じ名前を再取得できる。

## 共有

他の人に使わせる場合、OS ユーザーは作らない。

- admin console で mbp2023 ノードだけを share する
- 相手は opencode の provider に `baseURL` を書き、mbp2023 の IP を向ける
- 使うモデルは 1 つに揃える

llama-server は 1 モデルしか載せない。

### ACL

node share はマシン単位で、既定の ACL では全ポートが相手に開く。
共有先を 8080 だけに絞る。admin console の Access controls に書く。

```diff
 "grants": [
-  {"src": ["*"], "dst": ["*"], "ip": ["*"]},
+  {"src": ["autogroup:member"], "dst": ["*"], "ip": ["*"]},
+  {"src": ["autogroup:shared"], "dst": ["*"], "ip": ["tcp:8080"]},
 ],
```

既定の `{"src": ["*"], "dst": ["*"], "ip": ["*"]}` を上の 2 行に置き換える。
`autogroup:shared` は招待を受けた全員を指す。相手のメールを書かなくてよい。

旧い `acls` 構文ではなく `grants` を使う。この tailnet は既に grants 形式。

適用後は mbp2023 で確認する。共有先の src が 8080 だけに現れる。

```sh
tailscale debug netmap | jq -c '.PacketFilter[] | {Srcs, Dsts}'
```

API key は付けていない。片方だけ止めるのは admin console の共有解除でできる。
持ち出さないので LAN からの到達も無い。相手に設定変更を求める得が小さい。

llama-server の Web UI は 8080 上にあり、共有先から見える。

`-np` が既定 1 のためリクエストは直列化する。待ちが問題になったら
`--parallel 2` を足す。`--ctx-size` が全スロットの合計になる点に注意する。

## 運用

queen 上で行う。通常は pi が start/stop するため手動操作は不要。

```sh
# 状態
systemctl --user status llama-server
journalctl --user -u llama-server -f

# 再起動 (serve.sh を変えた後)
systemctl --user restart llama-server

# 停止し損ねた時 (pi のクラッシュ後など)
systemctl --user stop llama-server

# 手動起動 (ログを直接見たい時)
./scripts/llm/serve.sh
```
