return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	opts = {
		enable_diagnostics = false,
		popup_border_style = "rounded",
		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				show_hidden_count = false,
				never_show = {
					".DS_Store",
				},
			},
			use_libuv_file_watcher = true,
		},
		window = {
			width = 30,
			position = "left",
			mappings = {
				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node.path
						vim.fn.setreg("+", path)
						vim.notify("Copied: " .. path)
					end,
					desc = "Copy path to clipboard",
				},
			},
		},
		close_if_last_window = true,
		default_component_configs = {
			git_status = {
				symbols = {
					added = "",
					modified = "",
					deleted = "",
					renamed = "",
					untracked = "",
					ignored = "",
					unstaged = "",
					staged = "",
					conflict = "",
					-- added = "+",
					-- modified = "~",
					-- deleted = "-",
					-- renamed = "»",
					-- untracked = "?",
					-- ignored = "◌",
					-- unstaged = "●",
					-- staged = "✓",
					-- conflict = "!",
				},
			},
		},
	},
}
