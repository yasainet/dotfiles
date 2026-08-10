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
      jsonc = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      markdown = { "prettierd" },
      toml = { "taplo" },
      sh = { "shfmt" },
      zsh = { "shfmt_zsh" },
    },
    formatters = {
      shfmt_zsh = {
        inherit = "shfmt",
        prepend_args = { "-ln", "zsh" },
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 500 },
  },
}
