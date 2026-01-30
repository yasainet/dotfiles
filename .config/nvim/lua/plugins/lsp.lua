return {
	"neovim/nvim-lspconfig",
	dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- HACK: CSS LSP
		vim.lsp.config.cssls = {
			settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		}

		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				prefix = "●",
			},
			signs = false,
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
