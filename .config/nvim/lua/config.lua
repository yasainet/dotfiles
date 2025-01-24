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
vim.opt.laststatus = 3

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

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

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

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

-- Key mapping
-- Leader
vim.g.mapleader = " "

-- Alias
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_set_keymap("i", "<C-c>", "<ESC>", { noremap = true, silent = true }) -- 影響あるかもしれない

-- Cmd
vim.keymap.set("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.keymap.set("n", "<D-v>", "\"+p", { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("n", "<D-z>", "u", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

-- Split
vim.keymap.set("n", "<Leader>sv", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>sh", ":split<CR>", { noremap = true, silent = true })

-- Window
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Insert mode
vim.keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", "<Up>", { noremap = true, silent = true })
