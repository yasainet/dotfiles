return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true,
			diff_opts = {
				filler = false,
			},
			view = {
				default = { layout = "diff2_horizontal" },
				merge_tool = { layout = "diff3_mixed" },
			},
			file_panel = {
				listing_style = "tree",
				win_config = { position = "left", width = 35 },
			},
			default_args = {
				DiffviewOpen = { "--imply-local" },
			},
		})
	end,
}
