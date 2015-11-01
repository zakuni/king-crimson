var React  = require('react');
var moment = require('moment');

class Gantt extends React.Component {
  render() {
    var eventslist = this.props.events.map((event, i) =>
      <g key={event.id}>
        <text x="20" y={(i*40)+42}>{event.summary}</text>
        <text x="520" y={(i*40)+42}>{event.start.dateTime}</text>
        <text x="720" y={(i*40)+42}>{event.end.dateTime}</text>
        <text x="920" y={(i*40)+42}>{moment(event.end.dateTime).diff(moment(event.start.dateTime), "minutes")}</text>
      </g>
    );
    return (
      <svg className="uk-height-1-1" width="100%">
        {eventslist}
      </svg>
    );
  }
}

module.exports = Gantt
