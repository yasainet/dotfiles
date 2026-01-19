-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Search
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })

-- Aliases
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Mac Cmd
vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("n", "<D-z>", "u", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

-- Insert mode Emacs-style
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Move backward" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move forward" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character" })
vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Neo-tree
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")

-- Gitsigns
vim.keymap.set("n", "]c", "<Cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
vim.keymap.set("n", "[c", "<Cmd>Gitsigns prev_hunk<CR>", { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hi", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk inline" })
vim.keymap.set("n", "<leader>hb", "<Cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
vim.keymap.set("n", "<leader>tb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>td", "<Cmd>Gitsigns toggle_deleted<CR>", { desc = "Toggle deleted" })

-- Diffview
vim.keymap.set("n", "<leader>dv", "<Cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>dc", "<Cmd>DiffviewClose<CR>", { desc = "Diffview close" })
vim.keymap.set("n", "<leader>dh", "<Cmd>DiffviewFileHistory<CR>", { desc = "Diffview file history" })

-- Telescope
vim.keymap.set("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fd", "<Cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>gs", "<Cmd>Telescope git_status<CR>", { desc = "Git status" })

-- Conform
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Comment
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })

-- Todo Comments
vim.keymap.set("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "Find todos" })
vim.keymap.set("n", "]t", '<Cmd>lua require("todo-comments").jump_next()<CR>', { desc = "Next todo" })
vim.keymap.set("n", "[t", '<Cmd>lua require("todo-comments").jump_prev()<CR>', { desc = "Previous todo" })

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

-- Yank path
vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("Yanked: " .. path)
end, { desc = "Yank full path" })

-- Claude Code
vim.keymap.set("n", "<leader>ac", "<Cmd>ClaudeCode<CR>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", "<Cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", "<Cmd>ClaudeCode --resume<CR>", { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>aC", "<Cmd>ClaudeCode --continue<CR>", { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>am", "<Cmd>ClaudeCodeSelectModel<CR>", { desc = "Select Claude model" })
vim.keymap.set("n", "<leader>ab", "<Cmd>ClaudeCodeAdd %<CR>", { desc = "Add current buffer" })
vim.keymap.set("v", "<leader>as", "<Cmd>ClaudeCodeSend<CR>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>aa", "<Cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>ad", "<Cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny diff" })

-- Config reload
vim.keymap.set("n", "<leader>rr", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^config") or name:match("^plugins") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
	print("Config reloaded!")
end, { desc = "Reload config" })
vim.keymap.set("n", "<leader>rc", "<Cmd>Lazy clear<CR>", { desc = "Clear lazy cache" })
