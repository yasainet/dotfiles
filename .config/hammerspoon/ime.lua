-- Forces the input source to ABC when a herdr shortcut is pressed in Ghostty.
--
--   Cmd+T           new window
--   Cmd+1-9         select window
--   Cmd+[           copy mode
--   Cmd+D           split right
--   Cmd+Shift+D     split down
--   Cmd+Shift+[ ]   previous / next window
--   Cmd+Z           zoom toggle
--   Cmd+G           lazygit
--   Cmd+H           hunk diff
--   Cmd+R           claude resume
--   Cmd+F           claude @file
--   Cmd+Y           yazi
--   Cmd+O           gh dash
--   Cmd+/           terminal
--   Cmd+K           clear screen
--   Ctrl+B          herdr prefix
--   Ctrl+H/J/K/L    move between panes and windows
--   Ctrl+O          Claude Code transcript mode
--   Alt+H/J/K/L     resize panes

local ABC = "com.apple.keylayout.ABC"
local GHOSTTY_BUNDLE = "com.mitchellh.ghostty"

local cmdKeys = {
	t = true,
	d = true,
	["["] = true,
	z = true,
	g = true,
	h = true,
	r = true,
	f = true,
	y = true,
	o = true,
	["/"] = true,
	k = true,
}
for i = 1, 9 do
	cmdKeys[tostring(i)] = true
end
local cmdShiftKeys = { d = true, ["["] = true, ["]"] = true }
local ctrlKeys = { b = true, h = true, j = true, k = true, l = true, o = true }
local altKeys = { h = true, j = true, k = true, l = true }

local function setABC()
	hs.keycodes.currentSourceID(ABC)
end

local function isTargetKey(event)
	local f = event:getFlags()
	local keys
	if f.cmd and not (f.ctrl or f.alt or f.fn) then
		keys = f.shift and cmdShiftKeys or cmdKeys
	elseif f.ctrl and not (f.cmd or f.alt or f.shift or f.fn) then
		keys = ctrlKeys
	elseif f.alt and not (f.cmd or f.ctrl or f.shift or f.fn) then
		keys = altKeys
	else
		return false
	end
	return keys[hs.keycodes.map[event:getKeyCode()]] == true
end

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
	if isTargetKey(event) then
		local front = hs.application.frontmostApplication()
		if front and front:bundleID() == GHOSTTY_BUNDLE then
			setABC()
		end
	end
	return false
end)

local watcher = hs.application.watcher.new(function(_, event, app)
	if not app or app:bundleID() ~= GHOSTTY_BUNDLE then
		return
	end
	if event == hs.application.watcher.activated then
		tap:start()
	elseif event == hs.application.watcher.deactivated then
		tap:stop()
	end
end)
watcher:start()

local frontmost = hs.application.frontmostApplication()
if frontmost and frontmost:bundleID() == GHOSTTY_BUNDLE then
	tap:start()
end

return { tap = tap, watcher = watcher }
