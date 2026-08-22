return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file/find" },
      { "<leader>h", group = "git hunks" },
      { "<leader>l", group = "lsp" },
      { "<leader>o", group = "octo" },
      { "<leader>q", group = "quit" },
      { "<leader>s", group = "search" },
      { "<leader>x", group = "diagnostics" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
