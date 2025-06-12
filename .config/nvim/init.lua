---@diagnostic disable: undefined-global
-- Language
vim.opt.langmenu = "en"
vim.cmd("language en_US")

-- Character encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- History
vim.opt.history = 10000

-- UI
vim.opt.number = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showcmd = true
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·', extends = '»', precedes = '«', nbsp = '␣' }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Menu
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- File
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.autoread = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"

-- Cursor
vim.opt.guicursor = {
  "n-v-c:block-blinkon100",
  "i-ci:ver25-blinkon100",
  "r-cr:hor20-blinkon100",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250",
  "sm:block-blinkon100"
}

-- Keymaps
-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Alias
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- Cmd
vim.keymap.set("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.keymap.set("n", "<D-v>", "\"+p", { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("n", "<D-z>", "u", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

-- Plugin Manager
local plugins_path = vim.fn.stdpath("config") .. "/plugins/lazy.lua"
if vim.fn.filereadable(plugins_path) == 1 then
  dofile(plugins_path)
end

-- Theme (transparent background compatibility with existing config)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("highlight Normal guibg=NONE")
  end
})
