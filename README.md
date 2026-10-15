# RaceDay POE - Part 2 Submission

Hey! Welcome to the repository for my RaceDay project (Part 2). For this part of the project, I built out the backend Web API using C# and .NET Core, hooked it up to a SQL Server database, and added xUnit tests to make sure everything works properly under the hood.

---

## What Roles Are in This System?

I set up role-based access control so different users can only access what they're supposed to:

1. **Administrator / Event Organizer:**
   * **What they do:** They have full control over managing the platform. They can create new racing events, update or delete existing ones, manage user accounts, and keep an eye on participant lists.
   * **Access level:** Full CRUD (Create, Read, Update, Delete) privileges across all controllers and tables.

2. **Participant / Athlete:**
   * **What they do:** This is for the everyday runner or athlete. They can browse upcoming events, sign up for specific race categories, update their profile details, and check out their past results.
   * **Access level:** Standard user access limited to viewing open events and managing their own personal data and registrations.

---

## How to Get It Running Locally

If you want to spin this up on your own machine to test it out, here are the steps I followed:

### What You'll Need
* .NET 8.0 SDK installed
* SQL Server or SQL Server Management Studio (SSMS)
* Visual Studio 2022 or VS Code

### 1. Set Up the Database
* Fire up SSMS, create your database, and run the setup scripts.
* Open up `RaceDay.API/appsettings.json` and update the connection string so it points to your local SQL Server instance:
  ```json
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER_NAME;Database=RaceDayDb;Trusted_Connection=True;TrustServerCertificate=True"
  }
