---@diagnostic disable: undefined-global

-- Theme
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("highlight Normal guibg=NONE")
  end
})
