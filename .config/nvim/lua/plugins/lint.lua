return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters.textlint = {
			cmd = "textlint",
			stdin = true,
			args = {
				"--format",
				"json",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = function(output, _)
				local diagnostics = {}
				if output == nil or output == "" then
					return diagnostics
				end
				local ok, decoded = pcall(vim.json.decode, output)
				if not ok or type(decoded) ~= "table" or not decoded[1] then
					return diagnostics
				end
				local severity_map = {
					[1] = vim.diagnostic.severity.WARN,
					[2] = vim.diagnostic.severity.ERROR,
				}
				for _, msg in ipairs(decoded[1].messages or {}) do
					local lnum = (msg.line or 1) - 1
					local col = (msg.column or 1) - 1
					table.insert(diagnostics, {
						lnum = lnum,
						col = col,
						end_lnum = lnum,
						end_col = col + 1,
						severity = severity_map[msg.severity] or vim.diagnostic.severity.WARN,
						source = "textlint",
						message = msg.message,
						code = msg.ruleId,
					})
				end
				return diagnostics
			end,
		}

		lint.linters_by_ft = {
			dockerfile = { "hadolint" },
			markdown = { "textlint" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
