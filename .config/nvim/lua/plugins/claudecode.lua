return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		require("claudecode").setup({
			split_side = "right",
			split_width_percentage = 0.35,
			diff_opts = {
				keep_terminal_focus = true,
			},
			terminal = {
				provider = "snacks",
				snacks_win_opts = {
					keys = {
						nav_h = {
							"<C-h>",
							function()
								vim.cmd("wincmd h")
							end,
							mode = "t",
							desc = "Go to left window",
						},
						nav_l = {
							"<C-l>",
							function()
								vim.cmd("wincmd l")
							end,
							mode = "t",
							desc = "Go to right window",
						},
					},
				},
			},
		})
	end,
}
