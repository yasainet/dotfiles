# nvim-dev

すっぴんの Neovim から始めて、必要な設定だけを 1 つずつ積む作業場。完成したら
`.config/nvim` と入れ替える。

## Summary

- `NVIM_APPNAME=nvim-dev` で起動する。alias は `vimdev`
- 初期状態は `lazy.nvim` の bootstrap だけ。plugin はゼロ
- `options.lua`, `keymaps.lua`, `autocmds.lua` は必要になった時に作る
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
| `lazyvim` | `.config/lazyvim` | 辞書。何を移植するか探す |
| `vimdev` | `.config/nvim-dev` | ここ。理想形を積む |

## 移植の 1 サイクル

1. `lazyvim` で触り、気に入った挙動を見つける
2. `:Lazy` からその plugin の spec 定義元へ飛ぶ
3. 読んで、何がその挙動を作っているか特定する
4. `nvim-dev` に自分の言葉で書く。spec をコピーしない
5. `vimdev` で確認する
6. commit する

1 plugin を 1 commit にする。body には入れた理由と、LazyVim の設定を採らなかった
理由を書く。移植の判断は `git log` にしか残らない。

LazyVim の既定 spec は `~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/plugins/`
にある。

## 移植の順序

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
nvim-lspconfig 経由。どちらを採るか移植時に決める。

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
