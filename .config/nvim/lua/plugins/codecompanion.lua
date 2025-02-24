return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      display = {
        chat = {
          window = {
            width = 0.3,
          }
        }
      },
      opts = {
        language = "Japanese"
      },
      adapters = {
        path = {
          select = function()
            return require("telescope.builtin").find_files()
          end,
        },
      },
    })

    vim.cmd([[cab cc CodeCompanion]])
  end,
}
