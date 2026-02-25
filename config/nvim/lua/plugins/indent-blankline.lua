return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "│",
			tab_char = "│",
		},
		scope = {
			enabled = false,
		},
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"snacks_picker_explorer",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"lazyterm",
			},
		},
	},
}
