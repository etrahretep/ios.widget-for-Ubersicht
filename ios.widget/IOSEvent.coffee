options =
  widgetEnable: true

command: "ios.widget/event.sh"
refreshFrequency: '59s'
style: """
    overflow: hidden
    max-width: 36ch
    color: rgba(0,0,0,0.9)
    font-family: SF Pro Display
    font-weight: 300
    font-size: 12px
    letter-spacing: 0.875px
    line-height: 17px
    top: calc(33% + 173px)
    right: calc(50% - 170px)
//    transform: scale(1)
text-align: right
z-index: 1
"""

render: (output) ->

  NextEventHTML = ''

  NextEventHTML = "
    <div class='wrapper'>
      <div class='time'></div>
      <div class='text'>
        <span class='eventName'></span>
        <span class='meta'></span>
      </div>
    </div>"
  return NextEventHTML

update: (output, domEl) ->

  [Interface] = output.split(/[\r\n]+/g)

  div = $(domEl)

  if Interface is "Dark"
      values = output.slice(5,-1).split("^")
      div.find('.wrapper').css('color', 'rgba(255,255,255,0.5)')
    else
      values = output.slice(0,-1).split("^")
      div.find('.wrapper').css('color', 'rgba(0,0,0,0.5)')

    NextEventHTML = ''
    div.find('.time').html(values[0])
    div.find('.eventName').html(values[1])
    div.find('.meta').html(values[2])

    if values[0] == 'geen activiteiten'
      div.find('.wrapper').css('display', 'none')
    else
      div.find('.wrapper').css('display', 'block')

    if parseInt(values[2]) != 0
      div.find('.meta').css('display', 'block')
    else
      div.find('.meta').css('display', 'none')