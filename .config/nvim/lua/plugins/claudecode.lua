return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("claudecode").setup({
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      terminal_cmd = nil,
      log_level = "info",
      track_selection = true,
      visual_demotion_delay_ms = 50,
      diff_opts = {
        auto_close_on_accept = true,
        show_diff_stats = true,
        vertical_split = true,
        open_in_current_tab = true,
      },
    })
  end,
}
