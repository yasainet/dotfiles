---@diagnostic disable: undefined-global

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
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
    })

    vim.cmd([[cab cc CodeCompanion]])
  end,
}
