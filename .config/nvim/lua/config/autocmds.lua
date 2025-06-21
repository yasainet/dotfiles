---@diagnostic disable: undefined-global

-- Theme transparency
local function set_transparency()
  vim.cmd("highlight Normal guibg=NONE")
  vim.cmd("highlight NeoTreeNormal guibg=NONE")
  vim.cmd("highlight NeoTreeNormalNC guibg=NONE")
  vim.cmd("highlight NeoTreeEndOfBuffer guibg=NONE")
  vim.cmd("highlight NeoTreeWinSeparator guibg=NONE")
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = set_transparency
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_transparency
})

-- neo-tree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("Neotree show")
  end
})
