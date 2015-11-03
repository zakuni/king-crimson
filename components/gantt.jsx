import React from 'react'
import moment from 'moment'
import d3 from 'd3'

class Gantt extends React.Component {
  componentDidMount() {
    var tasks = d3.select(React.findDOMNode(this)).append('g')
      .attr('class', 'tasks');

    var task = tasks.selectAll(".task")
      .data(this.props.events);

    task.enter().append('g').attr('class', 'task')
      .call( (selection) => {
        selection.append('text')
          .text(function(event){ return event.summary })
          .attr("x", 20)
          .attr("y", function(d, i){ return (i*40)+42 });

        selection.append('text')
          .text(function(event){ return event.start.dateTime })
          .attr("x", 520)
          .attr("y", function(d, i){ return (i*40)+42 });

        selection.append('text')
          .text(function(event){ return event.end.dateTime })
          .attr("x", "720")
          .attr("y", function(d, i){ return (i*40)+42 });

        selection.append('text')
          .text(function(event){ return moment(event.end.dateTime).diff(moment(event.start.dateTime), "minutes")})
          .attr("x", "920")
          .attr("y", function(d, i){ return (i*40)+42 });
      });
  }
  render() {
    return (
      <svg className="uk-height-1-1" width="100%"></svg>
    );
  }
}

module.exports = Gantt
