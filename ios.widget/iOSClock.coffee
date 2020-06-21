dateOptions = showDate: true
dateOptions: dateOptions

command: "LC_TIME='en_EN.UTF-8' date +'%A %e %B \n %H:%M'"

refreshFrequency: '59s'

render: (output) -> "<div id='simpleClock'>#{output}"

update: (output) ->
    if this.dateOptions.showDate
        data = output.split('\n')

        inner = ""
        inner += "<div class='clock'>"
        inner += data[1]
        inner += "</div>"
        inner += "<div class='date'>"
        inner += data[0]

    $(simpleClock).html(inner)

style: """
    color: white
    font-family: SF Pro Display
    font-weight: 200
    letter-spacing: 0.875px
    text-shadow: 1px 1px 5px rgba(0,0,0,0.10)   
    width: 349px
    height: 80px
    left: 50%
    top: calc(30% - 159px)
    transform: translate(-50%,0)
    padding: 50px 15px 20px 10px
//    transform: scale(1)

    #simpleClock
        margin-top: -40px
        text-align: right
        font-size: 85px

    .clock
        margin-bottom: -5px

    .date
        font-size: 23px
        font-weight: 300

    .date:first-letter
        text-transform: uppercase
  """