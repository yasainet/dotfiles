return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			preset = "helix",
			expand = function()
				return true
			end,
		})
	end,
}
