return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		explorer = {
			enabled = true,
			replace_netrw = true,
		},
		picker = {
			hidden = true,
			ignored = false,
			exclude = { "node_modules", ".git", ".next", ".vercel", "package-lock.json" },
			sources = {
				explorer = {
					hidden = true,
					ignored = false,
					follow_file = true,
					git_status = true,
					diagnostics = false,
					config = function(opts)
						local actions = require("snacks.explorer.actions")
						local original_confirm = actions.actions.confirm
						function actions.actions.confirm(picker, item, action)
							local was_searching = picker.input.filter.meta.searching
							original_confirm(picker, item, action)
							if was_searching then
								vim.cmd("stopinsert")
							end
						end
						return require("snacks.picker.source.explorer").setup(opts)
					end,
					format = function(item, picker)
						local ret = {}
						if item.parent then
							vim.list_extend(ret, Snacks.picker.format.tree(item, picker))
						end
						if item.status then
							Snacks.picker.format.file_git_status(item, picker)
						end
						vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
						return ret
					end,
					layout = {
						hidden = { "input" },
						auto_hide = { "input" },
						preview = false,
						layout = {
							position = "left",
							width = 30,
						},
					},
					exclude = { ".DS_Store" },
					win = {
						list = {
							keys = {
								["<C-v>"] = { "edit_vsplit", mode = { "n" } },
								["<C-s>"] = { "edit_split", mode = { "n" } },
								["P"] = "none", -- Disable preview
								["<esc>"] = "none",
							},
						},
					},
				},
			},
		},
		lazygit = {
			enabled = true,
			win = {
				width = 0,
				height = 0,
			},
		},
		indent = {
			enabled = true,
			indent = {
				char = "│",
			},
			scope = {
				enabled = false,
			},
		},
		image = {
			enabled = true,
			backend = "kitty",
		},
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 0, padding = 1 },
				{ section = "startup" },
			},
		},
		input = {
			enabled = true,
		},
		bigfile = {
			enabled = true,
		},
		quickfile = {
			enabled = true,
		},
		terminal = {
			enabled = true,
		},
	},
}
