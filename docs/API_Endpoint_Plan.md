# RaceDay API Endpoint Plan

| Method | Endpoint | Description | Role / Auth Required | Request Body Example | Expected Status & Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/auth/register` | Register a new user account | Public | `{ "firstName": "John", "lastName": "Doe", "email": "john@example.com", "password": "Password123!", "role": "Participant" }` | **201 Created**: `{ "message": "User registered successfully" }` |
| **POST** | `/api/auth/login` | Authenticate user and obtain JWT token | Public | `{ "email": "john@example.com", "password": "Password123!" }` | **200 OK**: `{ "token": "jwt_token_string" }` |
| **GET** | `/api/events` | List all available events with categories | Public | None | **200 OK**: `[ { "eventID": 1, "eventName": "Comrades Marathon" } ]` |
| **POST** | `/api/events` | Create a new race event | Organiser | `{ "eventName": "Cape Town Cycle Tour", "description": "Annual race", "eventDate": "2027-03-14", "location": "Cape Town" }` | **201 Created**: `{ "eventID": 2 }` |
| **PUT** | `/api/events/{id}` | Update existing event details | Organiser | `{ "eventName": "Updated Event Name", "location": "Durban" }` | **200 OK** |
| **DELETE**| `/api/events/{id}` | Delete an event | Organiser | None | **204 No Content** |
| **POST** | `/api/events/{eventId}/categories` | Add a category to an event | Organiser | `{ "categoryName": "42km Marathon", "distanceKM": 42.2, "fee": 350.00 }` | **201 Created** |
| **POST** | `/api/enrolments` | Enroll logged-in participant into a category | Participant | `{ "categoryID": 1 }` | **201 Created** |
| **GET** | `/api/enrolments/my-enrolments` | View enrolments for the logged-in user | Participant | None | **200 OK** |
| **GET** | `/api/enrolments/event/{eventId}` | View all enrolments for an event | Organiser | None | **200 OK** |
| **POST** | `/api/results` | Capture race completion results | Organiser | `{ "enrolmentID": 10, "finishTimeSeconds": 14400, "overallRank": 1, "categoryRank": 1 }` | **201 Created** |
| **GET** | `/api/results/my-results` | Track individual performance history | Participant | None | **200 OK** |