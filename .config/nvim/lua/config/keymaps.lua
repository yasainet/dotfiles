---@diagnostic disable: undefined-global

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Search
vim.keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Aliases
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- Mac Cmd
vim.keymap.set("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.keymap.set("n", "<D-v>", "\"+p", { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("n", "<D-z>", "u", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

-- Neo-tree
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")

-- Gitsigns
vim.keymap.set('n', ']h', '<Cmd>Gitsigns next_hunk<CR>')
vim.keymap.set('n', '[h', '<Cmd>Gitsigns prev_hunk<CR>')
vim.keymap.set('n', '<leader>hs', '<Cmd>Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>hr', '<Cmd>Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>hp', '<Cmd>Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>hb', '<Cmd>Gitsigns blame_line<CR>')
vim.keymap.set('n', '<leader>ht', '<Cmd>Gitsigns toggle_signs<CR>')
vim.keymap.set('n', '<leader>hd', '<Cmd>Gitsigns toggle_deleted<CR>')
vim.keymap.set('n', '<leader>hl', '<Cmd>Gitsigns toggle_linehl<CR>')
vim.keymap.set('n', '<leader>hn', '<Cmd>Gitsigns toggle_numhl<CR>')
