---@diagnostic disable: undefined-global

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim" },
  },
  opts = {
    debug = false,
    show_help = true,
    show_folds = true,
    auto_follow_cursor = false,
    auto_insert_mode = false,
    clear_chat_on_new_prompt = false,

    window = {
      layout = "vertical",
      width = 0.3,
      border = "single",
      title = "Copilot Chat",
    },

    mappings = {
      close = {
        normal = "q",
        insert = "<C-c>",
      },
      reset = {
        normal = "<C-l>",
        insert = "<C-l>",
      },
      submit_prompt = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      accept_diff = {
        normal = "<C-y>",
        insert = "<C-y>",
      },
    },
  },

  keys = {
    {
      "<leader>cc",
      function()
        vim.ui.input({ prompt = "Chat: " }, function(input)
          if input and input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end)
      end,
      desc = "CopilotChat - Quick chat",
    },
    {
      "<leader>ct",
      function()
        require("CopilotChat").toggle()
      end,
      desc = "CopilotChat - Toggle chat window",
    },
    {
      "<leader>ce",
      function()
        require("CopilotChat").ask("Explain this code.")
      end,
      desc = "CopilotChat - Explain code",
    },
    {
      "<leader>cr",
      function()
        require("CopilotChat").ask("Review this code.")
      end,
      desc = "CopilotChat - Review code",
    },
  },
}
