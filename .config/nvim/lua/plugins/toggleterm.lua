return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<c-\>]],
      on_open = function()
      end,
    })

    -- Toggle
    vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm 1 direction=horizontal<cr>",
      { desc = "Toggle horizontal terminal" })
    -- VSplit
    vim.keymap.set("n", "<leader>tv", "<cmd>rightbelow vsplit term://zsh<cr>", { desc = "Split terminal vertically" })
    -- Exit
    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  end,
}
