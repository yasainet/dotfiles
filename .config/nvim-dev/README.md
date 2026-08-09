# nvim-dev

すっぴんの Neovim から始めて、公式どおりの最小構成を 1 つずつ積む作業場。完成したら
`.config/nvim` と入れ替える。

## Summary

- `NVIM_APPNAME=nvim-dev` で起動する。alias は `vimdev`
- plugin は公式 README の最小構成で入れる。凝った設定は後回しにする
- plugin は `~/.local/share/nvim-dev/` に入る。`nvim` とも `lazyvim` とも共有しない

## Commands

```sh
# 起動
vimdev

# plugin 更新
NVIM_APPNAME=nvim-dev nvim --headless "+Lazy! sync" +qa
```

## 3 つの環境

| alias | 設定 | 役割 |
| ------- | ------ | ------ |
| `v` | `.config/nvim` | 日常業務。完成まで触らない |
| `lazyvim` | `.config/lazyvim` | 辞書。不満が出たときだけ引く |
| `vimdev` | `.config/nvim-dev` | ここ。理想形を積む |

## 積む 1 サイクル

1. 公式 README の Installation 節どおりに spec を書く
2. 動くのに要る最小の Setup だけ足す
3. `vimdev` で動作を確認する
4. commit する

何を最低限とするかは、毎回この線で切る。

| 含める | 含めない |
| ------ | ------ |
| 公式の Installation | 公式の Advanced setup |
| 動くのに要る最小の Setup | 任意の機能 |
| 既定のキーマップ | 自分好みの keymap |

1 plugin を 1 commit にする。body には入れた理由を書く。

## 深掘りの 1 サイクル

使っていて不満が出たときだけ入る。不満が無ければ最小構成のまま置く。

1. 何に困ったかを 1 行で書く
2. `lazyvim` で同じ操作を試し、挙動が違うか見る
3. 違えば `:Lazy` から spec 定義元へ飛び、原因を特定する
4. `nvim-dev` に自分の言葉で書く。spec をコピーしない
5. commit する

1 不満を 1 commit にする。body には困った内容と、LazyVim の設定を採らなかった理由を
書く。判断は `git log` にしか残らない。

LazyVim の既定 spec は `~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/plugins/`
にある。

## 積む順序

依存の少ない順に進めると手戻りが出ない。

| 順 | 対象 | 理由 |
| --- | ------ | ------ |
| 1 | options, keymaps | plugin 不要。土台 |
| 2 | treesitter | 他の plugin が前提にする |
| 3 | picker | 移動手段。入ると作業が速くなる |
| 4 | LSP | 方式の選択が要る。下記参照 |
| 5 | completion | LSP の後 |
| 6 | formatter, linter | 独立 |
| 7 | UI | 最後。好みの領域 |

LSP は方式が 2 つある。`.config/nvim` は Neovim 0.11 の `lsp/*.lua` 方式、LazyVim は
nvim-lspconfig 経由。どちらを採るか積むときに決める。

## 完成したとき

```sh
trash .config/nvim
mv .config/nvim-dev .config/nvim
unlink ~/.config/nvim-dev
trash ~/.local/share/nvim-dev ~/.local/state/nvim-dev ~/.cache/nvim-dev
```

`~/.config/nvim-dev` は repo への symlink。参照先が無くなるので link だけ外す。
`~/.config/nvim` は `mv` で参照先が戻るため、張り替え不要。

`.zshrc` から `vimdev` を消す。`lazyvim` を辞書として残すかは別に判断する。
旧設定は git 履歴に残るので拾い直せる。
