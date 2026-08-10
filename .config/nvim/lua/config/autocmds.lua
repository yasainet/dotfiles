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
