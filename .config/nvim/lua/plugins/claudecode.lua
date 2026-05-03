return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
	},
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
}
