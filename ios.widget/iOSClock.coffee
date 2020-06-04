dateOptions =
  # display not only 'time' also 'date'
  showDate: true
  # format of 'date'
  date: '%A %e %B'

format = (->
  if dateOptions.showDate
    dateOptions.date + '\n' +'%H:%M '
  else
    '%H:%M:%S'
)()

style: """
@import url(ios.widget/IOS.css)"""

command: "LC_TIME='nl_NL.UTF-8' date +\"#{format}\""

refreshFrequency: '1m'

dateOptions: dateOptions

render: (output) ->
	"""<div id='simpleClock'>#{output}</div>"""
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

  else
    html = output

  $(simpleClock).html(html)

style: (->
  fontSize = '7em'
  width = 'auto'
  transform = 'auto'
  bottom = '3%'
  top = 'auto'    

  return """
    color: white
    font-family: SF Pro Display
    font-weight: 200
    letter-spacing: 0.875px
    width: 100%
    height: 33%
    text-shadow: 1px 1px 5px rgba(0,0,0,0.10)   

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
      font-weight: 400
      padding-bottom: 10px
  """
)()