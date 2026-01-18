return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			expand = function()
				return true
			end,
		})
	end,
}
