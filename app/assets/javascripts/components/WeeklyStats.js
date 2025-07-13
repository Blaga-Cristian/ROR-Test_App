import React from 'react'

function formatWeekRange(weekStart) {
  const start = new Date(weekStart)
  const end = new Date(start)
  end.setDate(end.getDate() + 6)
  return `${start.toLocaleDateString()} - ${end.toLocaleDateString()}`
}

function WeeklyStats({ stats }) {
  if (!stats || Object.keys(stats).length === 0) {
    return <div className="alert alert-info">No data available</div>
  }

  return (
    <table className="table table-striped">
      <thead>
        <tr>
          <th>Week Range</th>
          <th>Distance (km)</th>
          <th>Avg Speed (km/h)</th>
        </tr>
      </thead>
      <tbody>
        {Object.entries(stats)
          .sort(([a], [b]) => new Date(b) - new Date(a))
          .map(([weekStart, entry]) => (
            <tr key={weekStart}>
              <td>{formatWeekRange(weekStart)}</td>
              <td>{entry.total_distance ? entry.total_distance.toFixed(2) : 'N/A'}</td>
              <td>{entry.average_speed ? entry.average_speed.toFixed(2) : 'N/A'}</td>
            </tr>
          ))}
      </tbody>
    </table>
  )
}

window.WeeklyStats = WeeklyStats
