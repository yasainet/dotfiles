return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"denols",
				"eslint",
				"cssls",
				"html",
				"jsonls",
				"taplo",
				"dockerls",
				"docker_compose_language_service",
				"basedpyright",
				"ruff",
				"tailwindcss",
				"ruby_lsp",
			},
			automatic_enable = true,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- Formatters
				"stylua",
				"prettier",
				"eslint_d",
				"sql-formatter",
				-- Linters
				"hadolint",
			},
		},
	},
}
