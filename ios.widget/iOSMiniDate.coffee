dateOptions =
  showDate: true
  date: '%A'

format = (->
    dateOptions.date + '\n' +'%e'

)()

command: "LC_TIME='nl_NL.UTF-8' date +\"#{format}\""

refreshFrequency: '1m'

dateOptions: dateOptions

render: (output) ->
	"""<div id='miniDate'>#{output}</div>"""
update: (output) ->
  if this.dateOptions.showDate
    data = output.split('\n')

    html = ""
    html += '<div class="minidate">'
    html += data[0]
    html += '</div>'
    html += data[1]

  $(miniDate).html(html)

style: """
    font-family: SF Pro Display
    font-weight: 200
    font-size: 13px
    text-align: center
    letter-spacing: 0.25px
    width: 100%
    left: calc(50% - 177px)
    top: calc(33% + 169px)
    z-index: 1

    #miniDate
      background-color: white
      border-radius: 5px
      width: 22px
      height: 22px
      position: absolute
    
    .minidate
      color: red
      font-size: 4px
      margin-top: 2px
      margin-bottom: -1.5px

	.minidate:first-letter
      text-transform: uppercase
  """