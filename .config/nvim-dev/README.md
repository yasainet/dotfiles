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

| alias     | 設定               | 役割                         |
| --------- | ------------------ | ---------------------------- |
| `v`       | `.config/nvim`     | 日常業務。完成まで触らない   |
| `lazyvim` | `.config/lazyvim`  | 辞書。不満が出たときだけ引く |
| `vimdev`  | `.config/nvim-dev` | ここ。理想形を積む           |

## 積む 1 サイクル

1. 公式 README の Installation 節どおりに spec を書く
2. 動くのに要る最小の Setup だけ足す
3. `vimdev` で動作を確認する
4. mason で実体が要るなら `mason-tool-installer` に足す
5. commit する。`lazy-lock.json` も一緒に含める

README は `~/.local/share/lazyvim/lazy/<plugin>/README.md` から読む。GitHub や
context7 が返すのは main ブランチの内容で、`version = "1.*"` で入る tag と
食い違うことがある。blink.cmp で実際に未リリースの `build` を書いてしまい、
起動時に落ちた。手元の clone なら、入るものと同じ版を読める。

何を最低限とするかは、毎回この線で切る。

| 含める                   | 含めない              |
| ------------------------ | --------------------- |
| 公式の Installation      | 公式の Advanced setup |
| 動くのに要る最小の Setup | 任意の機能            |
| 既定のキーマップ         | 自分好みの keymap     |

keymap は plugin 固有なら spec の `keys` に書く。plugin に依らないものだけ
`keymaps.lua` に置く。`keys` は遅延読み込みのトリガーを兼ねており、lazy.nvim が
`desc` 付きで仮の mapping を張るので、未読み込みでも which-key に出る。

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

| 順  | 対象              | 理由                           |
| --- | ----------------- | ------------------------------ |
| 1   | options, keymaps  | plugin 不要。土台              |
| 2   | treesitter        | 他の plugin が前提にする       |
| 3   | picker            | 移動手段。入ると作業が速くなる |
| 4   | LSP               | 方式の選択が要る。下記参照     |
| 5   | completion        | LSP の後                       |
| 6   | formatter, linter | 独立                           |
| 7   | UI                | 最後。好みの領域               |

LSP は nvim-lspconfig 経由を採った。`.config/nvim` の `lsp/*.lua` 方式は、server が
増えるたびに設定データを自分で書くことになるため。

1〜7 は埋まった。ここからは下の対応表を見て、要るものを 1 つずつ足す。

## LazyVim との対応

LazyVim が入れる 32 個を、採ったかどうかで並べる。状態は ✅ 済 / ❌ 未 / ➖ 外 の 3 つ。
➖ は採らないもの。

| plugin                      | 役割                              | 状態 |
| --------------------------- | --------------------------------- | ---- |
| lazy.nvim                   | plugin manager                    | ✅   |
| tokyonight.nvim             | colorscheme                       | ✅   |
| nvim-treesitter             | 構文解析。色付けと選択の土台      | ✅   |
| snacks.nvim                 | picker, explorer ほか多数         | ✅   |
| which-key.nvim              | keymap の一覧を出す               | ✅   |
| mason.nvim                  | LSP と tool の実体を入れる        | ✅   |
| mason-lspconfig.nvim        | mason と lspconfig を繋ぐ         | ✅   |
| nvim-lspconfig              | server の設定データ               | ✅   |
| blink.cmp                   | 補完                              | ✅   |
| conform.nvim                | formatter を走らせる              | ✅   |
| nvim-lint                   | linter を走らせる                 | ✅   |
| lualine.nvim                | statusline                        | ✅   |
| gitsigns.nvim               | 変更行を sign column に出す       | ✅   |
| flash.nvim                  | 画面内ジャンプ                    | ❌   |
| todo-comments.nvim          | TODO の強調と一覧                 | ✅   |
| trouble.nvim                | 診断と参照の一覧                  | ✅   |
| mini.pairs                  | 括弧の自動補完                    | ✅   |
| mini.ai                     | テキストオブジェクトの拡張        | ❌   |
| ts-comments.nvim            | filetype ごとのコメント記号       | ❌   |
| nvim-ts-autotag             | HTML タグの自動閉じ               | ✅   |
| nvim-treesitter-textobjects | 関数や引数の単位で選択する        | ❌   |
| lazydev.nvim                | Neovim 設定を書くときの lua 補完  | ❌   |
| bufferline.nvim             | buffer をタブ風に並べる           | ❌   |
| noice.nvim                  | コマンドラインと通知の見た目      | ❌   |
| persistence.nvim            | session を復元する                | ❌   |
| grug-far.nvim               | 一括置換                          | ❌   |
| mini.icons                  | アイコン。devicons と役割が重なる | ❌   |
| friendly-snippets           | snippet 集                        | ❌   |
| LazyVim                     | framework 本体。積む対象ではない  | ➖   |
| catppuccin                  | colorscheme の予備                | ➖   |
| nui.nvim                    | noice の依存                      | ➖   |
| plenary.nvim                | 他の plugin の依存                | ➖   |

nvim-dev だけに入っているものもある。

| plugin                    | 役割                               | 理由                           |
| ------------------------- | ---------------------------------- | ------------------------------ |
| herdr-splits.nvim         | Herdr と split 移動を繋ぐ          | 自分の環境固有                 |
| mason-tool-installer.nvim | formatter と linter の実体を入れる | LazyVim は同じことを自前で書く |
| nvim-web-devicons         | アイコン                           | lualine 公式が依存に挙げている |

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
