-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Search
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })

-- Quit
vim.keymap.set("n", "<leader>q", "<Cmd>qa!<CR>", { desc = "Quit all" })

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

-- Cmd keybindings
vim.keymap.set("n", "<M-p>", function()
	Snacks.picker.files()
end, { desc = "Find files (Cmd+p)" })
vim.keymap.set("n", "<M-F>", function()
	Snacks.picker.grep()
end, { desc = "Live grep (Cmd+Shift+f)" })
vim.keymap.set({ "n", "i" }, "<M-s>", "<Cmd>w<CR>", { desc = "Save (Cmd+s)" })
vim.keymap.set("n", "<M-/>", "gcc", { remap = true, desc = "Comment toggle (Cmd+/)" })
vim.keymap.set("v", "<M-/>", "gc", { remap = true, desc = "Comment toggle (Cmd+/)" })
vim.keymap.set("n", "<M-e>", function()
	require("snacks").explorer()
end, { desc = "Explorer (Cmd+Shift+e)" })
vim.keymap.set("n", "<M-G>", function()
	local lib_ok, lib = pcall(require, "diffview.lib")
	if lib_ok and lib.get_current_view() then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { desc = "Diffview toggle (Cmd+Shift+g)" })

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

-- Lazygit
vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

-- Diffview
vim.keymap.set("n", "<leader>gd", "<Cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gf", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
vim.keymap.set("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "Diffview close" })

-- Window navigation
vim.keymap.set("n", "<C-h>", function()
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd h")
	if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
		vim.fn.system("tmux select-pane -L")
	end
end, { desc = "Navigate left" })
vim.keymap.set("n", "<C-j>", function()
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd j")
	if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
		vim.fn.system("tmux select-pane -D")
	end
end, { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", function()
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd k")
	if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
		vim.fn.system("tmux select-pane -U")
	end
end, { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", function()
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd l")
	if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
		vim.fn.system("tmux select-pane -R")
	end
end, { desc = "Navigate right" })

-- Picker
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	Snacks.picker.grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Help tags" })
vim.keymap.set("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git status" })

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

-- Todo Comments
vim.keymap.set("n", "<leader>ft", function()
	Snacks.picker.todo_comments()
end, { desc = "Find todos" })
vim.keymap.set("n", "]t", '<Cmd>lua require("todo-comments").jump_next()<CR>', { desc = "Next todo" })
vim.keymap.set("n", "[t", '<Cmd>lua require("todo-comments").jump_prev()<CR>', { desc = "Previous todo" })

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gri", function()
			Snacks.picker.lsp_implementations()
		end, opts)
		vim.keymap.set("n", "grr", function()
			Snacks.picker.lsp_references()
		end, opts)
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opts)
	end,
})

-- LSP Restart
vim.keymap.set("n", "<leader>lr", "<Cmd>lsp restart<CR>", { desc = "Restart LSP" })

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
			vim.fn.system("tmux set-hook -uw pane-focus-in")
			vim.fn.system("tmux set-option -wu allow-rename")
			vim.fn.system("tmux set-option -w automatic-rename on")
			return
		end
		_G._claude_pane_id = nil
	end
	local pane_id = vim.fn.system('tmux split-window -h -l 50% -P -F "#{pane_id}" "claude"')
	_G._claude_pane_id = vim.trim(pane_id)
	vim.fn.system("tmux set-option -w allow-rename off")
	local hook = 'if-shell -F "#{==:#{pane_id},'
		.. _G._claude_pane_id
		.. '}" "rename-window claude" "set-option -w automatic-rename on"'
	vim.fn.system("tmux set-hook -w pane-focus-in '" .. hook .. "'")
	vim.fn.system("tmux rename-window claude")
end, { desc = "Claude Code" })

-- Terminal
local function toggle_terminal()
	Snacks.terminal(nil, {
		cwd = vim.fn.getcwd(),
		win = {
			position = "float",
			border = "rounded",
			width = 0.9,
			height = 0.9,
		},
	})
end
vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set({ "n", "t" }, "<M-j>", toggle_terminal, { desc = "Toggle terminal (Cmd+j)" })
vim.keymap.set("t", "<C-v>", "<C-\\><C-n>", { desc = "Terminal normal mode" })

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
