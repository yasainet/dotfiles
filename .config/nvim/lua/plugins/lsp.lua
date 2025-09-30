return {
  "neovim/nvim-lspconfig",
  dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Configure LSP server
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          telemetry = { enable = false },
        },
      },
    })

    -- Enable LSP server
    vim.lsp.enable("lua_ls")

    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        prefix = "●",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
      },
    })
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
