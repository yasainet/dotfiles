local function pretty_path(status, component)
  component.hl_cache = component.hl_cache or {}
  if not component.hl_cache.file then
    local utils = require("lualine.utils.utils")
    component.hl_cache.file = component:create_hl({ fg = utils.extract_highlight_colors("Bold", "fg") }, "filename")
    component.hl_cache.dir = component:create_hl({ fg = utils.extract_highlight_colors("NonText", "fg") }, "dirname")
  end
  local file = component:format_hl(component.hl_cache.file)
  local dir, name = status:match("^(.*/)([^/]*)$")
  if not dir then
    return file .. status .. component:get_default_hl()
  end
  return component:format_hl(component.hl_cache.dir) .. dir .. file .. name .. component:get_default_hl()
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_b = { "branch" },
      lualine_c = {
        {
          "diagnostics",
          symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, shorting_target = 60, fmt = pretty_path },
      },
      lualine_x = {
        {
          "diff",
          symbols = { added = "+", modified = "~", removed = "-" },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },
    },
  },
}
