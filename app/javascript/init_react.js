import React from 'react'
import { createRoot } from 'react-dom/client'
import WeeklyReport from './components/WeeklyReport.js'


document.addEventListener('turbo:load', () => {
  const container = document.getElementById('weekly_report_container');
  if (container) {
    try {
      const weeklyStats = JSON.parse(container.dataset.weeklyStats);
      const root = createRoot(container);
      root.render(
        React.createElement(
          React.StrictMode,
          null,
          React.createElement(WeeklyReport, { weeklyStats: weeklyStats })
        )
      );
    } catch (error) {
      console.error('Error rendering React component:', error);
    }
  }
});

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('weekly_report_container');
  if (container) {
    const weeklyStats = JSON.parse(container.dataset.weeklyStats);
    const root = createRoot(container);
    
    root.render(
      React.createElement(
        React.StrictMode,
        null,
        React.createElement(WeeklyReport, { weeklyStats: weeklyStats })
      )
    );
  }
});
