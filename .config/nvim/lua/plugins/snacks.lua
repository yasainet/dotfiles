return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		lazygit = {
			enabled = true,
			win = {
				width = 0,
				height = 0,
			},
		},
		terminal = {
			enabled = true,
			win = {
				position = "float",
				border = "rounded",
			},
		},
	},
}
