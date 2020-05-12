#color settings for calendars
#color is in format suitable for css
calendars = [
    {name:"Astrid",color:"orange"},
    {name:"Familie",color:"lightgreen"},
    {name:"Peter",color:"mediumpurple"},
    {name:"Printshapes",color:"crimson"}
    {name:"Verjaardagen",color:"gold"}
    {name:"Nederlandse feestdagen",color:"cyan"}
]

#mode of widget (light)
mode = "dark"

#Default color of calendar
defColor = "white"

# Bash command to pull events from icalBuddy
# Set +2 to how many days you want to show
# icalBuddy has more functionality that can be used here
command: "/usr/local/bin/icalbuddy -n -po title,datetime,location -iep title,datetime,location eventsToday+2"

# Update is called once per 30 minutes
refreshFrequency: '1m'



# CSS styling
style: """
    color: white
    font-family: SF Pro Rounded
    font-weight: 400
    width: 100%
    height: 220px
    position: absolute
    top: 33%
    font-size: 14px
    letter-spacing: 0.5px

    #calendar
        border-radius: 10px
        -webkit-backdrop-filter: blur(25px)
        width: 410px
        height: 400px
        position: absolute
        top: 0
        left: 50%
        transform: translate(-50%,0)
        padding: 40px 20px 20px 20px
#        -webkit-box-shadow: 10px 10px 47px 0px rgba(0,0,0,0.5)
        letter-spacing: 1px

    #calendar.dark
        background-color: rgba(0,0,0,0.25)

    #calendar.light
        background-color: rgba(255,255,255,0.5)
        color: black

    #calendar.light header, #calendar.light .leftBox .time .to, #calendar.light .rightBox .location, .nothing
        color: rgba(50,50,50,0.8)

    #calendar.dark header, #calendar.dark .leftBox .time .to, #calendar.dark .rightBox .location, .nothing
        color: rgba(200,200,200,0.9)

    header 
        padding: 10px 0 10px 0
        display: flex
        flex-direction: row
        position: fixed
        top: 0
    
    header img
        width: 25px
        margin-right: 10px
        height: 25px

    header .widgetName
        line-height: 25px

    .mainBox
        overflow-y: scroll
        height: 100%

    .eventBox
        display: flex
        flex-direction: column

    .today h2
        margin-top: 15px

    .event
        padding: 5px
        display: flex
        flex-direction: row
        border-top: 1px solid rgba(200,200,200,0.25)

    .event .title
        line-height: 20px
    
    .event .leftBox
        width: 20%
        padding: 0 10px 0 0
        margin: 0 10px 0 0
        border-right: 2px solid

    .leftBox .time
        text-align: right

    .leftBox .time .from
        line-height: 20px

    .leftBox .time .to
        font-size: 12px;
        line-height: 20px

    .rightBox .location
        font-size: 12px
        line-height: 20px

    .nothing 
        text-align: center
        margin-top: 10px
        font-size: 18px

"""

# Initial render
render: (output) -> """<div id='calendar' class='#{mode}'>#{output}</div>"""

# Update when refresh occurs
update: (output, domEl) ->

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
        location = lines[i].event[2] + "<br>" + lines[i].event[3]# + "<br>" + lines[i].event[4];
        if (location.includes('Locatie:'))
            location = location.replace('Locatie:','') 
            location = location.replace(/\\s/g, '')
        else location = ''
		
        time = lines[i].event[1];
        if (time.includes(''))
            time = time.replace('', '')
        lines[i].event = {"name":name,"time":time,"location":location}

    inner = ''
    inner += "<header><img src='ios.widget/icons/calendar.png' alt='icon'></img><div class='widgetName'>AGENDA</div></header>"
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
        inner += "<h2>Vandaag</h2>"
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
        inner += "<h2>Morgen</h2>"
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
    else    inner += "<div class='nothing'>Geen activiteiten</div>"
    
    inner += "</div>"
    inner += "<div class='dayaftertomorrow eventBox'>"

    if dayaftertomorrow.length > 0
        inner += "<h2>Overmorgen </h2>"
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
    else	inner += "<div class='nothing'>Geen activiteiten</div>"
    
    inner += "</div>"
    inner += "</div>"

    $(calendar).html(inner)