return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			tabline = {
				lualine_a = { "tabs" },
			},
			options = {
				always_show_tabline = false,
				theme = "tokyonight",
				globalstatus = true,
				component_separators = "",
				section_separators = "",
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
						fmt = function(str)
							local bufname = vim.api.nvim_buf_get_name(0)
							if bufname:match("^term://.*:claude") then
								return "Claude Code"
							end
							return str
						end,
					},
				},
				lualine_x = {
					{
						"lsp_status",
						ignore_lsp = { "GitHub Copilot", "eslint", "stylua" },
					},
					"encoding",
					{
						"fileformat",
						symbols = {
							unix = "LF",
							dos = "CRLF",
							mac = "CR",
						},
					},
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
