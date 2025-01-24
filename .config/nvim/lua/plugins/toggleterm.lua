---@diagnostic disable: undefined-global

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    open_mapping = [[<C-\>]],
    direction = 'float',
    float_opts = {
      border = 'curved',
    },
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    auto_scroll = true,
  },

  config = function(_, opts)
    require("toggleterm").setup(opts)

    function _G.set_terminal_keymaps()
      local keymap_opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], keymap_opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], keymap_opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], keymap_opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], keymap_opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
