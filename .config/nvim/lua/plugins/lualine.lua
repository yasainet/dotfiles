local function hl_fg(group)
  local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
  if not fg then
    return nil
  end
  return { fg = string.format("#%06x", fg) }
end

local function lsp_hl()
  if vim.lsp.status() ~= "" then
    return "DiagnosticWarn"
  elseif vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" or #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    return nil
  end
  return "DiagnosticError"
end

local function lsp_color()
  local group = lsp_hl()
  if not group then
    return nil
  end
  return hl_fg(group)
end

local function bold_filename(status, component)
  local bold = component:format_hl(component:create_hl({ gui = "bold" }, "filename"))
  local dir, name = status:match("^(.*/)([^/]*)$")
  if not dir then
    return bold .. status .. component:get_default_hl()
  end
  return dir .. bold .. name .. component:get_default_hl()
end

local function copilot_ok()
  local client = package.loaded["copilot.client"]
  if not client then
    return true
  end
  if client.is_disabled() or not client.get() then
    return false
  end
  return package.loaded["copilot.status"].data.status ~= "Warning"
end

local function copilot_color()
  if copilot_ok() then
    return nil
  end
  return hl_fg("DiagnosticError")
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
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      group = vim.api.nvim_create_augroup("lualine_copilot_status", { clear = true }),
      callback = function(ev)
        if ev.data ~= "copilot.lua" then
          return
        end
        require("copilot.status").register_status_notification_handler(function()
          vim.cmd.redrawstatus()
        end)
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
        {
          "diagnostics",
          symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, shorting_target = 60, fmt = bold_filename },
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
            return ""
          end,
          color = copilot_color,
          on_click = function()
            vim.cmd.Copilot("status")
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
      },
    },
  },
}
