-- snacks.image の穴を埋める
--
-- どちらも snacks の内部に手を入れる。更新して画像が出なくなったらここを疑う。
--
-- 1. 動画のポスター表示
--    snacks は formats に mp4 等を含むが、変換は magick 固定である。
--    magick の video delegate は ffmpeg を噛ませる作りで、実際には復号に失敗する。
--    buf.attach を包み、動画なら ffmpeg で起こした PNG に差し替える。
--    explorer のプレビューと Enter は共に buf.attach を通るため、これ一箇所で足りる。
--
-- 2. 閉じた画像の再送
--    snacks は Image をファイル単位で使い回す。placement が全て閉じると
--    端末側の画像は削除されるが、sent フラグは立ったままになる。
--    そのため同じ画像を再び開いても再送されず、プレースホルダだけが残る。
--
-- 3. 開き直したバッファへの再アタッチ
--    2 度目に開くバッファは読み込み済みなので BufReadCmd が発火せず、
--    消えた placement が作り直されない。extmark が空なら張り直す。

local video = { mp4 = true, mov = true, avi = true, mkv = true, webm = true }

local cache = vim.fn.stdpath("cache") .. "/video-poster"

---@param src string
---@return boolean
local function is_video(src)
	return video[vim.fn.fnamemodify(src, ":e"):lower()] == true
end

---@param src string
---@return string
local function poster_path(src)
	local stat = vim.uv.fs_stat(src)
	local key = vim.fn.sha256(src .. ":" .. (stat and stat.mtime.sec or 0))
	return cache .. "/" .. key:sub(1, 16) .. ".png"
end

---@param buf number
---@param lines string[]
local function show_error(buf, lines)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "markdown"
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].modified = false
end

---@param src string
---@param cb fun(png: string?, err: string?)
local function poster(src, cb)
	local png = poster_path(src)
	if vim.uv.fs_stat(png) then
		return cb(png)
	end
	if vim.fn.executable("ffmpeg") == 0 then
		return cb(nil, "`ffmpeg` が見つかりません")
	end

	vim.fn.mkdir(cache, "p")
	vim.system({
		"ffmpeg",
		"-hide_banner",
		"-loglevel",
		"error",
		"-y",
		"-i",
		src,
		"-frames:v",
		"1",
		"-vf",
		"scale='min(1920,iw)':-2",
		-- PNG は端末へ送る前に base64 化されるので圧縮しても無駄
		"-compression_level",
		"1",
		png,
	}, {}, function(out)
		vim.schedule(function()
			cb(out.code == 0 and png or nil, out.stderr)
		end)
	end)
end

local function patch_video()
	local ok, buf = pcall(require, "snacks.image.buf")
	if not ok or type(buf.attach) ~= "function" then
		return
	end
	local attach = buf.attach
	buf.attach = function(b, opts)
		opts = opts or {}
		local src = opts.src or vim.api.nvim_buf_get_name(b)
		if not is_video(src) then
			return attach(b, opts)
		end
		poster(src, function(png, err)
			if not png then
				return show_error(b, vim.split("# Video Poster Failed\n\n```\n" .. (err or "") .. "\n```", "\n"))
			end
			attach(b, vim.tbl_extend("force", opts, { src = png }))
		end)
	end
end

local function patch_resend()
	local ok, Image = pcall(require, "snacks.image.image")
	if not ok or type(Image.del) ~= "function" then
		return
	end
	local del = Image.del
	Image.del = function(self, pid)
		del(self, pid)
		if not next(self.placements or {}) then
			self.sent = false
		end
	end
end

local function patch_reattach()
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = vim.api.nvim_create_augroup("snacks_image_reattach", { clear = true }),
		callback = function(ev)
			if vim.bo[ev.buf].filetype ~= "image" then
				return
			end
			local ok, placement = pcall(require, "snacks.image.placement")
			if not ok or not placement.ns then
				return
			end
			-- 描画は debounce される。落ち着いてから見ないと直前の状態を拾う
			vim.defer_fn(function()
				if not vim.api.nvim_buf_is_valid(ev.buf) then
					return
				end
				-- extmark と行数は残るが、中身が空文字列になることがある
				local marks = vim.api.nvim_buf_get_extmarks(ev.buf, placement.ns, 0, -1, { details = true })
				for _, m in ipairs(marks) do
					local d = m[4] or {}
					for _, chunk in ipairs(d.virt_text or {}) do
						if #chunk[1] > 0 then
							return
						end
					end
					for _, line in ipairs(d.virt_lines or {}) do
						for _, chunk in ipairs(line) do
							if #chunk[1] > 0 then
								return
							end
						end
					end
				end
				require("snacks.image.buf").attach(ev.buf)
			end, 100)
		end,
	})
end

return {
	"folke/snacks.nvim",
	-- opts は setup の直前に呼ばれる。BufReadCmd の登録は setup の中なので、
	-- ここで包めば起動引数に動画を渡した場合も間に合う
	opts = function(_, opts)
		patch_video()
		patch_resend()
		patch_reattach()
		return opts
	end,
}
