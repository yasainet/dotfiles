return {
	"nvim-tree/nvim-web-devicons",
	lazy = false,
	config = function()
		local devicons = require("nvim-web-devicons")
		devicons.setup({})

		local get_icon = devicons.get_icon
		devicons.get_icon = function(name, ext, opts)
			if type(name) == "string" then
				local base = name:match("[^/]+$")
				if base then
					-- .env*
					base = base:match("^%.env") and ".env" or base
					local icon, hl = get_icon(base, nil, { default = false })
					if icon then
						return icon, hl
					end
				end
			end
			return get_icon(name, ext, opts)
		end
	end,
}
