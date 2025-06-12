---@diagnostic disable: undefined-global
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim (minimal)
require("lazy").setup({
  dofile(vim.fn.stdpath("config") .. "/plugins/treesitter.lua"),
  dofile(vim.fn.stdpath("config") .. "/plugins/theme.lua"),
}, {
  install = {
    missing = true, -- Auto-install missing plugins
  },
})
