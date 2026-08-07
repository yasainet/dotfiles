return {
	"hrsh7th/cmp-nvim-lsp",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.workspace = capabilities.workspace or {}
		capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

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
