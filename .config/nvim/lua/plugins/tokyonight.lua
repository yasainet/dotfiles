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
				sidebars = "transparent",
				floats = "transparent",
			},
			plugins = {
				auto = true,
			},
			on_highlights = function(hl, c)
				-- HACK: JSX/TSX
				hl["@tag.tsx"] = { fg = c.cyan }
				hl["@tag.javascript"] = { fg = c.cyan }
				-- HACK: html
				hl["@tag.builtin.tsx"] = { fg = c.red }
				hl["@tag.builtin.javascript"] = { fg = c.red }
			end,
		})
		vim.cmd([[colorscheme tokyonight-night]])
	end,
}
