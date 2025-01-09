---@diagnostic disable: undefined-global

vim.opt.langmenu = "en"
vim.cmd("language en_US")
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 10000
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"

-- cursor
vim.opt.guicursor = {
  "n-v-c:block-blinkon100",
  "i-ci:ver25-blinkon100",
  "r-cr:hor20-blinkon100",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250",
  "sm:block-blinkon100"
}

-- alias
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})

-- cmd
vim.keymap.set("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.keymap.set("n", "<D-v>", "\"+p", { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })

-- leader
vim.g.mapleader = " "

-- NvimTree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tb", ":NvimTreeFocus<CR><C-w>p", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tf", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

-- ToggleTerm
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

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
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {}
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-latest",
        temperature = 0,
        max_tokens = 8192,
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
      },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "hrsh7th/nvim-cmp",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    config = function(_, opts)
      require("avante_lib").load()
      require("avante").setup(opts)
    end
  },
})
