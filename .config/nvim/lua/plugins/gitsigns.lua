return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {
    signs = {
      add = { text = "█" },
      change = { text = "█" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "█" },
      untracked = { text = "█" },
    },
    signs_staged = {
      add = { text = "█" },
      change = { text = "█" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "█" },
      untracked = { text = "█" },
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next hunk")
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous hunk")

      -- Actions
      map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk (toggle)")
      map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
      map("x", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk (toggle)")
      map("x", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")
      map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
      map("n", "<leader>hp", gitsigns.preview_hunk_inline, "Preview hunk inline")
      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hd", gitsigns.diffthis, "Diff this")
      map("n", "<leader>hB", gitsigns.toggle_current_line_blame, "Toggle line blame")

      -- Text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk, "Hunk")
    end,
  },
}
