mode = "light"

apiKey = "195785bd2dd750dca8ceb2ad990b904d"
cityList = "2759821,2751316"
units = "metric"
lang = "nl"
lat = "52.1994"
lon = "5.374"

command: "ios.widget/weather.sh"

#lat=35&lon=139
#command: "curl -s 'http://api.openweathermap.org/data/2.5/group?lat=#{lat}&lon=#{lon}&id=#{cityList}&lang=#{lang}&units=#{units}&appid=#{apiKey}'"
#http://api.openweathermap.org/data/2.5/group?lat=52.1994&lon=5.374&id=2759821,2751316&lang=nl&units=metric&appid=195785bd2dd750dca8ceb2ad990b904d

refreshFrequency: '5m'

render: (output) -> "<div id='weather'>"

update: (output, domEl) ->

    weatherData = JSON.parse(output.replace(/[^{]*/i,''))
    console.log(weatherData)

    [Interface] = output.split(/[\r\n]+/g)
    if Interface is "Dark" then mode = "dark" else mode = "light"

    inner = ''
    inner += "<div id='weather' class='#{mode}'>" 
    inner += "<header><img src='ios.widget/icons/weather.svg' alt='icon'></img><div class='widgetName'>WEER</div></header>"
    inner += "<div class='weatherBox'>" 

    for i in [0...weatherData.cnt]
        city = weatherData.list[i].name
        condition = weatherData.list[i].weather[0].description
        temperature = Math.round(weatherData.list[i].main.temp)
        clouds = weatherData.list[i].clouds.all
        windSpeed = Math.round(weatherData.list[i].wind.speed * 10) / 10
        icon = weatherData.list[i].weather[0].icon

        inner += "<div class='city'><div class='leftBox'>
        <img src='ios.widget/icons/weather/#{icon}.svg' alt='#{icon}'>
        </img></div><div class='middleBox'><div class='cityName'>"
        inner += city
        inner += "</div><div class='condition'>"
        inner += condition
        inner += "</div><div class='clouds'>bewolking: "
        inner += clouds
        inner += "%</div></div><div class='rightBox'><div class='temperature'>"
        inner += temperature
        inner += "°</div><div class='wind'>wind "
        inner += windSpeed
        inner += " km/u</div></div></div>"

        console.log(city + condition + temperature)

    inner += "</div>"

    $(weather).html(inner)

style: """
    color: rgb(225,225,225)
    font-family: SF Pro Display
    font-weight: 300
    width: 100%
    position: absolute
    top: 30%
    letter-spacing: 0.875px
//    transform: scale(1)

    #weather
        border-radius: 13px
        -webkit-backdrop-filter: blur(25px)
        width: 349px
        height: 87px
        position: absolute
        top: 0
        left 50%
        transform: translate(-50%,0)
        padding: 50px 15px 20px 10px

    #weather.light
        background-color: rgba(255,255,255,0.5)
        color: rgba(0,0,0,0.9)

    #weather.light header, #weather.light .condition, #weather.light .clouds, #weather.light .wind
        color: rgba(0,0,0,0.5)

    #weather.dark
        background-color: rgba(0,0,0,0.25)

    #weather.dark header, #weather.dark .condition, #weather.dark .clouds, #weather.dark .wind
        color: rgba(255,255,255,0.5)

    header 
        padding: 11px 0 11px 0
        display: flex
        flex-direction: row
        position: fixed
        top: 0

    header img
        width: 21px
        margin-right: 7px
        height: 21px

    header .widgetName
        font-size: 13px
        line-height: 23px

    .weatherBox
        overflow-y: scroll
        height: 100%

    .city
        padding: 10px 0px 0px 11px
        display: flex
        flex-direction: row

    .city .leftBox
        width: 20%
        padding: 0px 10px 10px 0px
        margin: 0px 13px 0px 0px

    .leftBox img
        width: 63px
        height: 60px

    .city .middleBox
        flex-grow: 1

    .middleBox .cityName
        font-size: 18px
        font-weight: 400
        line-height: 20px

    .middleBox .condition
        font-size: 13px
        line-height: 20px
        margin-top: 2px

    .middleBox .clouds
        width: 75%
        font-size: 13px
        line-height: 13px

    .city .rightBox
        width: 30%
        margin-right: 2px
        text-align:right

    .rightBox .temperature
        font-size: 44px
        line-height: 42px
        font-weight: 200

    .rightBox .wind
        font-size: 13px
        line-height: 14px
        text-align: right
"""