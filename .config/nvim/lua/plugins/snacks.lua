return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		lazygit = { enabled = true },
		terminal = {
			enabled = true,
			win = {
				position = "float",
				border = "rounded",
			},
		},
	},
}
