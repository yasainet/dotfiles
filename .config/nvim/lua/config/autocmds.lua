-- Filetype
vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["tsconfig.json"] = "jsonc",
    ["jsconfig.json"] = "jsonc",
  },
  pattern = {
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.ghaction",
    ["^tsconfig%..*%.json$"] = "jsonc",
  },
})

-- Diagnostics
local diagnostics = vim.api.nvim_create_augroup("diagnostics", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = diagnostics,
  callback = function(args)
    vim.b[args.buf].on_disk = true
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  group = diagnostics,
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.b[buf].on_disk and vim.bo[buf].buftype == "" and not vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf)) then
        vim.diagnostic.reset(nil, buf)
        vim.b[buf].on_disk = false
      end
    end
  end,
})

-- ESLint autofix on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("eslint_fix", { clear = true }),
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "eslint" })
    if #clients > 0 then
      vim.cmd("LspEslintFixAll")
    end
  end,
})
