on run argv
	set side to item 1 of argv

	set homeDir to POSIX path of (path to home folder)
	set cacheDir to homeDir & ".cache"
	set stateFile to cacheDir & "/karabiner-window-toggle.state"
	do shell script "mkdir -p " & quoted form of cacheDir

	set prevSide to ""
	set prevStep to 0
	try
		set raw to do shell script "cat " & quoted form of stateFile
		set AppleScript's text item delimiters to ":"
		set parts to text items of raw
		set AppleScript's text item delimiters to ""
		if (count of parts) is 2 then
			set prevSide to item 1 of parts
			set prevStep to (item 2 of parts) as integer
		end if
	end try

	if side is prevSide then
		set step to (prevStep mod 3) + 1
	else
		set step to 1
	end if

	tell application "Finder"
		set screenBounds to bounds of window of desktop
	end tell
	set sw to item 3 of screenBounds
	set sh to item 4 of screenBounds

	if step is 1 then
		set newW to sw / 2
	else if step is 2 then
		set newW to sw / 3
	else
		set newW to sw * 2 / 3
	end if

	if side is "left" then
		set newX to 0
	else
		set newX to sw - newW
	end if

	tell application "System Events"
		tell (first process whose frontmost is true)
			set position of front window to {newX as integer, 0}
			set size of front window to {newW as integer, sh as integer}
		end tell
	end tell

	do shell script "echo " & quoted form of (side & ":" & step) & " > " & quoted form of stateFile
end run
