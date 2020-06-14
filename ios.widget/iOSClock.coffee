dateOptions =
  showDate: true

command: "LC_TIME='nl_NL.UTF-8' date +'%A %e %B \n %H:%M'"

refreshFrequency: '59s'

dateOptions: dateOptions

render: (output) ->"<div id='simpleClock'>#{output}</div>"
update: (output) ->
  if this.dateOptions.showDate
    data = output.split('\n')

    html = ""
    html += "<div class='clock'>"
    html += data[1]
    html += "</div>"
    html += '<div class="date">'
    html += data[0]
    html += '</div>'

  $(simpleClock).html(html)

style: """
    color: white
    font-family: SF Pro Display
    font-weight: 200
    letter-spacing: 0.875px
    width: 100%
    top: 33%
    text-shadow: 1px 1px 5px rgba(0,0,0,0.10)   
//    transform: scale(1)

    #simpleClock
      font-size: 85px
      text-align: center
      position: absolute
      bottom 0
      left 50%
      transform: translate(-50%,0)

    #simpleClock .clock
      margin-bottom: -5px

    #simpleClock .date
      font-size: 23px
      font-weight: 300
      padding-bottom: 10px

	.date:first-letter
      text-transform: uppercase
  """