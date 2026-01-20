return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "eslint_d", "prettier" },
			typescript = { "eslint_d", "prettier" },
			javascriptreact = { "eslint_d", "prettier" },
			typescriptreact = { "eslint_d", "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			toml = { "taplo" },
			sql = { "sql_formatter" },
		},
		formatters = {
			sql_formatter = {
				prepend_args = { "-l", "postgresql" },
			},
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,
		},
	},
}
