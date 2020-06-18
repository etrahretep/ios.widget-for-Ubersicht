dateOptions = showDate: true
dateOptions: dateOptions

command: "LC_TIME='nl_NL.UTF-8' date +'%A %e %B \n %H:%M'"

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
    text-align: right
    letter-spacing: 0.875px
    width: 100%
    left: calc(50% + 71px)
    top: calc(30% - 14px)
    text-shadow: 1px 1px 5px rgba(0,0,0,0.10)   
//    transform: scale(1)

    #simpleClock
      font-size: 85px
      position: absolute
      bottom 0
      transform: translate(-50%,0)

    #simpleClock .clock
      margin-bottom: -5px

    #simpleClock .date
      font-size: 23px
      font-weight: 300
      padding-bottom: 10px

    #simpleClock .date:first-letter
      text-transform: uppercase
  """