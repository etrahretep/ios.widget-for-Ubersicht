#mode of widget (light)
mode = "dark"

#api Key from OpenWeatherMap API
apiKey = "195785bd2dd750dca8ceb2ad990b904d"

#list of city IDs from API database
cityList = "2759821,2751316"

#if you want to use imperial just change to "imperial"
units = "metric"

lang = "nl"

command: "curl -s 'http://api.openweathermap.org/data/2.5/group?id=#{cityList}&lang=#{lang}&units=#{units}&appid=#{apiKey}'"
#http://api.openweathermap.org/data/2.5/group?id=2759821,2751316&lang=nl&units=metric&appid=195785bd2dd750dca8ceb2ad990b904d
refreshFrequency: '15m'

#=== DO NOT EDIT AFTER THIS LINE unless you know what you're doing! ===
#======================================================================

render: (output) -> """
  <div id='weather' class='#{mode}'>#{output}</div>
"""

update: (output) ->
    weatherData = JSON.parse(output)
    console.log(weatherData)

    inner = ""
    inner += "<header><img src='ios.widget/icons/weather.png' alt='icon'></img><div class='widgetName'>WEER</div></header>"

    inner += "<div class='weatherBox'>" 
    
    for i in [0...weatherData.cnt]
        city = weatherData.list[i].name
        condition = weatherData.list[i].weather[0].description
        temperature = Math.round(weatherData.list[i].main.temp)
        rainChance = weatherData.list[i].clouds.all
        windSpeed = Math.round(weatherData.list[i].wind.speed * 10) / 10
        icon = weatherData.list[i].weather[0].icon

        inner += "<div class='city'><div class='leftBox'><img src='ios.widget/icons/weather/#{icon}.svg' alt='#{icon}'></img></div><div class='middleBox'><div class='cityName'>"
        inner += city
        inner += "</div><div class='condition'>"
        inner += condition
        inner += "</div><div class='rainChance'>Kans op regen: "
        inner += rainChance
        inner += " %</div></div><div class='rightBox'><div class='temperature'>"
        inner += temperature
        inner += "°</div><div class='wind'>"
        inner += windSpeed
        inner += " km/h</div></div></div>"

        console.log(city + condition + temperature)
    
    inner += "</div>"

    $(weather).html(inner)


style: """
    color: white
    font-family: SF Pro Rounded
    font-weight: 300
    width: 100%
    position: absolute
    top: calc(33% + 480px)
    font-size: 14px
    letter-spacing: 0.5px
    
    #weather
        border-radius: 10px
        background-color: rgba(0,0,0,0.25)
        -webkit-backdrop-filter: blur(20px)
        width: 410px
        height: 75px
        position: absolute
        top: 0
        left 50%
        transform: translate(-50%,0)
        padding: 45px 20px 20px 20px
 #       -webkit-box-shadow: 10px 10px 47px 0px rgba(0,0,0,0.5)
        letter-spacing: 1px

    #weather.dark
        background-color: rgba(0,0,0,0.25)

    #weather.light
        background-color: rgba(255,255,255,0.5)
        color: black

    #weather.light header
        color: rgba(50,50,50,0.8)

    #weather.dark header
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
    
    .weatherBox
        overflow-y: scroll
        height: 100%

    .city
        padding: 10px
        display: flex
        flex-direction: row
       // border-top: 1px solid rgba(200,200,200,0.25)

    .city .leftBox
        width: 20%
        padding: 0 12px 0 0
        margin: 0 10px 0 0
 #        border-right: 2px solid
        color: lightgray
        
    .leftBox img
        margin-left: 25px
        width: 45px
        height: 45px

    .city .middleBox
        flex-grow: 1
    
    .middleBox .cityName
        font-size: 20px
        line-height: 20px
        font-weight: 300

    .middleBox .condition
        font-size: 12px
        line-height: 20px
        margin-top: 5px
        color: rgba(200,200,200,0.9)

    .middleBox .rainChance
        font-size: 12px
        line-height: 12px
        color: rgba(200,200,200,0.9)

    .city .rightBox
        width: 20%
        text-align:right

    .rightBox .temperature
        font-size: 40px
        line-height: 45px
        font-weight: 200

    .rightBox .wind
        font-size: 12px
        line-height: 12px
        text-align: center
        color: rgba(200,200,200,0.9)
"""
