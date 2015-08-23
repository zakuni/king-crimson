React = require 'react'
Gantt = require './gantt'

initialState = JSON.parse(document.getElementById('initial-data').getAttribute('data-json'))

React.render(
  <Gantt events={initialState} />,
  document.getElementById('gantt')
)
