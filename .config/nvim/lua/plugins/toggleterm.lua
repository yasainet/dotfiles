return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      start_in_insert = true,
      direction = "float",
      float_opts = {
        border = "curved",
      },
    })
  end,
}
