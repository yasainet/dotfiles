return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				filetypes = {
					["*"] = true,
					["env"] = false,
					["gitcommit"] = false,
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = "zbirenbaum/copilot.lua",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
