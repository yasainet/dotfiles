local M = {}

function M.setup()
	-- Continue list markers on <CR>; runtime ftplugin disables it
	vim.opt_local.comments = "b:*,b:-,b:+,b:1.,n:>"
	vim.opt_local.formatoptions:append("r")

	-- <C-d> is remapped to <Del>, so dedent moves here
	vim.keymap.set("i", "<C-S-t>", "<C-d>", { buffer = true, desc = "Dedent" })
end

return M
