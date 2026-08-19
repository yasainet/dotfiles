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
      -- snacks indent scope
      hl.SnacksIndentScope = { fg = c.dark3, nocombine = true }
      -- snacks picker
      hl.FloatBorder = { bg = c.bg_float, fg = "#589ED7" }
      -- snacks explorer
      hl.SnacksPickerGitStatusUntracked = { fg = c.green }
      -- render-markdown
      hl["@markup.raw.markdown_inline"] = { fg = c.blue }
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
