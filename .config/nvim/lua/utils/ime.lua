local M = {}

local cached_status = ""
local timer = nil

local function update_ime_status()
  vim.system({ 'macism' }, { text = true }, function(obj)
    if obj.code == 0 then
      local result = obj.stdout:gsub("\n$", "")
      if result == "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese" then
        cached_status = "あ"
      elseif result == "com.apple.keylayout.ABC" then
        cached_status = "_A"
      else
        cached_status = ""
      end
    end
  end)
end

M.start_timer = function()
  if timer then
    return
  end

  update_ime_status()

  -- 1000 ms
  timer = vim.uv.new_timer()
  timer:start(1000, 1000, vim.schedule_wrap(update_ime_status))
end

M.get_status = function()
  return cached_status
end

M.stop_timer = function()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

return M
