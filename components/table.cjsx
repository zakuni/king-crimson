React = require 'react'

Table = React.createClass
  render: ->
    eventslist = @props.events.map (event) ->
      <tr key={event.id}>
        <td>{event.summary}</td>
        <td>
          <div>{event.start.dateTime}</div>
          <div>{event.end.dateTime}</div>
        </td>
      </tr>

    <table className="uk-table">
      <thead>
        <tr>
          <th>Task</th>
          <th>time</th>
        </tr>
      </thead>
      <tbody>
        {eventslist}
      </tbody>
    </table>

module.exports = Table
