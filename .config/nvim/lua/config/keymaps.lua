-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Search
-- <Cmd> 形式にしないと cmdline mode を経由し CmdlineLeave (IME リセット) が毎 Esc で発火する
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { silent = true })

-- Quit
vim.keymap.set("n", "<leader>q", "<Cmd>qa!<CR>", { desc = "Quit all" })

-- Aliases
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Insert mode Emacs-style
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
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

-- Diffview
local function diff_against_origin_head()
	vim.fn.jobstart({ "git", "fetch", "--quiet" }, {
		on_exit = function()
			vim.schedule(function()
				local ref = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null"):gsub("\n", "")
				local branch = ref:match("refs/remotes/origin/(.+)")
				if not branch then
					vim.notify("No origin/HEAD set", vim.log.levels.WARN)
					return
				end
				vim.cmd("DiffviewOpen origin/" .. branch .. "...HEAD")
			end)
		end,
	})
end

vim.keymap.set("n", "<leader>gd", "<Cmd>DiffviewOpen<CR>", { desc = "Diff: working tree" })
vim.keymap.set("n", "<leader>gD", diff_against_origin_head, { desc = "Diff: vs origin default" })
vim.keymap.set("n", "<leader>gf", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })
vim.keymap.set("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "Diffview close" })

-- Window / pane navigation
local function nav(dir)
	local wincmd = ({ left = "h", down = "j", up = "k", right = "l" })[dir]
	local before = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. wincmd)
	if vim.api.nvim_get_current_win() == before then
		vim.system({ "herdr", "pane", "focus", "--direction", dir })
	end
end

for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	vim.keymap.set({ "n", "t" }, "<C-" .. key .. ">", function()
		nav(dir)
	end, { desc = "Nav " .. dir .. " (split → pane)" })
end

-- Marker file
-- TODO: watch smart-splits.nvim PR #467
local function herdr_marker_path()
	local pane = vim.env.HERDR_PANE_ID
	if not pane or pane == "" then
		return nil
	end
	local cache = vim.env.XDG_CACHE_HOME or (vim.env.HOME .. "/.cache")
	local dir = cache .. "/nvim-herdr"
	vim.fn.mkdir(dir, "p")
	return dir .. "/" .. pane
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local path = herdr_marker_path()
		if not path then
			return
		end
		local server = vim.v.servername
		if not server or server == "" then
			return
		end
		pcall(vim.fn.writefile, {
			"pid=" .. vim.fn.getpid(),
			"server=" .. server,
		}, path)
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local path = herdr_marker_path()
		if path then
			pcall(vim.fn.delete, path)
		end
	end,
})

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

-- LSP
vim.lsp.document_color.enable(false)
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
vim.keymap.set("n", "<leader>lr", function()
	vim.diagnostic.reset(nil, 0)
	vim.cmd("checktime")
	vim.cmd("lsp restart")
end, { desc = "Restart LSP" })

vim.keymap.set("n", "<leader>li", "<Cmd>checkhealth vim.lsp<CR>", { desc = "LSP info" })

-- Yank path
vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("Yanked: " .. path)
end, { desc = "Yank full path" })

-- Terminal
local function toggle_terminal()
	Snacks.terminal(nil, {
		cwd = vim.fn.getcwd(),
		win = {
			position = "float",
			border = "rounded",
			width = 0.95,
			height = 0.95,
		},
	})
end
vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_terminal, { desc = "Toggle terminal (C-/ fallback)" })

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
