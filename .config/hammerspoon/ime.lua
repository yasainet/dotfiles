-- Forces the input source to ABC when a herdr shortcut is pressed in Ghostty.
--
--   Cmd+T           new tab
--   Cmd+1-9         select tab
--   Cmd+Shift+[ ]   previous / next tab
--   Cmd+D           split vertical
--   Cmd+Shift+D     split horizontal
--   Cmd+[           copy mode
--   Cmd+K           clear screen
--   Cmd+P           quote selection
--   Ctrl+B          herdr prefix
--   Ctrl+H/J/K/L    move between panes and windows
--   Ctrl+G          Claude Code external editor / lazygit popup
--   Ctrl+O          Claude Code transcript mode
--   Ctrl+Y          yazi pane
--   Ctrl+R          claude resume popup
--   Ctrl+F          claude @mention popup
--   Alt+H/J/K/L     resize panes

local ABC = "com.apple.keylayout.ABC"
local GHOSTTY_BUNDLE = "com.mitchellh.ghostty"

local cmdKeys = {
	t = true,
	d = true,
	["["] = true,
	k = true,
	p = true,
}
for i = 1, 9 do
	cmdKeys[tostring(i)] = true
end
local cmdShiftKeys = { d = true, ["["] = true, ["]"] = true }
local ctrlKeys = { b = true, f = true, g = true, h = true, j = true, k = true, l = true, o = true, r = true, y = true }
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
