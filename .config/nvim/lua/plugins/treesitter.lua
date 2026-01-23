return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"lua",
			"vim",
			"vimdoc",
			"markdown",
			"markdown_inline",
			"comment",
			"typescript",
			"tsx",
			"javascript",
			"jsx",
			"html",
			"css",
			"json",
			"sql",
			"yaml",
			"toml",
			"bash",
			"dockerfile",
			"gitignore",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
