import React from 'react'
import Gantt from './gantt'

let initialState = JSON.parse(document.getElementById('initial-data').getAttribute('data-json'));

React.render(
  <Gantt events={initialState} />,
  document.getElementById('gantt')
);
