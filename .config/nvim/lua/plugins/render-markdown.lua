return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    file_types = { "markdown", "markdown.gh", "octo" },
    sign = { enabled = false },
    heading = { icons = {} },
  },
}
