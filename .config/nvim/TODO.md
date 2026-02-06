# Neovim TODO

## 1. Native LSP Migration (Neovim 0.11+)

### Overview

Migrate from plugin-based LSP setup to Neovim 0.11+ native LSP API.

**Current:**
```
mason.nvim → mason-lspconfig.nvim → nvim-lspconfig → cmp-nvim-lsp
```

**Target:**
```
mason.nvim → vim.lsp.config() → vim.lsp.enable() → cmp-nvim-lsp
```

### Benefits

- Remove 2 plugins (nvim-lspconfig, mason-lspconfig)
- Simpler, more transparent configuration
- Better maintainability (native Neovim features)
- Slightly faster startup

### Risks

- No `ensure_installed` - manual `:MasonInstall` required
- Must write default configs (cmd, filetypes, root_markers) yourself

---

### Phase 1: Create `lsp/` Directory

Create `~/.config/nvim/lsp/` with individual server configs:

| File | Server |
|------|--------|
| `lua_ls.lua` | Lua |
| `vtsls.lua` | TypeScript/JavaScript (custom settings) |
| `eslint.lua` | ESLint |
| `cssls.lua` | CSS (unknownAtRules ignore) |
| `html.lua` | HTML |
| `jsonls.lua` | JSON |
| `marksman.lua` | Markdown |
| `taplo.lua` | TOML |
| `dockerls.lua` | Dockerfile |
| `docker_compose_language_service.lua` | Docker Compose |

**Example: `lsp/vtsls.lua`**
```lua
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  settings = {
    typescript = {
      tsserver = { maxTsServerMemory = 8092 },
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 5000,
        },
      },
      suggest = { completeFunctionCalls = true },
    },
    javascript = {
      tsserver = { maxTsServerMemory = 8092 },
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 5000,
        },
      },
      suggest = { completeFunctionCalls = true },
    },
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
}
```

---

### Phase 2: Update `config/lsp.lua`

```lua
-- Capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

-- Apply to all servers
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Enable servers
vim.lsp.enable({
  "lua_ls",
  "vtsls",
  "eslint",
  "cssls",
  "html",
  "jsonls",
  "marksman",
  "taplo",
  "dockerls",
  "docker_compose_language_service",
})

-- Diagnostics config
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" },
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
```

---

### Phase 3: Simplify `plugins/mason.lua`

Remove mason-lspconfig, keep only Mason:

```lua
return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end,
}
```

---

### Phase 4: Remove Old Files

- [ ] Delete `plugins/lsp.lua` (move diagnostics to `config/lsp.lua`)
- [ ] Remove `nvim-lspconfig` from dependencies
- [ ] Remove `mason-lspconfig.nvim` from dependencies

---

### Phase 5: Keymap Considerations (Optional)

Neovim 0.11+ default keymaps vs current:

| Function | Current | 0.11 Default | Decision |
|----------|---------|--------------|----------|
| Rename | `<leader>rn` | `grn` | Keep or migrate |
| Code Action | `<leader>ca` | `gra` | Keep or migrate |
| References | `gr` | `grr` | Migrate recommended |
| Implementation | `gi` | `gri` | Keep or migrate |

---

### References

- [Neovim 0.11 Native LSP](https://lugh.ch/switching-to-neovim-native-lsp.html)
- [Setting Up LSP Within Neovim v0.11](https://stephenvantran.com/posts/2025-10-29-setup-neovim-lsp-011/)
- [Configuring Neovim 0.11 LSP from scratch](https://blog.diovani.com/technology/2025/06/13/configuring-neovim-011-lsp.html)
- [Neovim LSP Docs](https://neovim.io/doc/user/lsp.html)

---

## 2. Claude Code Integration Improvements

### Overview

Optimize Neovim for AI coding agents (Claude Code, etc.) that modify files externally.

**Key requirement:** Files modified by Claude Code should be instantly reflected in Neovim.

### Current Status

Already configured in `autocmds.lua`:
- `autoread = true`
- `checktime` on `FocusGained`, `BufEnter`, `CursorHold`, `CursorHoldI`
- Neo-tree auto refresh on `FocusGained`, `TermLeave`

### Potential Improvements

#### 2.1 Add More Trigger Events

Update `autocmds.lua` to include `TermLeave` and `WinEnter`:

```lua
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave", "WinEnter" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
  pattern = { "*" },
})
```

#### 2.2 Skip Special Buffers

Avoid refreshing plugin buffers (diffview, neo-tree, etc.):

```lua
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave", "WinEnter" }, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      local buftype = vim.bo.buftype
      if buftype == "" then  -- Only normal buffers
        vim.cmd("checktime")
      end
    end
  end,
  pattern = { "*" },
})
```

#### 2.3 Diffview Refresh (Optional)

Add diffview refresh when files change:

```lua
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave" }, {
  callback = function()
    -- Neo-tree refresh (existing)
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if ok then
      vim.schedule(function()
        pcall(manager.refresh, "filesystem")
      end)
    end

    -- Diffview refresh (new)
    local dv_ok, dv_lib = pcall(require, "diffview.lib")
    if dv_ok then
      vim.schedule(function()
        local view = dv_lib.get_current_view()
        if view then
          pcall(view.update_files, view)
        end
      end)
    end
  end,
})
```

#### 2.4 File Path Yanking for Claude Code Context

Add keymaps to copy code with file location (useful for Claude Code context):

```lua
-- Yank relative path
vim.keymap.set("n", "<leader>yr", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  print("Yanked: " .. path)
end, { desc = "Yank relative path" })

-- Yank with line number
vim.keymap.set("n", "<leader>yl", function()
  local path = vim.fn.expand("%:.")
  local line = vim.fn.line(".")
  local result = path .. ":" .. line
  vim.fn.setreg("+", result)
  print("Yanked: " .. result)
end, { desc = "Yank path with line" })
```

#### 2.5 Native fs_event Watching (Advanced, Optional)

Use Neovim's native `uv.fs_event` for real-time file watching:

```lua
-- This is more complex and may not be necessary
-- if the autocmd approach works well enough
```

### References

- [Tips for configuring Neovim for Claude Code](https://xata.io/blog/configuring-neovim-coding-agents)
- [Daniel Miessler's Claude Code + Neovim setup](https://danielmiessler.com/blog/claude-code-neovim-ghostty-integration)

---

## 3. Other Improvements (Lower Priority)

### 3.1 tiny-inline-diagnostic.nvim

Better inline diagnostic display for long messages:

```lua
{
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup()
    vim.diagnostic.config({ virtual_text = false })
  end,
}
```

- [GitHub: tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim)

### 3.2 mini.diff

Toggle-able diff overlay (alternative to gitsigns):

- [LazyVim mini-diff extra](https://lazyvim.github.io/extras/editor/mini-diff)

---

## Summary

| Priority | Task | Complexity |
|----------|------|------------|
| High | Native LSP Migration | High |
| Medium | Claude Code Integration | Low |
| Low | tiny-inline-diagnostic | Low |
| Low | mini.diff | Low |
