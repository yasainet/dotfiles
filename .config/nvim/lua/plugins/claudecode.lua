return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		terminal = {
			split_side = "right",
			split_width_percentage = 0.45,
			provider = "snacks",
			auto_close = true,
		},
		diff_opts = {
			layout = "vertical",
			keep_terminal_focus = false,
		},
	},
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
		{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
		{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
		{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
