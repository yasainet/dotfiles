return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  event = "VeryLazy",
  config = function()
    local ime = require("utils.ime")

    -- Start background timer for IME status updates
    ime.start_timer()

    require("lualine").setup({
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_x = {
          {
            ime.get_status,
            color = function()
              local status = ime.get_status()
              if status == "あ" then
                return { fg = "#f7768e" }
              elseif status == "_A" then
                return { fg = "#9ece6a" }
              end
              return nil
            end
          },
          "encoding",
          "fileformat",
          "filetype"
        },
        lualine_y = { "progress" },
        lualine_z = {
          "location",
          function()
            return os.date("%H:%M")
          end
        }
      }
    })
  end
}
