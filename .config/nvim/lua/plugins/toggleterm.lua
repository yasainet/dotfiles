return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<c-\>]],
      on_open = function()
        vim.opt_local.signcolumn = "no"
        vim.schedule(function()
          -- Find neo-tree window and reset viewport
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "neo-tree" then
              vim.api.nvim_win_call(win, function()
                vim.cmd("normal! gg")
              end)
            end
          end
        end)
      end,
      on_close = function()
        vim.schedule(function()
          -- Find neo-tree window and reset viewport
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "neo-tree" then
              vim.api.nvim_win_call(win, function()
                vim.cmd("normal! gg")
              end)
            end
          end
        end)
      end,
    })

    -- Toggle
    vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm 1 direction=horizontal<cr>",
      { desc = "Toggle horizontal terminal" })
    -- VSplit
    vim.keymap.set("n", "<leader>tv", "<cmd>vsplit term://zsh<cr>", { desc = "Split terminal vertically" })
    -- Exit
    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  end,
}
