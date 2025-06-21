---@diagnostic disable: undefined-global

-- Theme transparency
local function set_transparency()
  vim.cmd("highlight Normal guibg=NONE")
  -- Neo-tree transparency
  vim.cmd("highlight NeoTreeNormal guibg=NONE")
  vim.cmd("highlight NeoTreeNormalNC guibg=NONE")
  vim.cmd("highlight NeoTreeEndOfBuffer guibg=NONE")
  vim.cmd("highlight NeoTreeWinSeparator guibg=NONE")
end

-- Apply transparency on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = set_transparency
})

-- Apply transparency when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_transparency
})
