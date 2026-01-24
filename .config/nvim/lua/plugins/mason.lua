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
		dependencies = { "mason.nvim", "nvim-lspconfig", "nvim-cmp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = true,
			}

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"vtsls",
					"eslint",
					"html",
					"cssls",
					"jsonls",
					"marksman",
					"taplo",
					"dockerls",
					"docker_compose_language_service",
				},
				automatic_installation = true,
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["vtsls"] = function()
						require("lspconfig").vtsls.setup({
							capabilities = capabilities,
							settings = {
								typescript = {
									tsserver = { maxTsServerMemory = 8092 },
									experimental = {
										completion = {
											enableServerSideFuzzyMatch = true,
											entriesLimit = 5000,
										},
									},
									suggest = { completeFunctionCalls = true },
								},
								javascript = {
									tsserver = { maxTsServerMemory = 8092 },
									experimental = {
										completion = {
											enableServerSideFuzzyMatch = true,
											entriesLimit = 5000,
										},
									},
									suggest = { completeFunctionCalls = true },
								},
								vtsls = {
									autoUseWorkspaceTsdk = true,
								},
							},
						})
					end,
				},
			})
		end,
	},
}
