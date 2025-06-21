return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "eslint",
          "html",
          "cssls",
          "jsonls",
          "marksman",
          "taplo",
        },
        automatic_installation = true,
      })
    end,
  },
}
