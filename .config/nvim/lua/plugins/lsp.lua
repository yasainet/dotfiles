return {
	"neovim/nvim-lspconfig",
	dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				prefix = "●",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = true,
			},
		})
	end,
}
