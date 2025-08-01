#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Sidecar
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Toggles Sidecar. Updated for sonoma.
# @raycast.author Ed

tell application "System Events"
	
	tell its application process "ControlCenter"
		
		tell its menu bar 1
			# click on and open Control Center drop down
			tell (UI elements whose description is "Control Center")
				click
			end tell
		end tell
		
		# interact with Control Center window
		tell its window "Control Center"
			delay 0.5
			# click screen mirroring button
			set screenMirroringButton to button 2 of group 1
			# click screenMirroringButton click doesn't work
			perform action 1 of screenMirroringButton
			delay 0.5
			set myScreen to checkbox 1 of group 1 of its scroll area 1 of group 1
			perform action 1 of myScreen
		end tell

	end tell
end tell
