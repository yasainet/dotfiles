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
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 10000
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.clipboard:append({ 'unnamedplus' })
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.mouse = "a"
vim.opt.mousemodel = 'popup'

vim.api.nvim_set_keymap('v', '<D-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<D-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<D-v>', '<C-r>+', { noremap = true, silent = true })

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
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
            })
            vim.cmd.colorscheme "catppuccin"
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'catppuccin',
                    icons_enabled = false,
                },
            })
        end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
    }
})
