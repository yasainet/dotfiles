return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop" },
      auto_session_use_git_branch = true, -- Branch-specific sessions
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_create_enabled = true,

      -- Session lens (telescope integration)
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<Leader>ss", "<Cmd>SessionSave<CR>", { desc = "Save session" })
    vim.keymap.set("n", "<Leader>sr", "<Cmd>SessionRestore<CR>", { desc = "Restore session" })
    vim.keymap.set("n", "<Leader>sd", "<Cmd>SessionDelete<CR>", { desc = "Delete session" })
    vim.keymap.set("n", "<Leader>sf", "<Cmd>Telescope session-lens<CR>", { desc = "Find sessions" })
  end,
}