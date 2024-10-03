vim.opt.encoding = "utf-8"
vim.opt.langmenu = "en"
vim.cmd("language en_US")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 10000
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.laststatus = 2
vim.opt.clipboard:append({ 'unnamedplus' })
vim.keymap.set('v', '<D-c>', '"+y')
vim.keymap.set('n', '<D-c>', '"+y')
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.mouse = "a"

-- lazy.nvim のセットアップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",  -- 最新の安定版
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Catppuccin カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        transparent_background = true,    -- 背景透過を有効化
      })
      vim.cmd.colorscheme "catppuccin"    -- テーマを設定
    end,
  },

  -- Telescope ファジーファインダー
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup()
    end,
  },

  -- Lualine ステータスライン
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin',
          icons_enabled = false,
        },
      })
    end,
  },

  -- Gitsigns Git 統合
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Null-ls コードフォーマッタとリンタ
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier, -- Prettier を使用
          null_ls.builtins.diagnostics.eslint,  -- ESLint を使用
        }
      })
    end,
  },

  -- Comment.nvim コメント操作
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  -- Autopairs 自動括弧補完
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup{}
    end,
  },

  -- Treesitter 構文解析とハイライト
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- 自動的に最新のパーサをダウンロード
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = "all", -- すべての言語をインストール
        highlight = {
          enable = true,          -- 構文ハイライトを有効化
        },
        indent = {
          enable = true,          -- 自動インデントを有効化
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- テキストオブジェクトで先を見通す
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
})
