React = require 'react'
Gantt = require './table'

initialState = JSON.parse(document.getElementById('initial-data').getAttribute('data-json'))

React.render(
  <Gantt events={initialState} />,
  document.getElementById('gantt')
)
