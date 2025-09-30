return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  config = function()
    require("toggleterm").setup({
      size = 16,
      open_mapping = nil,
      hide_numbers = true,
      start_in_insert = true,
      close_on_exit = true,
      direction = "horizontal",
    })

    -- Bottom terminal using toggleterm
    local Terminal = require("toggleterm.terminal").Terminal
    local bottom_term = Terminal:new({
      direction = "horizontal",
      hidden = true,
    })

    function _G.toggle_bottom_terminal()
      bottom_term:toggle()
    end

    -- Right terminal using native vim split
    local right_term_bufnr = nil
    local right_term_winnr = nil

    function _G.toggle_right_terminal()
      -- Check if terminal window exists and is valid
      if right_term_winnr and vim.api.nvim_win_is_valid(right_term_winnr) then
        vim.api.nvim_win_close(right_term_winnr, false)
        right_term_winnr = nil
      else
        -- Calculate 35% of screen width
        local width = math.floor(vim.o.columns * 0.35)

        -- Create vertical split
        vim.cmd("botright vsplit")
        right_term_winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(right_term_winnr, width)

        -- Reuse existing terminal buffer or create new one
        if right_term_bufnr and vim.api.nvim_buf_is_valid(right_term_bufnr) then
          vim.api.nvim_win_set_buf(right_term_winnr, right_term_bufnr)
        else
          vim.cmd("terminal")
          right_term_bufnr = vim.api.nvim_get_current_buf()
        end

        -- Start in insert mode
        vim.cmd("startinsert")
      end
    end

    -- Keymaps
    vim.keymap.set("n", "<Leader>tt", "<Cmd>lua toggle_bottom_terminal()<CR>", { desc = "Toggle bottom terminal" })
    vim.keymap.set("n", "<Leader>tr", "<Cmd>lua toggle_right_terminal()<CR>", { desc = "Toggle right terminal" })

    -- Exit terminal mode easily
    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  end,
}
