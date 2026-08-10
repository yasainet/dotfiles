-- Keep buffers in sync with files changed outside Neovim

local watchers = {}

local function is_file(buf)
  return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function reload(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not is_file(buf) then
    return
  end

  if vim.api.nvim_get_option_value("modified", { buf = buf }) then
    return
  end

  vim.cmd("silent! checktime " .. buf)
end

local function stop(buf)
  local handle = watchers[buf]
  if not handle then
    return
  end
  pcall(function()
    handle:stop()
    if not handle:is_closing() then
      handle:close()
    end
  end)
  watchers[buf] = nil
end

local function start(buf)
  if watchers[buf] or not vim.api.nvim_buf_is_valid(buf) or not is_file(buf) then
    return
  end

  local file = vim.api.nvim_buf_get_name(buf)
  local dir = vim.fs.dirname(file)
  local name = vim.fs.basename(file)
  if not dir or dir == "" or not vim.uv.fs_stat(dir) then
    return
  end

  local handle = vim.uv.new_fs_event()
  if not handle then
    return
  end

  local started = handle:start(
    dir,
    {},
    vim.schedule_wrap(function(err, fname, status)
      if err then
        stop(buf)
        return
      end
      if fname and fname ~= name then
        return
      end
      if status and status.rename then
        vim.defer_fn(function()
          reload(buf)
        end, 50)
        return
      end
      reload(buf)
    end)
  )

  if started then
    watchers[buf] = handle
  else
    handle:close()
  end
end

local function update()
  local loaded = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and is_file(buf) then
      loaded[buf] = true
    end
  end

  for buf in pairs(watchers) do
    if not loaded[buf] or not vim.api.nvim_buf_is_valid(buf) then
      stop(buf)
    end
  end

  for buf in pairs(loaded) do
    local unwatched = not watchers[buf]
    start(buf)
    if unwatched then
      reload(buf)
    end
  end
end

local group = vim.api.nvim_create_augroup("autoreload", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "FocusGained" }, {
  group = group,
  callback = update,
})

vim.api.nvim_create_autocmd("BufFilePost", {
  group = group,
  callback = function(args)
    stop(args.buf)
    update()
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = group,
  callback = function(args)
    stop(args.buf)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    for buf in pairs(watchers) do
      stop(buf)
    end
  end,
})

update()
