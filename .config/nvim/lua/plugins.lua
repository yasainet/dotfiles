---@diagnostic disable: undefined-global

-- telescoop? fzf
-- comment系
-- git 差分表示
-- lazygit
-- copilot
-- lsp
-- nvim-cmp
-- im-select


-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏"
      }
    },
  },
  {
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
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    keys = {
      { "<leader>e",  ":NvimTreeToggle<CR>",      desc = "Toggle NvimTree" },
      { "<leader>tf", ":NvimTreeFocus<CR>",       desc = "Focus NvimTree" },
      { "<leader>tb", ":NvimTreeFocus<CR><C-w>p", desc = "Focus back to editor" },
      { "<leader>tr", ":NvimTreeRefresh<CR>",     desc = "Refresh NvimTree" },
      { "<leader>tf", ":NvimTreeFindFile<CR>",    desc = "Find file in NvimTree" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "markdown",
          "markdown_inline",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        auto_install = true,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        numhl = false,
        linehl = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      show_help = true,
      show_folds = true,
      auto_follow_cursor = false,
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,

      window = {
        layout = "vertical",
        width = 0.3,
        border = "single",
        title = "Copilot Chat",
      },

      mappings = {
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
      },
    },

    keys = {
      {
        "<leader>cc",
        function()
          vim.ui.input({ prompt = "Chat: " }, function(input)
            if input and input ~= "" then
              require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
            end
          end)
        end,
        desc = "CopilotChat - Quick chat",
      },

      {
        "<leader>ct",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "CopilotChat - Toggle chat window",
      },

      {
        "<leader>ce",
        function()
          require("CopilotChat").ask("Explain this code.")
        end,
        desc = "CopilotChat - Explain code",
      },

      {
        "<leader>cr",
        function()
          require("CopilotChat").ask("Review this code.")
        end,
        desc = "CopilotChat - Review code",
      },
    },
  }
})
