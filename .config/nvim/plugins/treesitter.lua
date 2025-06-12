return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "vim", "vimdoc" },  -- Neovim essential languages only
      auto_install = true,  -- Auto-install other languages when needed
      highlight = {
        enable = true,
      },
    })
  end,
}