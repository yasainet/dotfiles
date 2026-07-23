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
				files = {
					hidden = true,
					layout = { fullscreen = true },
				},
				grep = {
					hidden = true,
					layout = { fullscreen = true },
				},
				buffers = {
					layout = { fullscreen = true },
				},
				recent = {
					layout = { fullscreen = true },
				},
				help = {
					layout = { fullscreen = true },
				},
				git_status = {
					layout = { fullscreen = true },
				},
				todo_comments = {
					layout = { fullscreen = true },
				},
				explorer = {
					hidden = true,
					ignored = false,
					follow_file = true,
					git_status = true,
					diagnostics = false,
					config = function(opts)
						-- config は explorer を開くたびに実行されるため、多重ラップをガードする
						local actions = require("snacks.explorer.actions")
						if not actions._confirm_patched then
							actions._confirm_patched = true
							local original_confirm = actions.actions.confirm
							function actions.actions.confirm(picker, item, action)
								local was_searching = picker.input.filter.meta.searching
								original_confirm(picker, item, action)
								if was_searching then
									vim.cmd("stopinsert")
								end
							end
						end

						-- Upstream bug: Git._update は node.status / ignored をクリアするが
						-- dir_status をクリアしない。untracked だった directory を commit すると
						-- 子 item に古い "??" が継承され続け、u や再オープンでも直らない。
						-- git status 更新のたびに dir_status を先にクリアして回避する
						local Git = require("snacks.explorer.git")
						local Tree = require("snacks.explorer.tree")
						if not Git._dir_status_patched then
							Git._dir_status_patched = true
							local original_update = Git._update
							if type(original_update) == "function" then
								function Git._update(cwd, ...)
									Tree:walk(Tree:find(cwd), function(n)
										n.dir_status = nil
									end, { all = true })
									return original_update(cwd, ...)
								end
							else
								vim.notify(
									"snacks.lua: Git._update が見つからないため dir_status ワークアラウンドを適用できません(snacks.nvim の更新で API が変わった可能性)",
									vim.log.levels.WARN
								)
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
							width = 25,
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
			doc = {
				enabled = false,
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
