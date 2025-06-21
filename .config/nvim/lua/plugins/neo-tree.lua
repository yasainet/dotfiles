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
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = true,
        show_hidden_count = false,
        hide_by_name = {
          "node_modules",
          ".git",
          ".DS_Store"
        },
        always_show = {
          ".gitignore"
        },
        always_show_by_pattern = {
          ".env*"
        }
      }
    },
    use_libuv_file_watcher = true,
    window = {
      width = 30,
      position = "left",
      auto_expand_width = true,
      mappings = {
        ["H"] = "toggle_hidden",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["a"] = "add",
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["R"] = "refresh",
        ["/"] = "fuzzy_finder",
      }
    },
    close_if_last_window = false,
    enable_git_status = true,
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
    }
  },
}
