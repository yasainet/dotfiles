---@diagnostic disable: undefined-global

return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      numhl = false,
      linehl = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
    })
  end,
}
