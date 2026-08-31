return {
  "neovim/nvim-lspconfig",
  init = function()
    vim.lsp.config("marksman", { filetypes = { "markdown" } })

    -- Copilot
    vim.lsp.config("*", {
      capabilities = {
        general = {
          positionEncodings = { "utf-16" },
        },
      },
    })
  end,
}
