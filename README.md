# Jogging Tracker Rails App

This is a Ruby on Rails application that allows users to track their jogging times. The app implements user authentication, role-based permissions, time entry management, and reporting features.

## Features

### User Authentication
- Users can create accounts and log in securely.

### Time Entry Management
- Users can create, read, update, and delete their own jogging times.
- Each time entry includes:
  - Date of the run
  - Distance
  - Time
  - Average speed (calculated automatically)

### Roles and Permissions
- **Regular User:** Can CRUD only their own records.
- **User Manager:** Can CRUD users.
- **Admin:** Can CRUD all records and users.

### Filtering and Reporting
- Filter jogging times by date range.
- Weekly reports on average speed and distance.

### REST API
- All user actions are available via REST API.
- Includes authentication endpoints.
- Can be tested using Postman, cURL, or other REST clients.

### Turbo Streams
- All client-side actions are performed using Turbo Streams (instead of full page refreshes or AJAX), providing real-time updates.

### Minimal UI/UX
- Designed for clarity and usability. No advanced graphic design implemented.

## Technologies Used
- Ruby on Rails 7
- PostgreSQL

