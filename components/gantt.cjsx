React = require 'react'
moment = require 'moment'

Gantt = React.createClass
  render: ->
    eventslist = @props.events.map (event, i) ->
      <g key={event.id}>
        <text x="20" y="#{(i*40)+42}">{event.summary}</text>
        <text x="520" y="#{(i*40)+42}">{event.start.dateTime}</text>
        <text x="720" y="#{(i*40)+42}">{event.end.dateTime}</text>
      </g>

    <svg className="uk-height-1-1" width="100%">
      {eventslist}
    </svg>

module.exports = Gantt
