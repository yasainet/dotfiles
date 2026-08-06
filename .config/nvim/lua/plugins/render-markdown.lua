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
		-- 既定の 140 は treesitter (100) を上回り、diff の行背景を塗り潰す
		code = { priority = 0 },
		heading = { icons = { "", "", "", "", "", "" }, position = "inline" },
	},
	config = function(_, opts)
		vim.treesitter.language.register("markdown", "octo")
		require("render-markdown").setup(opts)
	end,
}
