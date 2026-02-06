-- Theme transparency
local function set_transparency()
	vim.cmd("highlight Normal guibg=NONE")
	-- neo-tree
	vim.cmd("highlight NeoTreeNormal guibg=NONE")
	vim.cmd("highlight NeoTreeNormalNC guibg=NONE")
	vim.cmd("highlight NeoTreeEndOfBuffer guibg=NONE")
	vim.cmd("highlight NeoTreeWinSeparator guibg=NONE")
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

-- Refresh neo-tree
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave" }, {
	callback = function()
		local ok, manager = pcall(require, "neo-tree.sources.manager")
		if ok then
			vim.schedule(function()
				pcall(manager.refresh, "filesystem")
			end)
		end
	end,
})

-- Refresh diffview
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave" }, {
	callback = function()
		local ok, lib = pcall(require, "diffview.lib")
		if ok then
			vim.schedule(function()
				local view = lib.get_current_view()
				if view then
					pcall(view.update_files, view)
				end
			end)
		end
	end,
})
