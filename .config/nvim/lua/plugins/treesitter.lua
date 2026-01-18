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
		})

		-- Enable treesitter highlighting for all filetypes
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
