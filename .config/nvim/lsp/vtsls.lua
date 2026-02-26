return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
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
}
