---@diagnostic disable: undefined-global

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
  keys = {
    { "<leader>e",  ":NvimTreeToggle<CR>",      desc = "Toggle NvimTree" },
    { "<leader>tf", ":NvimTreeFocus<CR>",       desc = "Focus NvimTree" },
    { "<leader>tb", ":NvimTreeFocus<CR><C-w>p", desc = "Focus back to editor" },
    { "<leader>tr", ":NvimTreeRefresh<CR>",     desc = "Refresh NvimTree" },
    { "<leader>tf", ":NvimTreeFindFile<CR>",    desc = "Find file in NvimTree" },
  },
}
