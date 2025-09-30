return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  opts = {
    popup_border_style = "rounded",
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        show_hidden_count = false,
      },
      use_libuv_file_watcher = false,
    },
    window = {
      width = 30,
      position = "left",
      auto_expand_width = false,
      mappings = {
        ["<space>"] = "toggle_node",
        ["<cr>"] = "open",
        ["H"] = "toggle_hidden",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["a"] = "add",
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["R"] = "refresh",
        ["/"] = "fuzzy_finder",
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["l"] = "focus_preview",
      }
    },
    close_if_last_window = true,
    default_component_configs = {
      git_status = {
        symbols = {
          added = "+",
          modified = "~",
          deleted = "-",
          renamed = "»",
          untracked = "?",
          ignored = "◌",
          unstaged = "●",
          staged = "✓",
          conflict = "!"
        }
      }
    },
    enable_git_status = true,
    enable_diagnostics = true,
  },
}
