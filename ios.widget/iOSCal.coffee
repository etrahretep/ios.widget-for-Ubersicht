calendars = [
	{name:"Astrid",color:"rgb(235,136,53)"},
	{name:"Familie",color:"rgb(129,213,84)"},
	{name:"Peter",color:"rgb(190,122,220)"},
	{name:"Printshapes",color:"rgb(233,67,107)"}
	{name:"Verjaardagen",color:"rgb(132,148,173)"}
	{name:"Nederlandse feestdagen",color:"rgb(80,172,243)"}
]

mode = "light"

defColor = "white"

command: "ios.widget/cal.sh"

refreshFrequency: '5m'

render: (output) ->"""<div id='calendar'>"""
	
update: (output, domEl) ->
	[Interface] = output.split(/[\r\n]+/g)
	if Interface is "Dark" then mode = "dark" else mode = "light"

	getCalendarColor = (calendarName) -> 
		for i in calendars
			if i.name == calendarName
				return i.color

		return defColor

	lines = output.split('• ')
	lines = lines.map((str) => ({event:str}))

	for i in [0...lines.length]
		lines[i].event = lines[i].event.split('\n')

	lines.splice(0,1)

	for i in [0...lines.length]
		name = lines[i].event[0];
		location = lines[i].event[2]# + "<br>" + lines[i].event[3] + "<br>" + lines[i].event[4];
		if (location.includes('Locatie:'))
			location = location.replace('Locatie:','') 
			location = location.replace(/\\s/g, '')
		else location = ''
		
		time = lines[i].event[1];
		if (time.includes(''))
			time = time.replace('', '')
		lines[i].event = {"name":name,"time":time,"location":location}

	inner = ''
	inner += "<div id='calendar' class='#{mode}'>" 
	inner += "<header><img src='ios.widget/icons/calendar.svg'></img><div class='widgetName'>AGENDA</div></header>"
	today = []
	tomorrow = []
	dayaftertomorrow = []

	for i in [0...lines.length]
		if (lines[i].event.time.includes('vandaag om'))
			lines[i].event.time = lines[i].event.time.replace("vandaag om ","")
			#lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
			lines[i].event.time = lines[i].event.time.split(' - ')
			today.push(lines[i].event)
			continue

		else if(lines[i].event.time.includes('vandaag')&&!lines[i].event.time.includes('om'))
			lines[i].event.time = lines[i].event.time.replace("vandaag ","")
			lines[i].event.time = "hele dag - "
			#lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
			lines[i].event.time = lines[i].event.time.split(' - ')
			today.push(lines[i].event)
			continue

		else if(lines[i].event.time.includes('morgen om')&&!lines[i].event.time.includes('day')&&!lines[i].event.time.includes('over'))
			lines[i].event.time = lines[i].event.time.replace("morgen om ","")
			#lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
			lines[i].event.time = lines[i].event.time.split(' - ')
			tomorrow.push(lines[i].event)
			continue

		else if(lines[i].event.time.includes('morgen')&&!lines[i].event.time.includes('om')&&!lines[i].event.time.includes('over'))
			lines[i].event.time = lines[i].event.time.replace("morgen ","")
			lines[i].event.time = "hele dag - "
			#lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
			lines[i].event.time = lines[i].event.time.split(' - ')
			tomorrow.push(lines[i].event)
			continue

		else if (lines[i].event.time.includes('overmorgen  om'))
			lines[i].event.time = lines[i].event.time.replace("overmorgen  om ","")
			#lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
			lines[i].event.time = lines[i].event.time.split(' - ')
			dayaftertomorrow.push(lines[i].event)
			continue

		else if(lines[i].event.time.includes('overmorgen ')&&!lines[i].event.time.includes('om'))
			lines[i].event.time = lines[i].event.time.replace("overmorgen  ","")
			lines[i].event.time = "hele dag - "
			#lines[i].event.name = lines[i].event.name.replace(/\([A-z]*\)/i, "")
			lines[i].event.time = lines[i].event.time.split(' - ')
			dayaftertomorrow.push(lines[i].event)
			continue

	inner += "<div class='mainBox'>" 
	inner += "<div class='today eventBox'>"   
	if today.length > 0
		inner += "<div class='today'></div>"
		for i in [0...today.length]
			name = today[i].name
			
			calendarName = name.match(/\([a-zA-Z0-9\/\s]*?\)$/gmi)
			calendarName = calendarName[0].replace(/[\(-\)]+/gm,"")
			
			calendarColor = getCalendarColor(calendarName)

			name = name.replace(/\([a-zA-Z0-9\/\s]*?\)$/gmi, "")
			loc = today[i].location
			time = today[i].time
			inner += "<div class='event'><div class='leftBox' style=' border-color: #{calendarColor}'><div class='time'><div class='from'>"
			inner += time[0]
			inner += "</div><div class='to'>"
			inner += time[1]
			inner += "</div></div></div><div class='rightBox'><div class='title'>"
			inner += name
			inner += "</div><div class='location'>"
			inner += loc
			inner += "</div></div></div>"
	else    inner += "<div class='nothing'>Geen activiteiten</div>"

	inner += "</div>"
	inner += "<div class='tomorrow eventBox'>"

	if tomorrow.length > 0
		inner += "<div class='day'>MORGEN</div>"
		for i in [0...tomorrow.length]
			name = tomorrow[i].name
			
			calendarName = name.match(/\([a-zA-Z0-9\/\s]*?\)$/gmi)
			calendarName = calendarName[0].replace(/[\(-\)]+/gm,"")
			
			calendarColor = getCalendarColor(calendarName)
			
			name = name.replace(/\([a-zA-Z0-9\/\s]*?\)$/gmi, "")
			loc = tomorrow[i].location
			time = tomorrow[i].time
			inner += "<div class='event'><div class='leftBox' style=' border-color: #{calendarColor}'><div class='time'><div class='from'>"
			inner += time[0]
			inner += "</div><div class='to'>"
			inner += time[1]
			inner += "</div></div></div><div class='rightBox'><div class='title'>"
			inner += name
			inner += "</div><div class='location'>"
			inner += loc
			inner += "</div></div></div>"
	else    inner += "<div class='nothing'>Geen activiteiten morgen</div>"
	
	inner += "</div>"
	inner += "<div class='dayaftertomorrow eventBox'>"

	if dayaftertomorrow.length > 0
		inner += "<div class='day'>OVERMORGEN </div>"
		for i in [0...dayaftertomorrow.length]
			name = dayaftertomorrow[i].name
		   
			calendarName = name.match(/\([a-zA-Z0-9\/\s]*?\)$/gmi)
			calendarName = calendarName[0].replace(/[\(-\)]+/gm,"")
			
			calendarColor = getCalendarColor(calendarName)

			name = name.replace(/\([a-zA-Z0-9\/\s]*?\)$/gmi, "")
			loc = dayaftertomorrow[i].location
			time = dayaftertomorrow[i].time
			inner += "<div class='event'><div class='leftBox' style=' border-color: #{calendarColor}'><div class='time'><div class='from'>"
			inner += time[0]
			inner += "</div><div class='to'>"
			inner += time[1]
			inner += "</div></div></div><div class='rightBox'><div class='title'>"
			inner += name
			inner += "</div><div class='location'>"
			inner += loc
			inner += "</div></div></div>"
	else	inner += "<div class='nothing'>Geen activiteiten overmorgen</div>"
	
	inner += "</div>"
	inner += "</div>"

	$(calendar).html(inner)

	birthdaygift = document.getElementById('calendar')
	birthdaygift.innerHTML = birthdaygift.innerHTML.replace(/􀑉/g, (match) -> '<n style=color:rgb(252,62,48)>' + match + '</n>')

style: """
    color: rgb(225,225,225)
    font-family: SF Pro Display
    font-weight: 300
    width: 100%
    position: absolute
    top: calc(33% + 158px)
    letter-spacing: 0.875px
//    transform: scale(1)

    #calendar
        border-radius: 13px
        -webkit-backdrop-filter: blur(25px)
        width: 359px
        max-height: 450px
        height: dynamic
        position: absolute
        top: 0
        left: 50%
        transform: translate(-50%,0)
        padding: 50px 0px 20px 15px

    #calendar.light
        background-color: rgba(255,255,255,0.5)
        color: rgba(0,0,0,0.9)

    #calendar.light header, #calendar.light .leftBox .time .to, #calendar.light .rightBox .location, #calendar.light .nothing, #calendar.light .day
        color: rgba(0,0,0,0.5)
    #calendar.light .event
        border-bottom: 0.25px solid rgba(0,0,0,0.15)
    #calendar.light .event:last-child
        border-bottom: none

    #calendar.dark
        background-color: rgba(0,0,0,0.25)

    #calendar.dark header, #calendar.dark .leftBox .time .to, #calendar.dark .rightBox .location, #calendar.dark .nothing, #calendar.dark .day
        color: rgba(255,255,255,0.5) 
    #calendar.dark .event
        border-bottom: 0.25px solid rgba(255,255,255,0.25)
    #calendar.dark .event:last-child
        border-bottom: none

    header 
        padding: 11px 0 11px 0
        display: flex
        flex-direction: row
        position: fixed
        top: 0
        left: 10px
    
    header img
        width: 22px
        margin-right: 7px
        height: 22px

    header .widgetName
        font-size: 13px
        line-height: 24px

    .mainBox
        overflow-y: scroll
        height: 100%
        max-height: 450px

    .eventBox
        display: flex
        flex-direction: column

    .today
        font-size: 13px
        margin-top: 9px

    .day
        padding: 0 0 0 24px
        font-size: 13px
        margin-top: 20px
        margin-bottom: 20px

    .today h2
        margin-top: 25px

    .event
        display: flex
        flex-direction: row

    .event .title
        text-overflow: ellipsis
        white-space: nowrap
        overflow: hidden
        max-width: 25ch
        padding: 2px 0 0 1px
        font-size: 17px
        line-height: 24px

    .event .leftBox
        width: 17.65%
        min-height: 45.75px
        margin: 2px 10px 2px 7.5px
        border-right: 2px solid

    .leftBox .time
        text-align: right

    .leftBox .time .from
        padding: 3px 14px 0 0
        font-size: 12px;
        line-height: 22px

    .leftBox .time .to
        padding: 0 14px 0 0
        font-size: 12px;
        line-height: 20px

    .rightBox .location
        text-overflow: ellipsis
        white-space: nowrap
        overflow: hidden
        max-width: 35ch
        padding: 3px 0 0 1px
        font-size: 12px
        line-height: 17px

    .nothing 
        font-size: 17px
        text-align: center
        margin-top: 20px
        margin-bottom: 20px
"""