-- Syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "sh"
	end,
})

-- Auto reload
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave", "WinEnter" }, {
	callback = function()
		if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
			vim.cmd("checktime")
		end
	end,
	pattern = { "*" },
})

-- Refresh gitsigns when focus returns from external git tools (e.g. tmux lazygit popup)
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		local ok, gs = pcall(require, "gitsigns")
		if ok then
			gs.refresh()
		end
	end,
})
