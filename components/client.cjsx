React = require 'react'
Table = require './table'
initialState = JSON.parse(document.getElementById('initial-data').getAttribute('data-json'))

React.render(
  <Table events={initialState} />,
  document.getElementById('table')
)
