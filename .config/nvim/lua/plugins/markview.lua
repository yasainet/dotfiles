return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local presets = require("markview.presets")

		local headings = vim.tbl_deep_extend("force", presets.headings.marker, {
			heading_1 = { sign = false },
			heading_2 = { sign = false },
			heading_3 = { sign = false },
			heading_4 = { sign = false },
			heading_5 = { sign = false },
			heading_6 = { sign = false },
		})

		require("markview").setup({
			markdown = {
				headings = headings,
				horizontal_rules = presets.horizontal_rules.thin,
				tables = vim.tbl_deep_extend("force", presets.tables.rounded, {
					use_virt_lines = true,
				}),
				code_blocks = {
					sign = false,
				},
			},
		})
	end,
}
