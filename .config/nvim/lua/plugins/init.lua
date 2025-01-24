---@diagnostic disable: undefined-global

-- telescoop? fzf
-- comment系
-- git 差分表示
-- lazygit
-- copilot
-- lsp
-- nvim-cmp

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
  { import = "plugins.nvim-tree" },
  { import = "plugins.nvim-treesitter" },
  { import = "plugins.nvim-cmp" },
  { import = "plugins.gitsigns" },
  { import = "plugins.codecompanion" }

  -- Appearance
  -- Coding
  -- lsp
  -- Git
  -- AI
})
