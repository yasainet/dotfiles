-- Language
vim.opt.langmenu = "en"
vim.cmd("language en_US.UTF-8")

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Cursor
vim.opt.guicursor = {
	"n-v-c-sm:block",
	"i-ci-ve:ver25",
	"r-cr-o:hor20",
	"a:blinkwait500-blinkoff500-blinkon500",
}

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"

-- History
vim.opt.history = 10000

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- UI
vim.o.winborder = "rounded"
vim.opt.number = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", extends = "»", precedes = "«", nbsp = "␣" }
vim.opt.fillchars:append({ diff = "╱" })

-- Indent
vim.g.markdown_recommended_style = 0
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Options
-- TODO: explore
vim.deprecate = function() end
