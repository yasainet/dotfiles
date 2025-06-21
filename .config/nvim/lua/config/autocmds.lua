-- Theme transparency
local function set_transparency()
  vim.cmd("highlight Normal guibg=NONE")
  -- neo-tree
  vim.cmd("highlight NeoTreeNormal guibg=NONE")
  vim.cmd("highlight NeoTreeNormalNC guibg=NONE")
  vim.cmd("highlight NeoTreeEndOfBuffer guibg=NONE")
  vim.cmd("highlight NeoTreeWinSeparator guibg=NONE")
  -- terminal
  vim.cmd("highlight Terminal guibg=NONE")
  vim.cmd("highlight TerminalNormal guibg=NONE")
  vim.cmd("highlight FloatBorder guibg=NONE")
  vim.cmd("highlight NormalFloat guibg=NONE")
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    set_transparency()
  end
})

-- neo-tree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    set_transparency()
    if vim.fn.argc() == 0 then
      vim.cmd("Neotree show")
    end
  end
})
