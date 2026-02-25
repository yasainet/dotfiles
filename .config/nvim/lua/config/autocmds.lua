-- Theme transparency
local function set_transparency()
	vim.cmd("highlight Normal guibg=NONE")
	-- snacks explorer
	-- vim.cmd("highlight SnacksPickerExplorerNormal guibg=NONE")
	-- vim.cmd("highlight SnacksPickerExplorerNormalNC guibg=NONE")
	-- vim.cmd("highlight SnacksPickerExplorerEndOfBuffer guibg=NONE")
	-- vim.cmd("highlight SnacksPickerExplorerWinSeparator guibg=NONE")
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		set_transparency()
	end,
})

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
