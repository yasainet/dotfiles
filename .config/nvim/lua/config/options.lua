-- Language
vim.opt.langmenu = "en"
vim.cmd("language en_US")

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- History
vim.opt.history = 10000

-- UI
vim.opt.number = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", extends = "»", precedes = "«", nbsp = "␣" }

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

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"

-- Filetype
vim.filetype.add({
	pattern = {
		[".*/.config/zed/.*%.json"] = "jsonc",
	},
})

-- Cursor
vim.opt.guicursor = {
	"n-v-c:block-blinkon100",
	"i-ci:ver25-blinkon100",
	"r-cr:hor20-blinkon100",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250",
	"sm:block-blinkon100",
}
