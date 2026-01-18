return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local function yank_diagnostic(prompt_bufnr)
			local entry = action_state.get_selected_entry()
			if entry then
				local text = string.format("%s:%d:%d: %s", entry.filename, entry.lnum, entry.col, entry.text)
				vim.fn.setreg("+", text)
				print("Yanked!")
			end
			actions.close(prompt_bufnr)
		end

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git/", ".next", ".vercel" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				buffers = {
					mappings = {
						n = { ["dd"] = actions.delete_buffer },
					},
				},
				diagnostics = {
					mappings = {
						n = { ["y"] = yank_diagnostic },
						i = { ["<C-y>"] = yank_diagnostic },
					},
				},
			},
		})
	end,
}
