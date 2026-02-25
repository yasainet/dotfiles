return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	cond = function()
		return #vim.api.nvim_list_uis() > 0
	end,
	config = function()
		require("claudecode").setup({
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
			},
			terminal = {
				provider = "none",
			},
		})
	end,
}
