---@diagnostic disable: undefined-global

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = "dark",
        floats = "dark",
      }
    })

    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
