dateOptions = showDate: true

command: "LC_TIME='nl_NL.UTF-8' date +'%A \n %e'"

refreshFrequency: '1h'

dateOptions: dateOptions

render: (output) ->"<div id='miniDate'>#{output}</div>"

update: (output) ->
  if this.dateOptions.showDate
    data = output.split('\n')

    inner = ""
    inner += '<div class="date">'
    inner += data[0]
    inner += '</div>'
    inner += data[1]

  $(miniDate).html(inner)

style: """
    color: black
    font-family: SF Pro Display
    font-weight: 200
    text-align: center
    letter-spacing: 0.25px
    width: 100%
    left: calc(50% - 177px)
    top: calc(33% + 169px)
    z-index: 1

    #miniDate
      font-size: 14px
      background-color: white
      border-radius: 5px
      width: 22px
      height: 22px
      position: absolute

    #miniDate .date
      color: red
      font-size: 4px
      margin-top: 1.9px
      margin-bottom: -1.6px

    #miniDate .minidate:first-letter
      text-transform: uppercase
  """