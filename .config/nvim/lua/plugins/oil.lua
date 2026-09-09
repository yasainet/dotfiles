return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-mini/mini.icons" },
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
}
