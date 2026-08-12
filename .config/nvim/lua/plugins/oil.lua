return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      desc = "Open parent directory",
    },
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = false,
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    -- file icon
    local devicons = require("nvim-web-devicons")
    local get_icon = devicons.get_icon
    devicons.get_icon = function(name, ext, o)
      -- .envrc, .env.*
      name = name:match("^%.env") and ".env" or name
      return get_icon(name, ext, o)
    end
  end,
}
