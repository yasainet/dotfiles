return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "octo" },
	opts = {
		file_types = { "markdown", "octo" },
		sign = { enabled = false },
		heading = { icons = { "", "", "", "", "", "" }, position = "inline" },
	},
	config = function(_, opts)
		vim.treesitter.language.register("markdown", "octo")
		require("render-markdown").setup(opts)
	end,
}
