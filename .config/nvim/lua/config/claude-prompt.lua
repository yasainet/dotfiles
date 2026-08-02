-- Claude Code の Ctrl+G で開く prompt バッファに、直近の回答を差し込む。
--
-- Claude Code 標準の "Show last response in external editor" は 50 行で省略されるため、
-- transcript の jsonl から全文を読み直して置き換える。
-- 区切りより上は書き込み直前に捨てるので、prompt として送られるのは下だけ。

local SEPARATOR = "--- ここから下に prompt を書く (この行より上は送信されない) ---"
local SCRIPT = vim.fn.expand("~/.config/herdr/scripts/claude-transcript.py")

local function last_response()
	local pane = vim.env.HERDR_PANE_ID
	if not pane or pane == "" then
		return nil
	end
	local out = vim.fn.systemlist({ "python3", SCRIPT, "--pane", pane, "--last" })
	if vim.v.shell_error ~= 0 or #out == 0 then
		return nil
	end
	return out
end

local function strip_above_separator(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local cut = nil
	for i, line in ipairs(lines) do
		if line == SEPARATOR then
			cut = i
		end
	end
	if cut then
		vim.api.nvim_buf_set_lines(bufnr, 0, cut, false, {})
	end
end

local function setup(bufnr)
	local response = last_response()
	if not response then
		return
	end

	local existing = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local lines = vim.list_extend({}, response)
	vim.list_extend(lines, { "", SEPARATOR, "" })
	vim.list_extend(lines, existing)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	-- 読むための表示にする。折り返さないと日本語の長文が画面外に消える
	vim.wo.wrap = true
	vim.wo.linebreak = true
	vim.bo.filetype = "markdown"

	-- カーソルは prompt 側に置き、区切りが画面内に残る位置まで送る
	local pos = #response + 3
	vim.api.nvim_win_set_cursor(0, { math.min(pos, #lines), 0 })
	vim.cmd("normal! zz")

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			strip_above_separator(bufnr)
		end,
	})
end

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("ClaudePrompt", { clear = true }),
	pattern = "claude-prompt-*.md",
	callback = function(ev)
		setup(ev.buf)
	end,
})
