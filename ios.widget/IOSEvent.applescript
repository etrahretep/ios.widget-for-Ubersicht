try
	set rawOutput to do shell script "/usr/local/bin/icalBuddy -npn -nc -iep 'title,datetime' -ps ' ^ ' -po 'datetime,title' -df '' -b '' -n -ea eventsToday"
on error e
	logEvent(e)
	return "icalbuddy"
end try
set eventList to {}
set now to time of (current date)
repeat with myEvent in paragraphs of rawOutput
	set myEvent to myEvent as list
	try
		set startTime to time of date (item 1 of myEvent)
		if startTime > now then copy myEvent to end of eventList
	end try
end repeat
set startTimes to {}
repeat with myEvent in eventList
	set myEvent to myEvent as string
	set AppleScript's text item delimiters to "^"
	copy text item 1 of myEvent to end of startTimes
	set AppleScript's text item delimiters to ""
end repeat
try
	if (count of items of eventList) ³ 1 then
		set nextEvent to item 1 of eventList
		set nextEvent to nextEvent as string
		set AppleScript's text item delimiters to "^"
		set startTime to time of date (text item 1 of nextEvent)
		set eventName to text item 2 of nextEvent
		set AppleScript's text item delimiters to ""
		set hrs to (startTime - now) div hours
		set mins to (startTime - now) mod hours div minutes
	else
		return "geen activiteiten"
	end if
on error e
	logEvent(e)
	return "Error: " & e
end try
if hrs = 0 and mins ² 2 then
	set remainingTime to "Nu"
else if hrs ³ 1 and hrs ² 2 and mins = 0 then
	set remainingTime to "over " & hrs & " uur"
else if hrs ³ 1 and hrs ² 2 then
	set remainingTime to "over " & hrs & " uur en " & mins & " min."
else if hrs ³ 3 then
	set remainingTime to "over " & hrs & " uur"
else if hrs ² 1 then
	set remainingTime to "over " & mins & " min."
end if
set subsequentEvents to (count of items of eventList) - 1
if subsequentEvents ³ 1 then
	set meta to "+ " & subsequentEvents & " later"
else
	set meta to 0
end if
set conflicts to count_matches(startTimes, item 1 of startTimes) - 1
if conflicts is not 0 then
	if conflicts > 1 then
		set plural to "en"
	else
		set plural to ""
	end if
	set meta to "+ " & conflicts & " conflict" & plural
end if
return remainingTime & " ^ " & eventName & " ^ " & meta
on count_matches(this_list, this_item)
	set the match_counter to 0
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then Â
			set the match_counter to the match_counter + 1
	end repeat
	return the match_counter
end count_matches
on logEvent(e)
	tell application "Finder" to set myName to (name of file (path to me))
	do shell script "echo '" & (current date) & space & quoted form of (e as string) & "' >> ~/Library/Logs/" & myName & ".log"
end logEvent