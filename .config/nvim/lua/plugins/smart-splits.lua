return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    require("smart-splits").setup({
      ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
      ignored_filetypes = { 'NvimTree', 'neo-tree' },
      default_amount = 3,
      at_edge = 'wrap',
      multiplexer_integration = nil, -- Auto-detect tmux
    })

    -- Navigation keymaps (Ctrl + h/j/k/l)
    vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left split" })
    vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to bottom split" })
    vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to top split" })
    vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right split" })

    -- Resize keymaps (Ctrl + Arrow keys)
    vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left, { desc = "Resize split left" })
    vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down, { desc = "Resize split down" })
    vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up, { desc = "Resize split up" })
    vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right, { desc = "Resize split right" })
  end,
}