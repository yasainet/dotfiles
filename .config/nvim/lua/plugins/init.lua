--- TODO
--- 以下のページを参考にする
--- @see https://www.reddit.com/r/neovim/comments/18vriuo/trouble_with_neotree_colours/

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.catppuccin" },
  { import = "plugins.lualine" },
  { import = "plugins.im-select" },
  { import = "plugins.indent-blankline" },
  { import = "plugins.toggleterm" },
  { import = "plugins.neo-tree" },
  { import = "plugins.telescope" },
  { import = "plugins.nvim-treesitter" },
  { import = "plugins.nvim-cmp" },
  { import = "plugins.lazygit" },
  { import = "plugins.gitsigns" },
  { import = "plugins.codecompanion" }
})
