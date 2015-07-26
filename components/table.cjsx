React = require 'react'

Table = React.createClass
  render: ->
    eventslist = @props.events.map (event) ->
      <tr key={event.id}>
        <td>{event.start.dateTime}</td><td>{event.summary}</td>
      </tr>
    <table className="uk-table">
      {eventslist}
    </table>

module.exports = Table
