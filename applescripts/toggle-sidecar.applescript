#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Sidecar
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Toggles Sidecar
# @raycast.author Ed

use framework "Foundation"

property pane_ids : {|AppleID|:2, |Family|:3, |Wi-Fi|:5, |Bluetooth|:6, |Network|:7, |Notifications|:9, |Sound|:10, |Focus|:11, |Screen Time|:12, |General|:14, |Appearance|:15, |Accessibility|:16, |Control Center|:17, |Siri & Spotlight|:18, |Privacy & Security|:19, |Desktop & Dock|:21, |Displays|:22, |Wallpaper|:23, |Screen Saver|:24, |Battery|:25, |Lock Screen|:27, |Touch ID & Password|:28, |Users & Groups|:29, |Passwords|:31, |Internet Accounts|:32, |Game Center|:33, |Wallet & ApplePay|:34, |Keyboard|:36, |Trackpad|:37, |Printers & Scanners|:38, |Java|:40}

on open_settings_to(settings_pane)
	set pane to current application's NSDictionary's dictionaryWithDictionary:pane_ids
	set pane_index to (pane's valueForKey:settings_pane) as anything
	tell application "System Settings"
		activate
	end tell
	tell application "System Events"
		tell application process "System Settings"
			repeat while not (exists window 1)
				delay 0.01
			end repeat
			tell splitter group 1 of group 1 of window 1
				tell outline 1 of scroll area 1 of group 1
					select row (pane_index - 1)
				end tell
			end tell
			repeat while not (exists window settings_pane)
				delay 0.01
			end repeat
			tell splitter group 1 of group 1 of window 1
				tell group 1 of group 2
					tell pop up button 1
						click
						click last menu item of menu 1
						tell application "System Settings" to quit
					end tell
				end tell
			end tell
		end tell
	end tell
end open_settings_to

on run {}
	open_settings_to("Displays")
end run
