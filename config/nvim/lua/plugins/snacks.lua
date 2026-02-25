---@diagnostic disable: undefined-global
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
			sources = {
				explorer = {
					hidden = true,
					ignored = false,
					follow_file = true,
					git_status = true,
					diagnostics = false,
					format = function(item, picker)
						local ret = {}
						if item.parent then
							vim.list_extend(ret, Snacks.picker.format.tree(item, picker))
						end
						-- side effect only: sets item.filename_hl for git coloring
						if item.status then
							Snacks.picker.format.file_git_status(item, picker)
						end
						-- filename with icon (git coloring applied via item.filename_hl)
						vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
						return ret
					end,
					layout = {
						layout = {
							position = "left",
							width = 30,
						},
					},
					exclude = { ".DS_Store" },
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
		terminal = {
			enabled = true,
		},
	},
}
