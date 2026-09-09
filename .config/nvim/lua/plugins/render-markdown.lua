return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  opts = {
    file_types = { "markdown", "octo" },
    sign = { enabled = false },
    heading = { icons = { "" }, position = "inline" },
  },
}
