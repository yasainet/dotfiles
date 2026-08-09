# lazyvim

[LazyVim](https://github.com/LazyVim/LazyVim) の設定。`.config/nvim` とは独立して動く。

## Summary

- 出発点は [LazyVim/starter](https://github.com/LazyVim/starter)
- `NVIM_APPNAME=lazyvim` で起動する。alias は `vl`
- plugin は `~/.local/share/lazyvim/` に入る。`.config/nvim` とは共有しない
- mason と treesitter parser も別に入る。重複は許容している

## Commands

```sh
# 起動
vl

# plugin 更新
NVIM_APPNAME=lazyvim nvim --headless "+Lazy! sync" +qa
```

`v` は `.config/nvim` の方。alias は `.config/zsh/.zshrc` にある。

## 設定の書き方

`lua/plugins/` に file を置くと LazyVim の既定を上書きできる。

```lua
-- lua/plugins/trim.lua
return {
  { "akinsho/bufferline.nvim", enabled = false },
}
```

既定の spec は `~/.local/share/lazyvim/lazy/LazyVim/lua/lazyvim/plugins/` にある。
category ごと外すなら `lua/config/lazy.lua` の `import` を書き換える。

`lua/plugins/example.lua` は starter 付属の見本。冒頭で早期 return しており読み込まれない。

## 中で調べる

| コマンド | 見えるもの |
| -------- | ---------- |
| `:Lazy` | plugin 一覧。読み込みの契機と所要時間 |
| `:LazyExtras` | 追加できる extras |
| `:LazyHealth` | 各 plugin の状態 |

## 撤収

```sh
git revert <hash>
trash ~/.config/lazyvim ~/.local/share/lazyvim ~/.local/state/lazyvim ~/.cache/lazyvim
```

`.zshrc` の `vl` alias も消す。
