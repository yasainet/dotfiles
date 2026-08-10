return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent",
    },
  },
  opts = {
    explorer = { enabled = true },
    indent = {
      enabled = true,
      scope = { enabled = false },
    },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      icons = {
        git = {
          staged = "",
          added = "",
          deleted = "",
          ignored = "",
          modified = "",
          renamed = "",
          unmerged = "",
          untracked = "",
        },
      },
      sources = {
        explorer = {
          hidden = true,
          diagnostics = false,
          exclude = { ".DS_Store" },
          layout = {
            hidden = { "input" },
            layout = { width = 26, min_width = 26 },
          },
        },
        files = { hidden = true, exclude = { ".DS_Store" } },
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    -- picker icon
    local util = require("snacks.util")
    local icon = util.icon
    util.icon = function(name, cat, o)
      if cat == "file" then
        name = vim.fs.basename(name)
        -- .envrc, .env.*
        name = name:match("^%.env") and ".env" or name
      end
      return icon(name, cat, o)
    end
  end,
}
