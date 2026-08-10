-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Insert mode Emacs-style
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move forward" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character" })
vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Next line" })
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Previous line" })

-- Search
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { silent = true })

-- Quit
vim.keymap.set({ "n", "x" }, "<leader>qq", "<Cmd>qa!<CR>", { desc = "Quit all (force)" })

-- lazy.nvim
vim.keymap.set("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy" })
