return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
    -- Configure diagnostic display
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- LSP keymaps helper function with conditional mapping
    local function setup_lsp_keymaps(client, bufnr)
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
      end

      local function supports_method(method)
        return client.supports_method(method)
      end

      -- Navigation keymaps
      if supports_method("textDocument/definition") then
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      end

      if supports_method("textDocument/declaration") then
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
      end

      if supports_method("textDocument/implementation") then
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
      end

      if supports_method("textDocument/typeDefinition") then
        map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
      end

      if supports_method("textDocument/references") then
        map("n", "gr", vim.lsp.buf.references, "Show references")
      end

      -- Documentation keymaps
      if supports_method("textDocument/hover") then
        map("n", "K", vim.lsp.buf.hover, "Show hover documentation")
      end

      if supports_method("textDocument/signatureHelp") then
        map("n", "gK", vim.lsp.buf.signature_help, "Show signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Show signature help")
      end

      -- Code action keymaps
      if supports_method("textDocument/codeAction") then
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      end

      if supports_method("textDocument/rename") then
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
      end

      -- Formatting keymaps
      if supports_method("textDocument/formatting") then
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format document")
      end

      if supports_method("textDocument/rangeFormatting") then
        map("v", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format selection")
      end

      -- Workspace keymaps
      if supports_method("workspace/symbol") then
        map("n", "<leader>cw", vim.lsp.buf.workspace_symbol, "Workspace symbols")
      end

      -- Diagnostic keymaps (always available)
      map("n", "<leader>cd", vim.diagnostic.open_float, "Show diagnostics")
      map("n", "[d", function() 
        vim.diagnostic.jump({ count = -1 }) 
      end, "Previous diagnostic")
      map("n", "]d", function() 
        vim.diagnostic.jump({ count = 1 }) 
      end, "Next diagnostic")
      map("n", "<leader>cl", vim.diagnostic.setloclist, "Diagnostics to location list")

      -- Document highlight
      if supports_method("textDocument/documentHighlight") then
        local highlight_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end

    -- Enable LSP keymaps when LSP attaches to buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
          setup_lsp_keymaps(client, event.buf)
        end
      end,
    })
  end,
}
