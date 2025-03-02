return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help", "terminal", "packer", "neo-tree" },
      dim_inactive = false,
      lualine_bold = false,

      on_colors = function(colors)
      end,

      on_highlights = function(highlights, colors)
              highlights.NeoTreeNormal = {
                bg = "NONE",
                fg = colors.fg,
              }
              highlights.NeoTreeNormalNC = {
                bg = "NONE",
                fg = colors.fg,
              }
              highlights.NeoTreeEndOfBuffer = {
                bg = "NONE",
                fg = colors.bg_dark,
              }

              highlights.NeoTreeWinSeparator = {
                bg = "NONE",
                fg = colors.border,
              }

              highlights.WinSeparator = {
                bg = "NONE",
                fg = colors.border,
              }

              highlights.NormalFloat = {
                bg = "NONE",
              }

              highlights.FloatBorder = {
                bg = "NONE",
                fg = colors.border,
              }
            end,
          })

          -- テーマを適用
          vim.cmd([[colorscheme tokyonight]])
        end,
      }
