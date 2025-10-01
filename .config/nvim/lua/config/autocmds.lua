-- Theme transparency
local function set_transparency()
  vim.cmd("highlight Normal guibg=NONE")
  -- neo-tree
  vim.cmd("highlight NeoTreeNormal guibg=NONE")
  vim.cmd("highlight NeoTreeNormalNC guibg=NONE")
  vim.cmd("highlight NeoTreeEndOfBuffer guibg=NONE")
  vim.cmd("highlight NeoTreeWinSeparator guibg=NONE")
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    set_transparency()
  end
})
