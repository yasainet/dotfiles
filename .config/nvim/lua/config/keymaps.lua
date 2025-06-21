-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Search
vim.keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

-- Aliases
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- Mac Cmd
vim.keymap.set("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.keymap.set("n", "<D-v>", "\"+p", { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("n", "<D-z>", "u", { noremap = true, silent = true })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

-- Insert mode Emacs-style
vim.keymap.set('i', '<C-a>', '<Home>', { desc = 'Beginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'End of line' })
vim.keymap.set('i', '<C-b>', '<Left>', { desc = 'Move backward' })
vim.keymap.set('i', '<C-f>', '<Right>', { desc = 'Move forward' })
vim.keymap.set('i', '<C-d>', '<Del>', { desc = 'Delete character' })
vim.keymap.set('i', '<C-k>', '<C-o>D', { desc = 'Kill to end of line' })

-- Neo-tree
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")

-- Gitsigns
vim.keymap.set('n', ']h', '<Cmd>Gitsigns next_hunk<CR>')
vim.keymap.set('n', '[h', '<Cmd>Gitsigns prev_hunk<CR>')
vim.keymap.set('n', '<leader>hs', '<Cmd>Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>hr', '<Cmd>Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>hp', '<Cmd>Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>hb', '<Cmd>Gitsigns blame_line<CR>')
vim.keymap.set('n', '<leader>ht', '<Cmd>Gitsigns toggle_signs<CR>')
vim.keymap.set('n', '<leader>hd', '<Cmd>Gitsigns toggle_deleted<CR>')
vim.keymap.set('n', '<leader>hl', '<Cmd>Gitsigns toggle_linehl<CR>')
vim.keymap.set('n', '<leader>hn', '<Cmd>Gitsigns toggle_numhl<CR>')

-- ToggleTerm
vim.keymap.set('n', '<C-\\>', '<Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('t', '<C-\\>', '<C-\\><C-n><Cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })

-- Claude Code
vim.keymap.set('n', '<leader>ac', '<Cmd>ClaudeCode<CR>', { desc = 'Toggle Claude' })
vim.keymap.set('n', '<leader>af', '<Cmd>ClaudeCodeFocus<CR>', { desc = 'Focus Claude' })
vim.keymap.set('n', '<leader>ar', '<Cmd>ClaudeCode --resume<CR>', { desc = 'Resume Claude' })
vim.keymap.set('n', '<leader>aC', '<Cmd>ClaudeCode --continue<CR>', { desc = 'Continue Claude' })
vim.keymap.set('n', '<leader>ab', '<Cmd>ClaudeCodeAdd %<CR>', { desc = 'Add current buffer' })
vim.keymap.set('v', '<leader>as', '<Cmd>ClaudeCodeSend<CR>', { desc = 'Send to Claude' })
vim.keymap.set('n', '<leader>aa', '<Cmd>ClaudeCodeDiffAccept<CR>', { desc = 'Accept diff' })
vim.keymap.set('n', '<leader>ad', '<Cmd>ClaudeCodeDiffDeny<CR>', { desc = 'Deny diff' })

-- Telescope
vim.keymap.set('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = 'Help tags' })

-- Conform
vim.keymap.set('n', '<leader>lf', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format buffer' })

-- Todo Comments
vim.keymap.set('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', { desc = 'Find todos' })
vim.keymap.set('n', ']t', '<Cmd>lua require("todo-comments").jump_next()<CR>', { desc = 'Next todo' })
vim.keymap.set('n', '[t', '<Cmd>lua require("todo-comments").jump_prev()<CR>', { desc = 'Previous todo' })

-- Config reload
vim.keymap.set('n', '<leader>rr', function()
  for name, _ in pairs(package.loaded) do
    if name:match('^config') or name:match('^plugins') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  print('Config reloaded!')
end, { desc = 'Reload config' })
vim.keymap.set('n', '<leader>rc', '<Cmd>Lazy clear<CR>', { desc = 'Clear lazy cache' })
