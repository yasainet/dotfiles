return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    require("smart-splits").setup({})
    vim.keymap.set({ "n", "t" }, "<C-h>", require("smart-splits").move_cursor_left)
    vim.keymap.set({ "n", "t" }, "<C-j>", require("smart-splits").move_cursor_down)
    vim.keymap.set({ "n", "t" }, "<C-k>", require("smart-splits").move_cursor_up)
    vim.keymap.set({ "n", "t" }, "<C-l>", require("smart-splits").move_cursor_right)
  end,
}
