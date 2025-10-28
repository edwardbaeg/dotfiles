-- VIP Access Security Code Copy Script
-- This script opens VIP Access and copies the security code
-- It tries to click the copy button first, then falls back to keyboard shortcut

on run
	try
		-- Activate VIP Access application
		tell application "VIP Access"
			activate
		end tell

		-- Wait for the application to be ready
		delay 0.5

		tell application "System Events"
			tell process "VIP Access"
				-- Try to click the second copy button (Security Code = button 1)
				try
					click button 1 of window 1
					return "Successfully copied security code via button click"
				on error errMsg
					-- Fallback: Use keyboard shortcut Shift+Cmd+S
					try
						keystroke "s" using {shift down, command down}
						return "Successfully copied security code via keyboard shortcut"
					on error errMsg2
						-- Final fallback: Use menu command
						try
							tell menu bar 1
								click menu item "Copy Security Code" of menu "VIP Access"
							end tell
							return "Successfully copied security code via menu command"
						on error errMsg3
							error "Failed to copy security code: " & errMsg3
						end try
					end try
				end try
			end tell
		end tell

	on error errMsg
		return "Error: " & errMsg & return & return & "Make sure VIP Access is installed and you have granted Accessibility permissions in System Preferences."
	end try
end run
