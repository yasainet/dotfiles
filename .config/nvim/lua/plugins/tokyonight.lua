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

    -- Disable italic for neo-tree directory names
    vim.schedule(function()
      local hl = vim.api.nvim_get_hl(0, { name = 'NeoTreeRootName' })
      hl.italic = false
      vim.api.nvim_set_hl(0, 'NeoTreeRootName', hl)

      hl = vim.api.nvim_get_hl(0, { name = 'NeoTreeDirectoryName' })
      hl.italic = false
      vim.api.nvim_set_hl(0, 'NeoTreeDirectoryName', hl)
    end)
  end,
}
