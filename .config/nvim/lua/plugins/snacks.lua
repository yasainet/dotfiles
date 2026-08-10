return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    -- Explorer
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },

    -- find & grep
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
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo Comments",
    },
    -- gh
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gai",
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = "C[a]lls Incoming",
    },
    {
      "gao",
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = "C[a]lls Outgoing",
    },
    -- Other
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    -- TODO: あとで整理する
    -- {
    --   "<leader>gg",
    --   function()
    --     Snacks.lazygit()
    --   end,
    --   desc = "Lazygit",
    -- },
    -- {
    --   "<c-/>",
    --   function()
    --     Snacks.terminal()
    --   end,
    --   desc = "Toggle Terminal",
    -- },
    -- {
    --   "<c-_>",
    --   function()
    --     Snacks.terminal()
    --   end,
    --   desc = "which_key_ignore",
    -- },
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
      layout = { fullscreen = true },
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
            fullscreen = false,
            hidden = { "input" },
            layout = { width = 26, min_width = 26 },
          },
        },
        files = { hidden = true, exclude = { ".DS_Store" } },
        select = { layout = { fullscreen = false } },
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
