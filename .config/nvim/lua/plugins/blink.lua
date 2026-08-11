return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    completion = {
      ghost_text = {
        enabled = false,
      },
      menu = {
        border = "none",
      },
    },
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        "snippet_forward",
        function()
          if not package.loaded["copilot"] then
            return
          end
          local suggestion = require("copilot.suggestion")
          if suggestion.is_visible() then
            suggestion.accept()
            return true
          end
        end,
        "fallback",
      },
    },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
  end,
}
