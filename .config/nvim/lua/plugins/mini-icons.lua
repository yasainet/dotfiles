return {
  "nvim-mini/mini.icons",
  version = false,
  lazy = true,
  opts = {
    -- .env, .env.* は vim.filetype.match で env になる
    filetype = { env = { glyph = "\u{f462}", hl = "MiniIconsYellow" } },
    -- .envrc は sh 扱いなので直接指定
    file = { [".envrc"] = { glyph = "\u{f462}", hl = "MiniIconsYellow" } },
  },
  init = function()
    -- devicons 固定の plugin (lualine, octo) 向け
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
