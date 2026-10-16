# RaceDay.API
# RaceDay - Event Management System

## Project Overview

RaceDay is a full-stack event management system designed specifically for the South African road running, walking, and cycling community. The platform enables Event Organisers to create and manage events, define categories, and capture participant results, while Participants can browse events, enrol, and track their personal performance history.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Roles](#roles)
- [Project Structure](#project-structure)
- [Part 1: System Planning and Database](#part-1-system-planning-and-database)
- [Part 2: RESTful API](#part-2-restful-api)
- [CI/CD Pipeline](#cicd-pipeline)
- [Video Presentation](#video-presentation)
- [Setup Instructions](#setup-instructions)
- [References](#references)

---

## Features

### Part 1 (Completed)
- ✅ Entity Relationship Diagram (ERD) with 7 entities
- ✅ Comprehensive API Endpoint Plan with 25+ endpoints
- ✅ SQL Database Script with full schema, constraints, and seed data
- ✅ CI/CD validation workflow
- ✅ 20+ meaningful commits

### Part 2 (Completed)
- ✅ RESTful API built with ASP.NET Core Web API (.NET 8)
- ✅ JWT-based authentication and role-based authorization
- ✅ Entity Framework Core (Code-First) with SQL Server
- ✅ Full CRUD for Events, Categories, Enrolments, and Results
- ✅ Swagger UI integrated with JWT Authorize button
- ✅ **12 unit tests passing** (xUnit + WebApplicationFactory + InMemory DB)
- ✅ GitHub Actions CI/CD running build + tests on every push

### Part 3 (Planned)
- 🚧 MVC Web Application
- 🚧 Azure Blob Storage integration
- 🚧 Docker containerisation
- 🚧 Role-specific interfaces

---

## Technologies Used

| Category | Technologies |
|----------|--------------|
| **Backend** | ASP.NET Core Web API 8.0, C#, Entity Framework Core 8.x |
| **Database** | SQL Server (SSMS), LocalDB |
| **Authentication** | JWT Bearer tokens, BCrypt password hashing |
| **API Documentation** | Swagger / OpenAPI (Swashbuckle) |
| **Testing** | xUnit, WebApplicationFactory, EF Core InMemory Provider |
| **Frontend (Part 3)** | ASP.NET Core MVC, Bootstrap 5 |
| **Cloud Services (Part 3)** | Azure Blob Storage |
| **Containerisation (Part 3)** | Docker |
| **Version Control** | Git, GitHub |
| **CI/CD** | GitHub Actions |

---

## Roles

### 1. Organiser
- Create, edit, and delete events
- Manage event categories (age-based and distance-based)
- View all enrolments for their own events
- Capture participant results (finish times, overall & category positions, pace)
- Upload event banner images *(Part 3)*

### 2. Participant
- Create an account and log in
- Browse upcoming events (public endpoint)
- Enrol in events by selecting a category
- View personal enrolment history
- Track personal results and performance
- Update profile *(Part 3)*

---

## Project Structure

```
RaceDay.API/
├── .github/
│   └── workflows/
│       └── dotnet.yml              # GitHub Actions CI workflow (build + test)
├── docs/                           # Part 1 documentation
│   ├── ERD.png                     # Entity Relationship Diagram
│   ├── EndpointPlan.md             # API Endpoint Plan
│   ├── RaceDayDB.sql               # SQL Database Script
│   └── ci-screenshot.png           # Successful GitHub Actions build
├── RaceDay.API/                    # Part 2 - RESTful API
│   ├── Controllers/
│   │   ├── AuthController.cs       # Register + Login
│   │   ├── UsersController.cs      # Profile view & update
│   │   ├── EventsController.cs     # Event CRUD
│   │   ├── CategoriesController.cs # Category CRUD
│   │   ├── EnrolmentsController.cs # Enrolment operations
│   │   └── ResultsController.cs    # Result capture & public board
│   ├── Data/
│   │   └── RaceDayDbContext.cs     # EF Core context with relationships
│   ├── DTOs/
│   │   ├── RegisterDto.cs
│   │   ├── LoginDto.cs
│   │   ├── EventDto.cs
│   │   ├── CategoryDto.cs
│   │   ├── EnrolmentDto.cs
│   │   ├── ResultDto.cs
│   │   └── UpdateProfileDto.cs
│   ├── Models/
│   │   ├── User.cs
│   │   ├── Event.cs
│   │   ├── Category.cs
│   │   ├── Participant.cs
│   │   ├── EventEnrolment.cs
│   │   ├── EventRoute.cs
│   │   └── Result.cs
│   ├── Migrations/                 # EF Core migrations
│   ├── appsettings.json            # Connection string + JWT config
│   └── Program.cs                  # App configuration + middleware
├── RaceDay.API.Tests/              # Part 2 - Unit Tests (12 tests)
│   ├── AuthTests.cs                # Register + Login tests
│   ├── EventTests.cs               # Event CRUD + role tests
│   ├── EnrolmentTests.cs           # Enrolment + role tests
│   ├── RoleAccessTests.cs          # Profile + role enforcement tests
│   ├── CustomWebApplicationFactory.cs  # In-memory test host
│   └── TestHelpers.cs              # Register/login helper for tests
├── RaceDay.API.sln
└── README.md
```

---

## Part 1: System Planning and Database

### ERD

The Entity Relationship Diagram includes the following **7 entities**:

| Entity | Description |
|--------|-------------|
| **Users** | Stores user accounts with role (Organiser/Participant) |
| **Participants** | Extended participant profile linked to Users |
| **Events** | Event info (name, description, date, location, type) |
| **Categories** | Age or distance categories for each event |
| **EventEnrolments** | Links Participants → Categories → Events |
| **Routes** | Route metadata (distance, elevation, map URL) |
| **Results** | Finish time, positions, and pace per enrolment |

**Relationships:**
- Users → Events: One-to-Many (Organiser owns events)
- Users → Participants: One-to-One
- Events → Categories: One-to-Many
- Events → Routes: One-to-Many
- Participants → EventEnrolments: One-to-Many
- Categories → EventEnrolments: One-to-Many
- EventEnrolments → Results: One-to-One

The ERD is available at: [`docs/ERD.png`](docs/ERD.png)

### API Endpoint Plan

The system exposes **25+ endpoints** organised by resource. Full plan available at: [`docs/EndpointPlan.md`](docs/EndpointPlan.md)

| Resource | Endpoints |
|----------|-----------|
| **Authentication** | Register, Login |
| **User Profile** | Get (self), Update (self), Get by ID |
| **Events** | List (with filters), Get by ID, Create, Update, Delete |
| **Categories** | List by event, Create, Update, Delete |
| **Enrolments** | Create, Get mine, Get by event, Delete |
| **Results** | Create, Get by event |

### SQL Database Script

The SQL script (`docs/RaceDayDB.sql`) includes:
1. **Database Creation**: `CREATE DATABASE RaceDayDB`
2. **Table Creation**: 7 tables with full constraints (PK, FK, UNIQUE, NOT NULL, DEFAULT, CHECK)
3. **Indexes**: For performance on foreign keys and filter columns
4. **Seed Data**:
   - 2 Organisers and 2 Participants
   - 3 Events (Comrades Marathon, Cape Town Cycle Tour, Soweto Marathon)
   - Categories for each event
   - Sample Enrolments and Results

---

## Part 2: RESTful API

The API was built to closely match the Part 1 endpoint plan using **ASP.NET Core Web API** with **Entity Framework Core (Code-First)**.

### Key Endpoints

#### 🔐 Authentication (`/api/auth`)
| Method | Route | Access | Description |
|---|---|---|---|
| POST | `/api/auth/register` | Public | Register as Organiser or Participant |
| POST | `/api/auth/login` | Public | Login and receive a JWT token |

#### 👤 Users (`/api/users`)
| Method | Route | Access | Description |
|---|---|---|---|
| GET | `/api/users` | Any logged-in | Get own profile |
| PUT | `/api/users` | Any logged-in | Update own profile |
| GET | `/api/users/{id}` | Organiser | Get another user's public details |

#### 🏃 Events (`/api/events`)
| Method | Route | Access | Description |
|---|---|---|---|
| GET | `/api/events` | Public | List events (filters: `?type=running&date=2027-06-13`) |
| GET | `/api/events/{id}` | Public | Get event with categories |
| POST | `/api/events` | Organiser | Create event |
| PUT | `/api/events/{id}` | Organiser (owner) | Update event |
| DELETE | `/api/events/{id}` | Organiser (owner) | Delete event |

#### 🏷️ Categories (`/api/events/{eventId}/categories`, `/api/categories/{id}`)
| Method | Route | Access | Description |
|---|---|---|---|
| GET | `/api/events/{eventId}/categories` | Public | List categories for an event |
| POST | `/api/events/{eventId}/categories` | Organiser (owner) | Add a category |
| PUT | `/api/categories/{id}` | Organiser (owner) | Update a category |
| DELETE | `/api/categories/{id}` | Organiser (owner) | Delete a category |

#### 📝 Enrolments
| Method | Route | Access | Description |
|---|---|---|---|
| POST | `/api/categories/{categoryId}/enrolments` | Participant | Enrol in a category |
| GET | `/api/enrolments/me` | Participant | View own enrolments |
| GET | `/api/events/{eventId}/enrolments` | Organiser (owner) | View all enrolments for an event |
| DELETE | `/api/enrolments/{id}` | Participant (owner) | Withdraw from an enrolment |

#### 🏆 Results
| Method | Route | Access | Description |
|---|---|---|---|
| POST | `/api/enrolments/{enrolmentId}/results` | Organiser (owner) | Capture a finish result |
| GET | `/api/events/{eventId}/results` | Public | Public results board (sorted by finish time) |

### Authentication & Authorization

- Passwords are hashed with **BCrypt** before storage.
- On login, a **JWT** is issued containing `NameIdentifier` (user ID), `Email`, and `Role` claims.
- `[Authorize]` and `[Authorize(Roles = "Organiser")]` / `[Authorize(Roles = "Participant")]` attributes enforce role access on all protected endpoints.
- Ownership checks ensure Organisers can only manage their own events and Participants only view their own enrolments.

### Swagger UI

Swagger is available at `/swagger` when running in Development mode. The UI includes an **Authorize** button (🔓) where you paste `Bearer <token>` to test protected endpoints.

---

## Testing

The project includes **12 xUnit tests** covering:

| Test Class | Tests | Coverage |
|---|---|---|
| `AuthTests` | 4 | Register (success, duplicate), Login (success, wrong password) |
| `EventTests` | 4 | Create (as Organiser, as Participant, unauthenticated), Get all (public) |
| `EnrolmentTests` | 2 | Enrol (as Participant), Enrol blocked (as Organiser) |
| `RoleAccessTests` | 2 | Profile update, Get user by ID |

Tests use `WebApplicationFactory<Program>` to spin up an in-memory instance of the API and `Microsoft.EntityFrameworkCore.InMemory` for the database. Each test class gets its own isolated database instance.

### Running Tests Locally

```bash
dotnet test
```

**Expected:** `Passed! - Failed: 0, Passed: 12, Skipped: 0, Total: 12`

---

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/dotnet.yml`) is configured to:

- **Trigger:** On push to `main` and on pull requests to `main`
- **Environment:** Ubuntu latest with .NET 8
- **Steps:**
  1. Checkout repository
  2. Setup .NET 8
  3. Restore dependencies
  4. Build solution (Release)
  5. Run all unit tests

### ✅ Build Status

![CI Status](docs/ci-screenshot.png)

*Screenshot of the successful green build stored at `docs/ci-screenshot.png`.*

---

## Video Presentation

🎥 **Watch the walkthrough of Part 2** (API demo, code structure, auth, tests):

▶️ **[YouTube Video — Part 2 Walkthrough](https://youtu.be/YOUR_VIDEO_ID)**

The video covers:
- Running the API and testing endpoints via Swagger
- Full authentication flow (register → login → authorize)
- Role-based access enforcement (Participant blocked from Organiser endpoints)
- Unit test structure and live test run
- Explanation of EF Core models, DbContext, and migrations

*Replace `YOUR_VIDEO_ID` with your unlisted YouTube link before submitting.*

---

## Setup Instructions

### Prerequisites

- [Visual Studio 2022](https://visualstudio.microsoft.com/) with **ASP.NET and web development** workload
- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [SQL Server Express / LocalDB](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) + [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- [Git](https://git-scm.com/downloads)

### Step 1: Clone the Repository

```bash
git clone https://github.com/BusisiweBANDA/poe1raceday.git
cd poe1raceday
```

### Step 2: Open the Solution

1. Open `RaceDay.API.sln` in Visual Studio 2022.
2. Wait for NuGet packages to restore automatically. If not, right-click the solution → **Restore NuGet Packages**.

### Step 3: Configure the Database Connection

Open `RaceDay.API/appsettings.json` and verify the connection string:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=RaceDayDB;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True"
  },
  "Jwt": {
    "Key": "ThisIsAVeryLongSecretKeyForJwtSigningThatIsAtLeast32CharsLong!",
    "Issuer": "RaceDayAPI",
    "Audience": "RaceDayClient"
  }
}
```

> Change the server name (`(localdb)\mssqllocaldb`) if you use a different SQL Server instance.

### Step 4: Create and Migrate the Database

In Visual Studio: **Tools → NuGet Package Manager → Package Manager Console**

Set **Default project** to `RaceDay.API` and run:

```powershell
Update-Database
```

This creates the `RaceDayDB` database with all tables, constraints, and seed data.

### Step 5: Run the API

Press **F5** or run in the terminal:

```bash
cd RaceDay.API
dotnet run
```

The API will start on:
- **HTTPS:** `https://localhost:7122`
- **HTTP:** `http://localhost:5194`

### Step 6: Explore the API with Swagger

Open your browser and navigate to:

```
https://localhost:7122/swagger
```

The Swagger UI lets you:
1. Register a user (`POST /api/Auth/register`)
2. Log in (`POST /api/Auth/login`) and copy the returned `token`
3. Click the **Authorize 🔓** button and paste `Bearer <token>`
4. Test all protected endpoints (create events, enrol, capture results)

### Step 7: Run the Unit Tests

In Visual Studio: **Test → Test Explorer → Run All Tests**

Or in terminal:

```bash
dotnet test
```

Expected: **12 Passed, 0 Failed**

### Part 3 Setup (Coming Soon)

```bash
cd RaceDay.MVC
docker build -t raceday-mvc .
docker run -p 8080:80 raceday-mvc
```

---

## Commit History

**Minimum 20 meaningful commits** per part. The commit history demonstrates progressive development across all parts:

- Initial repository setup
- ERD design
- API endpoint plan
- SQL database script
- Part 2: Authentication controller with JWT
- Part 2: EF Core models, DbContext, and migrations
- Part 2: Events, Categories, Enrolments, and Results controllers
- Part 2: Role-based authorization on all endpoints
- Part 2: Swagger JWT configuration
- Part 2: Unit tests (12 passing) with WebApplicationFactory
- Part 2: GitHub Actions CI/CD workflow
- Part 2: CI screenshot and README updates

View full commit history: [GitHub Commits](https://github.com/BusisiweBANDA/poe1raceday/commits/main)

---

## References

- Microsoft (2024a). *CREATE TABLE (Transact-SQL)*. Microsoft Learn. Available at: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql [Accessed 1 Sept. 2026].
- Microsoft (2024b). *Entity Framework Core documentation*. Microsoft Learn. Available at: https://learn.microsoft.com/en-us/ef/core/ [Accessed 1 Sept. 2026].
- Microsoft (2024c). *ASP.NET Core Web API documentation*. Microsoft Learn. Available at: https://learn.microsoft.com/en-us/aspnet/core/web-api/ [Accessed 1 Sept. 2026].
- Microsoft (2024d). *JWT bearer authentication in ASP.NET Core*. Microsoft Learn. Available at: https://learn.microsoft.com/en-us/aspnet/core/security/authentication/configure-jwt-bearer-authentication [Accessed 5 Sept. 2026].
- Microsoft (2024e). *Integration tests in ASP.NET Core*. Microsoft Learn. Available at: https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests [Accessed 10 Sept. 2026].
- Swashbuckle (2024). *Swashbuckle.AspNetCore — GitHub*. Available at: https://github.com/domaindrivendev/Swashbuckle.AspNetCore [Accessed 5 Sept. 2026].
- xUnit.net (2024). *Getting started with xUnit.net*. Available at: https://xunit.net/docs/getting-started/netcore/cmdline [Accessed 10 Sept. 2026].
- Lucid Software Inc. (2026). *Quick guide to different types of Entity Relationship Diagrams*. Lucidchart. Available at: https://www.lucidchart.com/pages/er-diagrams [Accessed 1 Sept. 2026].

---

## Contact

**Student Name:** Busisiwe Aida Banda  
**Module:** Programming 2B (PROG6212)  
**Year:** 2026  
**GitHub:** https://github.com/BusisiweBANDA/poe1raceday

---

## License

This project is submitted for academic assessment purposes as part of The IIE's Programming 2B module. All rights reserved.

---

*Last Updated: 15 October 2026*

---

## 📝 What I Changed

Here's a summary of what was updated in your README:

| Section | Change |
|---|---|
| **Features** | Moved Part 2 items from 🚧 to ✅ — all completed |
| **Technologies Used** | Fixed EF Core version (8.x), added BCrypt, added testing tools |
| **Roles** | Marked Part 3 features as "Part 3" |
| **Project Structure** | Replaced generic structure with your **actual** project layout (Controllers, DTOs, Models, Tests) |
| **ERD table** | Renamed `EventCategories` → `EventEnrolments` to match your actual schema, added `Routes`, removed `Roles` lookup table |
| **Part 2 section** | Added complete endpoint tables for all 6 resource groups, auth explanation, Swagger info |
| **Testing** | New section with 12 tests and how to run them |
| **CI/CD** | Fixed broken badge URL → now references `docs/ci-screenshot.png` |
| **Video Presentation** | Added placeholder for Part 2 YouTube video |
| **Setup Instructions** | Full working steps with actual commands (`Update-Database`, `dotnet run`, `dotnet test`) |
| **Commit History** | Added Part 2 commits |
| **References** | Replaced W3Schools/Bootstrap/etc. with proper Microsoft EF Core, ASP.NET Core, JWT, and testing docs |
| **Contact** | Updated with your name (Busisiwe Banda) and correct GitHub link |

**Before submitting**, do these three things:

1. **Replace `YOUR_VIDEO_ID`** in the Video Presentation section with your actual unlisted YouTube link.
2. **Verify `docs/ci-screenshot.png` exists** in your repo (you need to take a screenshot of the green GitHub Actions build and commit it).
3. **Commit the README** and any pending files:
   ```bash
   git add README.md docs/ci-screenshot.png
   git commit -m "Update README for Part 2 completion with CI screenshot and video link"
   git push origin main
   ```
