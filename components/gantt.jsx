import React from 'react'
import moment from 'moment'
import d3 from 'd3'

class Gantt extends React.Component {
  componentDidMount() {
    var tasks = d3.select(React.findDOMNode(this)).append('g')
      .attr('class', 'tasks');

    var task = tasks.selectAll(".task")
      .data(this.props.events);

    var xScale = d3.time.scale()
      .domain([
        d3.min(this.props.events, function(d) { return moment().format("x") }),
        d3.min(this.props.events, function(d) { return moment().add(1, 'd').format("x") })
      ])
      .range([600, 1120]);
    var xAxis = d3.svg.axis().scale(xScale).ticks(12).tickFormat(d3.time.format("%d %H:%M"));
    d3.select(React.findDOMNode(this)).append('g').call(xAxis);

    task.enter().append('g').attr('class', 'task')
      .call( (selection) => {
        selection.append('text')
          .text(function(event){ return event.summary })
          .attr("x", 20)
          .attr("y", function(d, i){ return (i*40)+42 });

        selection.append('text')
          .text(function(event){ return moment(event.start.dateTime).format('ddd, MMM DD HH:mm') })
          .attr("x", 320)
          .attr("y", function(d, i){ return (i*40)+42 });

        selection.append('text')
          .text(function(event){ return moment(event.end.dateTime).format('ddd, MMM DD HH:mm') })
          .attr("x", "470")
          .attr("y", function(d, i){ return (i*40)+42 });

        selection.append('rect')
          .attr("x", function(event) { return xScale(moment(event.start.dateTime).format("x")) })
          .attr("y", function(d, i){ return (i*40)+32 })
          .attr("height", 10)
          .attr("width", function(event){
            return xScale(moment(event.end.dateTime).format("x"))-xScale(moment(event.start.dateTime).format("x"))
          });
      });
  }
  render() {
    return (
      <svg className="uk-height-1-1" width="100%"></svg>
    );
  }
}

module.exports = Gantt
