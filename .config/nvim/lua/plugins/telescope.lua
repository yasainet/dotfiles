return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    }
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
    { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
  },
  config = function()
    local telescope = require('telescope')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          }
        },
        file_ignore_patterns = {
          "node_modules",
          ".git",
        },
      },
    })

    pcall(telescope.load_extension, 'fzf')
  end,
}
