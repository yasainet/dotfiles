-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Search
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })

-- Quit
vim.keymap.set("n", "<leader>q", "<Cmd>qa<CR>", { desc = "Quit all" })

-- Dashboard
vim.keymap.set("n", "<leader>;", function() Snacks.dashboard() end, { desc = "Dashboard" })

-- Aliases
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Insert mode Emacs-style
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Move backward" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move forward" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character" })
vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Next line" })
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Previous line" })

-- Explorer
vim.keymap.set("n", "<leader>e", function()
	require("snacks").explorer()
end, { desc = "Explorer" })

-- Gitsigns
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		require("gitsigns").nav_hunk("next")
	end
end, { desc = "Next hunk" })

vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		require("gitsigns").nav_hunk("prev")
	end
end, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hi", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk inline" })
vim.keymap.set("n", "<leader>hb", "<Cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
vim.keymap.set("n", "<leader>tb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>td", "<Cmd>Gitsigns toggle_deleted<CR>", { desc = "Toggle deleted" })

-- Lazygit
vim.keymap.set("n", "<leader>gg", function()
	vim.fn.system("tmux display-popup -E -w 100% -h 100% 'lazygit'")
	vim.cmd("checktime")
	local ok, gs = pcall(require, "gitsigns")
	if ok then
		gs.refresh()
	end
end, { desc = "Lazygit" })

-- Smart Splits
vim.keymap.set({ "n", "t" }, "<C-h>", function()
	require("smart-splits").move_cursor_left()
end, { desc = "Move to left window" })
vim.keymap.set({ "n", "t" }, "<C-j>", function()
	require("smart-splits").move_cursor_down()
end, { desc = "Move to lower window" })
vim.keymap.set({ "n", "t" }, "<C-k>", function()
	require("smart-splits").move_cursor_up()
end, { desc = "Move to upper window" })
vim.keymap.set({ "n", "t" }, "<C-l>", function()
	require("smart-splits").move_cursor_right()
end, { desc = "Move to right window" })

-- Picker (Snacks)
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git status" })

-- Buffer
vim.keymap.set("n", "<leader>bc", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.bo[buf].buftype == "" and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
	print("Buffers cleared")
end, { desc = "Clear other buffers" })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
	{ desc = "LSP Definitions / references (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<Cmd>Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

-- Conform
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Comment
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<C-/>", "<Esc>gccgi", { desc = "Toggle comment" })

-- Comment tmux
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<C-_>", "<Esc>gccgi", { desc = "Toggle comment" })

-- Todo Comments
vim.keymap.set("n", "<leader>ft", function() Snacks.picker.todo_comments() end, { desc = "Find todos" })
vim.keymap.set("n", "]t", '<Cmd>lua require("todo-comments").jump_next()<CR>', { desc = "Next todo" })
vim.keymap.set("n", "[t", '<Cmd>lua require("todo-comments").jump_prev()<CR>', { desc = "Previous todo" })

-- Translate
vim.keymap.set("v", "<leader>tj", function()
	vim.cmd('normal! "ty')
	local text = vim.fn.getreg("t")
	text = text:gsub("'", "'\\''")
	vim.fn.system(string.format("tmux display-popup -E \"echo '%s' | trans -b :ja; read\"", text))
end, { desc = "Translate to Japanese" })
vim.keymap.set("v", "<leader>te", function()
	vim.cmd('normal! "ty')
	local text = vim.fn.getreg("t")
	text = text:gsub("'", "'\\''")
	vim.fn.system(
		string.format(
			'tmux display-popup -E "r=\\$(echo \'%s\' | trans -b :en); echo \\"\\$r\\"; echo \\"\\$r\\" | pbcopy; read"',
			text
		)
	)
end, { desc = "Translate to English" })

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

-- LSP Restart
vim.keymap.set("n", "<leader>lr", function()
	vim.diagnostic.reset()
	local current_buf = vim.api.nvim_get_current_buf()
	for _, client in ipairs(vim.lsp.get_clients()) do
		client:stop()
	end
	vim.cmd("silent! bufdo e!")
	vim.api.nvim_set_current_buf(current_buf)
	print("LSP restarted")
end, { desc = "Restart LSP" })

vim.keymap.set("n", "<leader>li", "<Cmd>checkhealth vim.lsp<CR>", { desc = "LSP info" })

-- Yank path
vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("Yanked: " .. path)
end, { desc = "Yank full path" })

-- Claude Code
vim.keymap.set("n", "<leader>cc", function()
	if _G._claude_pane_id then
		local ok = vim.fn.system("tmux display-message -p -t " .. _G._claude_pane_id .. ' "#{pane_id}" 2>/dev/null')
		if vim.v.shell_error == 0 and ok:match("%S") then
			vim.fn.system("tmux kill-pane -t " .. _G._claude_pane_id)
			_G._claude_pane_id = nil
			return
		end
		_G._claude_pane_id = nil
	end
	local pane_id = vim.fn.system('tmux split-window -h -l 40% -P -F "#{pane_id}" "claude"')
	_G._claude_pane_id = vim.trim(pane_id)
end, { desc = "Claude Code" })

-- Config reload
vim.keymap.set("n", "<leader>rr", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^config") or name:match("^plugins") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
	print("Config reloaded")
end, { desc = "Reload config" })
vim.keymap.set("n", "<leader>rc", "<Cmd>Lazy clear<CR>", { desc = "Clear lazy cache" })
