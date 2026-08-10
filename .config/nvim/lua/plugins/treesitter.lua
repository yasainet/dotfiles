return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({ "html", "css", "javascript", "typescript", "tsx", "yaml", "sql" })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if vim.treesitter.get_parser(args.buf, nil, { error = false }) then
          vim.treesitter.start(args.buf)
        end
      end,
    })
  end,
}
