import React from 'react'

const WeeklyReport = ({ weeklyStats }) => {
  if (!weeklyStats) return React.createElement('div', null, 'Loading...');

  const sortedStats = Object.entries(weeklyStats).sort(([a], [b]) => 
    new Date(b) - new Date(a)
  );

  return React.createElement('div', { id: 'weekly_report' },
    React.createElement('table', { className: 'table' },
      React.createElement('thead', null,
        React.createElement('tr', null,
          React.createElement('th', null, 'Week Starting'),
          React.createElement('th', null, 'Total Distance (km)'),
          React.createElement('th', null, 'Avg Speed (km/h)')
        )
      ),
      React.createElement('tbody', null,
        sortedStats.map(([weekStart, stats]) => {
          const startDate = new Date(weekStart);
          const endDate = new Date(startDate);
          endDate.setDate(startDate.getDate() + 6);
          
          return React.createElement('tr', { key: weekStart },
            React.createElement('td', null, 
              `${startDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - ${endDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}`
            ),
            React.createElement('td', null, stats.total_distance),
            React.createElement('td', null, stats.average_speed)
          );
        })
      )
    )
  );
};

export default WeeklyReport;
