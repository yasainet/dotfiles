-- TODO: 透過されていない
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
					ignored = true,
					follow_file = true,
					git_status = true,
					diagnostics = true,
					layout = {
						layout = {
							position = "left",
							width = 30,
						},
					},
					exclude = { ".DS_Store" },
					actions = {
						copy_path = function(_, item)
							if item then
								local path = item._path or item.file
								if path then
									vim.fn.setreg("+", path)
									vim.notify("Copied: " .. path)
								end
							end
						end,
					},
					win = {
						list = {
							keys = {
								-- TODO: 実行されない
								["Y"] = { "copy_path", desc = "Copy path to clipboard" },
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
		terminal = {
			enabled = true,
		},
	},
}
