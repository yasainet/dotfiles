-- NOTE: 停止中
-- Forces Space to insert a half-width space while typing Japanese.

local JAPANESE = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"

local KEY_SPACE = 49

local RESET_KEYS = {
	[36] = true, -- Return
	[76] = true, -- Enter
	[102] = true, -- 英数
	[104] = true, -- かな
	[53] = true, -- Escape
	[48] = true, -- Tab
}

local KEY_DELETE = 51

local TEXT_ROLES = {
	AXTextField = true,
	AXTextArea = true,
	AXComboBox = true,
	AXSearchField = true,
}

-- 未確定の打鍵数。打鍵数 >= 表示文字数なので、変換中に誤って 0 になることはない
local pending = 0

local function isCharacterKey(code)
	local name = hs.keycodes.map[code]
	return type(name) == "string" and utf8.len(name) == 1
end

local function isTextFocused()
	local element = hs.uielement.focusedElement()
	return element ~= nil and TEXT_ROLES[element:role()] == true
end

local keyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
	local code = event:getKeyCode()
	local f = event:getFlags()

	if code == KEY_SPACE then
		if pending == 0 and not (f.shift or f.cmd or f.ctrl or f.alt or f.fn) and isTextFocused() then
			event:setFlags({ shift = true })
		end
		return false
	end

	if RESET_KEYS[code] then
		pending = 0
	elseif code == KEY_DELETE then
		if f.cmd or f.alt then
			pending = 0
		else
			pending = math.max(0, pending - 1)
		end
	elseif not (f.cmd or f.ctrl or f.alt) and isCharacterKey(code) then
		pending = pending + 1
	end

	return false
end)

-- クリックによる確定を検知する
local clickTap = hs.eventtap.new(
	{ hs.eventtap.event.types.leftMouseDown, hs.eventtap.event.types.rightMouseDown },
	function()
		pending = 0
		return false
	end
)

local function sync()
	pending = 0
	if hs.keycodes.currentSourceID() == JAPANESE then
		keyTap:start()
		clickTap:start()
	else
		keyTap:stop()
		clickTap:stop()
	end
end

hs.keycodes.inputSourceChanged(sync)
sync()

local appWatcher = hs.application.watcher.new(function(_, event)
	if event == hs.application.watcher.activated then
		pending = 0
	end
end)
appWatcher:start()

return { keyTap = keyTap, clickTap = clickTap, appWatcher = appWatcher }
