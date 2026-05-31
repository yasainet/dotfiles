-- Auto reload
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave", "WinEnter" }, {
	callback = function()
		if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
			vim.cmd("checktime")
		end
	end,
	pattern = { "*" },
})

-- Reload buffer
vim.api.nvim_create_autocmd("FileChangedShell", {
	callback = function()
		vim.v.fcs_choice = "reload"
	end,
})

-- Clear stale diagnostics on LSP detach (workaround for neovim/neovim#30385)
vim.api.nvim_create_autocmd("LspDetach", {
	callback = function(ev)
		local ns = vim.lsp.diagnostic.get_namespace(ev.data.client_id)
		vim.diagnostic.reset(ns, ev.buf)
	end,
})

-- ESLint: apply `eslint.applyAllFixes` on save (= Zed/VSCode の source.fixAll.eslint)
-- 非同期 code_action は保存に間に合わないため、request_sync で保存前に同期適用する
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.mjs", "*.cjs" },
	callback = function(ev)
		local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" })
		if #clients == 0 then
			return
		end
		pcall(function()
			clients[1]:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(ev.buf),
						version = vim.lsp.util.buf_versions[ev.buf],
					},
				},
			}, 3000, ev.buf)
		end)
	end,
})

-- Reload snacks explorer
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		local ok_g, Git = pcall(require, "snacks.explorer.git")
		if ok_g then
			for root in pairs(Git.state) do
				Git.state[root].last = 0
			end
		end
		local ok, snacks = pcall(require, "snacks")
		if ok and snacks.picker then
			for _, picker in ipairs(snacks.picker.get({ source = "explorer" })) do
				if not picker.closed then
					picker:action("explorer_update")
				end
			end
		end
	end,
})
