return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      terminal = {
        win = {
          style = "terminal",
          backdrop = {
            transparent = true,
            blend = 60,
          },
        },
        interactive = true,
      },
      styles = {
        terminal = {
          backdrop = {
            transparent = true,
            blend = 60,
          },
        },
      },
    })
  end,
}
