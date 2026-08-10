-- Usage:
--   Cmd+Alt+Left/Right  Snap window to that half; repeat to cycle 1/2 -> 2/3 -> 1/3
--   Cmd+Alt+Up/Down     Move window to the display above/below, centered

hs.window.animationDuration = 0

local cycleSizes = { 1 / 2, 2 / 3, 1 / 3 }

local lastActions = {}

local function rectsEqual(a, b)
	return math.abs(a.x - b.x) <= 1
		and math.abs(a.y - b.y) <= 1
		and math.abs(a.w - b.w) <= 1
		and math.abs(a.h - b.h) <= 1
end

local function sideRect(screenFrame, side, fraction)
	local w = math.floor(screenFrame.w * fraction + 0.5)
	local x = (side == "left") and screenFrame.x or (screenFrame.x + screenFrame.w - w)
	return hs.geometry.rect(x, screenFrame.y, w, screenFrame.h)
end

local function snap(side)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local id = win:id()
	local current = win:frame()
	local screenFrame = win:screen():frame()

	local last = lastActions[id]
	if last and not rectsEqual(current, last.rect) then
		last = nil
		lastActions[id] = nil
	end

	local target
	local count = 1
	if not last or last.action ~= side then
		target = sideRect(screenFrame, side, cycleSizes[1])
	else
		local index = last.count % #cycleSizes
		for _ = 1, #cycleSizes do
			target = sideRect(screenFrame, side, cycleSizes[index + 1])
			if not rectsEqual(current, target) then
				break
			end
			index = (index + 1) % #cycleSizes
		end
		count = last.count + 1
	end

	win:setFrame(target)

	lastActions[id] = {
		action = side,
		rect = win:frame(),
		count = count,
	}
end

local function centerRect(winFrame, screenFrame)
	local heightExceeded = winFrame.h > screenFrame.h
	local widthExceeded = winFrame.w > screenFrame.w

	if heightExceeded and widthExceeded then
		return hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h)
	end

	local rect = hs.geometry.rect(winFrame.x, winFrame.y, winFrame.w, winFrame.h)
	if heightExceeded then
		rect.h = screenFrame.h
		rect.y = screenFrame.y
	else
		rect.y = math.floor((screenFrame.h - winFrame.h) / 2 + 0.5) + screenFrame.y
	end
	if widthExceeded then
		rect.w = screenFrame.w
		rect.x = screenFrame.x
	else
		rect.x = math.floor((screenFrame.w - winFrame.w) / 2 + 0.5) + screenFrame.x
	end
	return rect
end

local function moveToScreen(direction)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local screen = win:screen()
	local target
	if direction == "up" then
		target = screen:toNorth()
	else
		target = screen:toSouth()
	end
	if not target then
		return
	end

	local rect = centerRect(win:frame(), target:frame())
	win:setFrame(rect)
	if not rectsEqual(win:frame(), rect) then
		win:setFrame(rect)
	end

	lastActions[win:id()] = nil
end

hs.hotkey.bind({ "cmd", "alt" }, "left", function()
	snap("left")
end)
hs.hotkey.bind({ "cmd", "alt" }, "right", function()
	snap("right")
end)
hs.hotkey.bind({ "cmd", "alt" }, "up", function()
	moveToScreen("up")
end)
hs.hotkey.bind({ "cmd", "alt" }, "down", function()
	moveToScreen("down")
end)
