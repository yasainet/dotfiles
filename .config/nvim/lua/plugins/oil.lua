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
    keymaps = {
      -- split
      ["<C-h>"] = false,
      ["<C-s>"] = false,
      -- tab
      ["<C-t>"] = false,
      -- refresh
      ["<C-l>"] = false,
      ["gr"] = "actions.refresh",
    },
    view_options = {
      show_hidden = false,
      is_always_hidden = function(name, _)
        return name == ".DS_Store"
      end,
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
