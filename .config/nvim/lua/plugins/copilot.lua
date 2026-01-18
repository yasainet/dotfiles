return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_filetypes = {
			["*"] = true,
			["env"] = false,
			["gitcommit"] = false,
			["markdown"] = true,
			["yaml"] = true,
			["sql"] = true,
			["typescript"] = true,
			["typescriptreact"] = true,
		}

		-- Ensure .env* files are disabled
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = { "*.env", "*.env.*", ".env*" },
			callback = function()
				vim.b.copilot_enabled = false
			end,
		})
	end,
}
