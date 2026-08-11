local function lsp_hl()
  if vim.lsp.status() ~= "" then
    return "DiagnosticWarn"
  elseif #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    return nil
  end
  return "DiagnosticError"
end

local function lsp_color()
  local group = lsp_hl()
  if not group then
    return nil
  end
  local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
  if not fg then
    return nil
  end
  return { fg = string.format("#%06x", fg) }
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.api.nvim_create_autocmd({ "LspProgress", "LspAttach", "LspDetach" }, {
      group = vim.api.nvim_create_augroup("lualine_lsp_status", { clear = true }),
      callback = function()
        vim.cmd.redrawstatus()
      end,
    })
  end,
  opts = {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_b = { "branch" },
      lualine_c = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1 },
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
        {
          function()
            return "⚡︎"
          end,
          color = lsp_color,
          on_click = function()
            vim.cmd.checkhealth("vim.lsp")
          end,
        },
        {
          "diagnostics",
          symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
        },
      },
    },
  },
}
