return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		explorer = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					hidden = true,
					layout = { layout = { width = 26, min_width = 26 } },
				},
				files = { hidden = true },
			},
		},
	},
}
