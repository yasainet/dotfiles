-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Insert mode Emacs-style
-- vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
-- vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
-- vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move forward" })
-- vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character" })
-- vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })
-- vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Next line" })
-- vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Previous line" })

-- Quit
vim.keymap.set({ "n", "x" }, "<leader>qq", "<Cmd>qa!<CR>", { desc = "Quit all (force)" })

-- ====================
-- snacks.nvim
-- ====================

-- Explorer
vim.keymap.set("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "File Explorer" })

-- Picker
vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent" })
