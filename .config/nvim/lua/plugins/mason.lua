return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "marksman",
      "vtsls",
      "eslint",
      "postgres_lsp",
      "taplo",
      "bashls",
      "docker_language_server",
      "jsonls",
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
