return {
	"lmilojevicc/herdr-splits.nvim",
	cond = vim.env.HERDR_ENV == "1",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<C-h>",
			function()
				require("herdr-splits").move_cursor_left()
			end,
			mode = { "n", "t" },
			desc = "Nav left",
		},
		{
			"<C-j>",
			function()
				require("herdr-splits").move_cursor_down()
			end,
			mode = { "n", "t" },
			desc = "Nav down",
		},
		{
			"<C-k>",
			function()
				require("herdr-splits").move_cursor_up()
			end,
			mode = { "n", "t" },
			desc = "Nav up",
		},
		{
			"<C-l>",
			function()
				require("herdr-splits").move_cursor_right()
			end,
			mode = { "n", "t" },
			desc = "Nav right",
		},
		{
			"<M-h>",
			function()
				require("herdr-splits").resize_left()
			end,
			mode = { "n", "t" },
			desc = "Resize left",
		},
		{
			"<M-j>",
			function()
				require("herdr-splits").resize_down()
			end,
			mode = { "n", "t" },
			desc = "Resize down",
		},
		{
			"<M-k>",
			function()
				require("herdr-splits").resize_up()
			end,
			mode = { "n", "t" },
			desc = "Resize up",
		},
		{
			"<M-l>",
			function()
				require("herdr-splits").resize_right()
			end,
			mode = { "n", "t" },
			desc = "Resize right",
		},
	},
}
