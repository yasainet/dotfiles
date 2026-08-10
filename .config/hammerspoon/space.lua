-- Forces Space to insert a half-width space while typing Japanese.

local JAPANESE = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"

local KEY_SPACE = 49

local RESET_KEYS = {
	[36] = true,
	[76] = true,
	[102] = true,
	[104] = true,
}

local TEXT_ROLES = {
	AXTextField = true,
	AXTextArea = true,
	AXComboBox = true,
	AXSearchField = true,
}

local composing = false

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
		if not composing and not (f.shift or f.cmd or f.ctrl or f.alt or f.fn) and isTextFocused() then
			event:setFlags({ shift = true })
		end
		return false
	end

	if RESET_KEYS[code] then
		composing = false
	elseif not (f.cmd or f.ctrl or f.alt) and isCharacterKey(code) then
		composing = true
	end

	return false
end)

local function sync()
	composing = false
	if hs.keycodes.currentSourceID() == JAPANESE then
		keyTap:start()
	else
		keyTap:stop()
	end
end

hs.keycodes.inputSourceChanged(sync)
sync()

local appWatcher = hs.application.watcher.new(function(_, event)
	if event == hs.application.watcher.activated then
		composing = false
	end
end)
appWatcher:start()

return { keyTap = keyTap, appWatcher = appWatcher }
