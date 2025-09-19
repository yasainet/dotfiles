return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = "claude_code",
        },
        agent = {
          adapter = "claude_code",
        },
      },
      adapters = {
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "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",
              },
            })
          end,
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = 0.3,
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>",     desc = "CodeCompanion Actions" },
    { "<leader>ci", "<cmd>CodeCompanion<cr>",            desc = "CodeCompanion Inline" },
    { "<leader>cc", "<cmd>CodeCompanionChat Add<cr>",    mode = "v",                        desc = "Add to CodeCompanion Chat" },
  },
}
