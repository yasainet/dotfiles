return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    completion = {
      ghost_text = {
        enabled = true,
      },
      menu = {
        border = "none",
      },
    },
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
    },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
  end,
}
