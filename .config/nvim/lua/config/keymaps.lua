-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Insert mode Emacs-style
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Move forward" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete character" })
vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Kill to end of line" })
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Next line" })
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Previous line" })

-- Search
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { silent = true })

-- Yank
vim.keymap.set("n", "<leader>y", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Yanked full path" })
end, { desc = "Yank full path" })

-- Quit
vim.keymap.set({ "n", "x" }, "<leader>qq", "<Cmd>qa!<CR>", { desc = "Quit all (force)" })

-- LSP
-- TODO: fix
vim.keymap.set("n", "<leader>lr", function()
  local log = vim.fn.stdpath("state") .. "/lsp-restart.log"
  local lines = {
    "==== " .. os.date("%Y-%m-%d %H:%M:%S") .. " " .. vim.api.nvim_buf_get_name(0) .. " ft=" .. vim.bo.filetype,
    "clients: " .. table.concat(
      vim.tbl_map(function(c)
        return c.name
      end, vim.lsp.get_clients({ bufnr = 0 })),
      ", "
    ),
  }
  vim.list_extend(lines, vim.split(vim.fn.execute("messages"), "\n"))
  vim.fn.writefile(lines, log, "a")
  vim.cmd("lsp restart")
end, { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>li", "<Cmd>checkhealth vim.lsp<CR>", { desc = "LSP Info" })
