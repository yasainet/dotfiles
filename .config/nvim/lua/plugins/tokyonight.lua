return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
    },
    on_highlights = function(hl, c)
      -- snacks picker
      hl.FloatBorder = { bg = c.bg_float, fg = "#589ED7" }
      -- snacks explorer
      hl.SnacksPickerGitStatusUntracked = { fg = c.green }
      -- gitsigns
      hl.GitSignsAdd = { fg = c.green }
      hl.GitSignsChange = { fg = c.yellow }
      hl.GitSignsDelete = { fg = c.red }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
