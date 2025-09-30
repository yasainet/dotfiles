local M = {}

-- Get current IME
M.get_status = function()
  local handle = io.popen("macism")
  if not handle then
    return ""
  end

  local result = handle:read("*a")
  handle:close()

  result = result:gsub("\n$", "")

  if result == "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese" then
    return "あ"
  elseif result == "com.apple.keylayout.ABC" then
    return "_A"
  else
    return ""
  end
end

return M

