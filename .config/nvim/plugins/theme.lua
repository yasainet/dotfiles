---@diagnostic disable: undefined-global
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true, -- Keep transparent for consistency with init.lua
    })

    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
