return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
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
			},
		})
	end,
}
