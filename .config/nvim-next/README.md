# nvim-next

LazyVim をベースに、設定を一つずつ削って自分用に寄せていく作業場。

## Summary

- 出発点は [LazyVim/starter](https://github.com/LazyVim/starter)
- `NVIM_APPNAME=nvim-next` で起動し、現行の `.config/nvim` とは独立して動く
- plugin は `~/.local/share/nvim-next/` に入る
- 完成したら `.config/nvim` と入れ替えて、この directory を消す

## Commands

```sh
# 起動
vn

# plugin 更新
NVIM_APPNAME=nvim-next nvim --headless "+Lazy! sync" +qa
```

`vn` は `.config/zsh/.zshrc` の alias。

## 盆栽の仕方

`lua/plugins/` に file を置くと LazyVim の既定を上書きできる。

```lua
-- lua/plugins/trim.lua
return {
  { "akinsho/bufferline.nvim", enabled = false },
}
```

既定の spec は `~/.local/share/nvim-next/lazy/LazyVim/lua/lazyvim/plugins/` にある。
category ごと外すなら `lua/config/lazy.lua` の `import` を書き換える。

`lua/plugins/example.lua` は starter 付属の見本。冒頭で早期 return しており読み込まれない。

## 純正 LazyVim と比べる

素の starter を使い捨てで立てる。

```sh
git clone --depth 1 https://github.com/LazyVim/starter ~/.config/lazyvim
NVIM_APPNAME=lazyvim nvim
trash ~/.config/lazyvim ~/.local/share/lazyvim ~/.local/state/lazyvim ~/.cache/lazyvim
```

## 撤収

```sh
# 採用する
trash .config/nvim && mv .config/nvim-next .config/nvim

# やめる
trash .config/nvim-next ~/.local/share/nvim-next ~/.local/state/nvim-next ~/.cache/nvim-next
```

どちらの場合も `.zshrc` の `vn` alias を消す。
