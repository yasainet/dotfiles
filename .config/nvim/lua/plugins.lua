---@diagnostic disable: undefined-global

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
      direction = "float",
      float_opts = {
        border = "curved"
      }
    },
    config = function()
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
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
        status_formatter = nil, -- Use default
      })
    end,
  },
})
