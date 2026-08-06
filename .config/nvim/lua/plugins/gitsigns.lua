local function relative_time(ts)
	local diff = os.time() - (tonumber(ts) or os.time())
	local units = {
		{ 31536000, "y" },
		{ 2592000, "mo" },
		{ 604800, "w" },
		{ 86400, "d" },
		{ 3600, "h" },
		{ 60, "m" },
	}
	for _, unit in ipairs(units) do
		if diff >= unit[1] then
			return string.format("%d%s ago", math.floor(diff / unit[1]), unit[2])
		end
	end
	return "just now"
end

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "█" },
				change = { text = "█" },
				delete = { text = "▁" },
				topdelete = { text = "▔" },
				changedelete = { text = "█" },
				untracked = { text = "█" },
			},
			signs_staged = {
				add = { text = "█" },
				change = { text = "█" },
				delete = { text = "▁" },
				topdelete = { text = "▔" },
				changedelete = { text = "█" },
				untracked = { text = "█" },
			},
			signs_staged_enable = true,
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = function(name, blame_info)
				if blame_info.author == name or blame_info.author == "Not Committed Yet" then
					return {}
				end
				return {
					{
						string.format(
							" %s, %s - %s",
							blame_info.author,
							relative_time(blame_info.author_time),
							blame_info.summary
						),
						"GitSignsCurrentLineBlame",
					},
				}
			end,
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil,
			max_file_length = 40000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})
	end,
}
