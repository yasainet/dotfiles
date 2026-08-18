return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd_jsonc" },
      html = { "prettierd" },
      css = { "prettierd" },
      markdown = { "prettierd" },
      toml = { "taplo" },
      yaml = { "prettierd" },
      sh = { "shfmt" },
      zsh = { "shfmt_zsh" },
      dockerfile = { "dockerfmt" },
    },
    formatters = {
      prettierd_jsonc = {
        inherit = "prettierd",
        prepend_args = { "--trailing-comma=none" },
      },
      shfmt_zsh = {
        inherit = "shfmt",
        prepend_args = { "-ln", "zsh" },
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)) == "lazy-lock.json" then
        return
      end
      return { timeout_ms = 500 }
    end,
  },
}
