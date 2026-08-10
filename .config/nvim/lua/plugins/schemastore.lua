return {
  "b0o/schemastore.nvim",
  lazy = false,
  config = function()
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
}
