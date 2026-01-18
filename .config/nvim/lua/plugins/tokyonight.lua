return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night",
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
				functions = {},
				variables = {},
				sidebars = "dark",
				floats = "dark",
			},
			plugins = {
				auto = true,
			},
			-- NeoTreeRootName
			on_highlights = function(hl, _)
				hl.NeoTreeRootName = { bold = true, italic = false }
			end,
		})
		vim.cmd([[colorscheme tokyonight-night]])
	end,
}
