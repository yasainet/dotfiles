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
    -- search
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments({ hidden = true })
      end,
      desc = "Todo Comments",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>sn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notifications",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
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
      "grr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "References",
    },
    -- Terminal
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
      mode = { "n", "t" },
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
      mode = { "n", "t" },
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
      "<leader>bD",
      function()
        Snacks.bufdelete.all({ wipe = true })
      end,
      desc = "Delete All Buffers",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
  },
  opts = {
    explorer = { enabled = true },
    image = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false },
      scope = { enabled = true },
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
          auto_close = true,
          hidden = true,
          diagnostics = false,
          exclude = { ".DS_Store" },
          layout = {
            fullscreen = false,
            hidden = { "input" },
            layout = { width = 26, min_width = 26 },
          },
          win = {
            list = {
              keys = {
                -- Close
                ["<Esc>"] = false,
                -- Preview
                ["P"] = false,
                -- herdr
                ["<c-j>"] = false,
                ["<c-k>"] = false,
              },
            },
          },
        },
        files = { hidden = true, exclude = { ".DS_Store" } },
        select = { layout = { fullscreen = false } },
      },
    },
    terminal = {
      win = {
        position = "float",
        border = "rounded",
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
    -- explorer
    vim.api.nvim_create_autocmd("FocusGained", {
      group = vim.api.nvim_create_augroup("snacks_explorer_refresh", { clear = true }),
      callback = function()
        for _, picker in ipairs(Snacks.picker.get({ source = "explorer" })) do
          picker:action("explorer_update")
        end
      end,
    })
  end,
}
