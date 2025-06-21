return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  opts = {
    options = {
      theme = "tokyonight",
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000
      }
    },
  }
}
