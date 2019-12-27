--	time.lua
--	'c' shows current time on keypress;                     keybind name: "show_time_fn"
--	'C' shows what the time will be at the end of playback; keybind name: "show_end_time_fn"
--	Link: https://github.com/mustaqimM/mpv-scripts/time.lua

function sec_to_human(sec)
  hours = math.floor(sec / 60 / 60)
  min = math.floor((sec / 60) % 60)
  seconds = math.floor(sec % 60)

  return string.format("%d:%02d:%02d", hours, min, seconds)
end

function show_time_fn()
  currentTime = mp.get_property_number("time-pos")
  currentTimeString = sec_to_human(currentTime)

  totalTime = mp.get_property_number("time-pos") + mp.get_property_number("time-remaining")
  totalTimeString = sec_to_human(totalTime)

  mp.msg.info(string.format("%s / %s", currentTimeString, totalTimeString))
  mp.osd_message(string.format("%s / %s", currentTimeString, totalTimeString), 3)
  -- mp.msg.info(mp.get_property_number("time-pos"))
  -- mp.osd_message(mp.get_property_number("time-pos"))
end

function show_end_time_fn()
	currentHour = tonumber(os.date("%H"))    -- Change '%H' to '%I' for 12-hr clock
	currentMinutes = tonumber(os.date("%M"))

	remainingTimeInSeconds = mp.get_property_number("time-remaining")
	remainingTimeInHours = math.floor(remainingTimeInSeconds / 3600)
	remainingTimeInMinutes = (remainingTimeInSeconds / 60) % 60

	endHour = currentHour + remainingTimeInHours
	endMin = math.floor(currentMinutes + remainingTimeInMinutes)

	if endMin >= 60 then
		endHour = math.floor(endHour + (endMin / 60))
		endMin = math.floor(endMin % 60)
	end

	if endHour >= 24 then
		endHour = math.abs(endHour % 24) + 1
	end

	mp.msg.info(string.format("Playback will end at: %02d:%02d", endHour, endMin))
	mp.osd_message(string.format("Playback will end at: %02d:%02d", endHour, endMin))
end


mp.add_key_binding("t", "show_time", show_time_fn)
mp.add_key_binding("T", "show_end_time", show_end_time_fn)

mp.register_event("seek", show_time_fn)
