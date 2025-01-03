vim.opt.encoding = "utf-8"
vim.opt.langmenu = "en"
vim.cmd("language en_US")
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 10000
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.clipboard:append({ 'unnamedplus' })
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.mouse = "a"
vim.opt.mousemodel = 'popup'

vim.opt.guicursor = {
  "n-v-c:block-blinkon100",
  "i-ci:ver25-blinkon100",
  "r-cr:hor20-blinkon100",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250",
  "sm:block-blinkon100"
}

-- 保存: Cmd + S
vim.keymap.set('n', '<D-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<D-s>', '<C-o>:w<CR>', { noremap = true, silent = true })

-- システムクリップボードと連携: Cmd + C / Cmd + V
vim.keymap.set('v', '<D-c>', '"+y', { noremap = true, silent = true })
vim.keymap.set('n', '<D-v>', '"+p', { noremap = true, silent = true })
vim.keymap.set('i', '<D-v>', '<C-r>+', { noremap = true, silent = true })


-- lazy.nvim
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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin',
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim", -- 微妙かも
    main = "ibl",
    opts = {},
  },
})

require("catppuccin").setup({
  transparent_background = true
})

vim.cmd.colorscheme "catppuccin"
