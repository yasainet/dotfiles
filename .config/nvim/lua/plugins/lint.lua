return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- textlint
    local textlint_dir = vim.fn.expand("~/.config/textlint")

    lint.linters["markdownlint-cli2"].args = {
      "--config",
      vim.fn.expand("~/.config/markdownlint/.markdownlint.jsonc"),
      "-",
    }

    lint.linters.textlint = {
      cmd = textlint_dir .. "/node_modules/.bin/textlint",
      stdin = true,
      args = {
        "--config",
        textlint_dir .. "/.textlintrc.json",
        "--rules-base-directory",
        textlint_dir .. "/node_modules",
        "--format",
        "compact",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      },
      ignore_exitcode = true,
      parser = require("lint.parser").from_pattern(
        "[^:]+: line (%d+), col (%d+), (%a+) %- (.+)",
        { "lnum", "col", "severity", "message" },
        { Error = vim.diagnostic.severity.ERROR },
        { source = "textlint" }
      ),
    }

    lint.linters_by_ft = {
      zsh = { "zsh" },
      markdown = { "markdownlint-cli2", "textlint" },
      dockerfile = { "hadolint" },
      ["yaml.ghaction"] = { "actionlint" },
    }

    -- FileChangedShellPost
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "FileChangedShellPost" }, {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function(args)
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_call(args.buf, function()
            lint.try_lint()
          end)
        end
      end,
    })
  end,
}
