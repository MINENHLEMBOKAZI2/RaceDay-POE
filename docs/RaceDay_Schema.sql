-- =============================================
-- RaceDay Database Schema + Seed Data
-- Compatible with SQL Server Management Studio (SSMS)
-- =============================================

USE master;
GO

-- Drop the database if it already exists (for clean testing)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'RaceDay')
BEGIN
    ALTER DATABASE RaceDay SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDay;
END
GO

CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

-- =============================================
-- 1. User Table
-- =============================================
CREATE TABLE [User] (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    Email           NVARCHAR(256) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(512) NOT NULL,
    FullName        NVARCHAR(150) NOT NULL,
    Role            NVARCHAR(20)  NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    CreatedAt       DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);
GO

-- =============================================
-- 2. Organiser Table (1:1 with User)
-- =============================================
CREATE TABLE Organiser (
    OrganiserId         INT PRIMARY KEY,                  -- Same as UserId
    OrganisationName    NVARCHAR(200) NULL,
    ContactNumber       NVARCHAR(30)  NULL,
    CONSTRAINT FK_Organiser_User FOREIGN KEY (OrganiserId) REFERENCES [User](UserId)
);
GO

-- =============================================
-- 3. Participant Table (1:1 with User)
-- =============================================
CREATE TABLE Participant (
    ParticipantId       INT PRIMARY KEY,                  -- Same as UserId
    DateOfBirth         DATE NULL,
    EmergencyContact    NVARCHAR(100) NULL,
    CONSTRAINT FK_Participant_User FOREIGN KEY (ParticipantId) REFERENCES [User](UserId)
);
GO

-- =============================================
-- 4. Category Table
-- =============================================
CREATE TABLE Category (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(100) NOT NULL UNIQUE,
    Description     NVARCHAR(500) NULL
);
GO

-- =============================================
-- 5. Event Table
-- =============================================
CREATE TABLE Event (
    EventId                 INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId             INT NOT NULL,
    Title                   NVARCHAR(200) NOT NULL,
    Description             NVARCHAR(MAX) NULL,
    Location                NVARCHAR(200) NOT NULL,
    EventDate               DATETIME2 NOT NULL,
    RegistrationDeadline    DATETIME2 NOT NULL,
    Status                  NVARCHAR(20) NOT NULL DEFAULT 'Published'
                            CHECK (Status IN ('Draft', 'Published', 'Cancelled', 'Completed')),
    CreatedAt               DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserId) REFERENCES Organiser(OrganiserId)
);
GO

-- =============================================
-- 6. EventCategory Table (Many-to-Many bridge)
-- =============================================
CREATE TABLE EventCategory (
    EventCategoryId     INT IDENTITY(1,1) PRIMARY KEY,
    EventId             INT NOT NULL,
    CategoryId          INT NOT NULL,
    MaxParticipants     INT NULL,
    EntryFee            DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_EventCategory_Event FOREIGN KEY (EventId) REFERENCES Event(EventId),
    CONSTRAINT FK_EventCategory_Category FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId),
    CONSTRAINT UQ_Event_Category UNIQUE (EventId, CategoryId)
);
GO

-- =============================================
-- 7. Enrolment Table
-- =============================================
CREATE TABLE Enrolment (
    EnrolmentId         INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId       INT NOT NULL,
    EventCategoryId     INT NOT NULL,
    EnrolmentDate       DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    Status              NVARCHAR(20) NOT NULL DEFAULT 'Confirmed'
                        CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')),
    CONSTRAINT FK_Enrolment_Participant FOREIGN KEY (ParticipantId) REFERENCES Participant(ParticipantId),
    CONSTRAINT FK_Enrolment_EventCategory FOREIGN KEY (EventCategoryId) REFERENCES EventCategory(EventCategoryId),
    CONSTRAINT UQ_Participant_EventCategory UNIQUE (ParticipantId, EventCategoryId)
);
GO

-- =============================================
-- 8. Result Table
-- =============================================
CREATE TABLE Result (
    ResultId        INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId     INT NOT NULL UNIQUE,                 -- One result per enrolment
    OrganiserId     INT NOT NULL,
    FinishTime      TIME NULL,
    Position        INT NULL,
    Notes           NVARCHAR(500) NULL,
    RecordedAt      DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Result_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES Enrolment(EnrolmentId),
    CONSTRAINT FK_Result_Organiser FOREIGN KEY (OrganiserId) REFERENCES Organiser(OrganiserId)
);
GO

-- =============================================
-- SEED DATA
-- =============================================

-- 2 Organisers
INSERT INTO [User] (Email, PasswordHash, FullName, Role)
VALUES 
('organiser1@raceday.co.za', 'HASHED_PASSWORD_1', 'Thabo Molefe', 'Organiser'),
('organiser2@raceday.co.za', 'HASHED_PASSWORD_2', 'Lerato Nkosi', 'Organiser');

INSERT INTO Organiser (OrganiserId, OrganisationName, ContactNumber)
VALUES 
(1, 'Joburg Road Runners', '0821112222'),
(2, 'Cape Town Cycle Club', '0833334444');

-- 2 Participants
INSERT INTO [User] (Email, PasswordHash, FullName, Role)
VALUES 
('participant1@email.com', 'HASHED_PASSWORD_3', 'Sipho Dlamini', 'Participant'),
('participant2@email.com', 'HASHED_PASSWORD_4', 'Aisha Patel', 'Participant');

INSERT INTO Participant (ParticipantId, DateOfBirth, EmergencyContact)
VALUES 
(3, '1995-04-12', '0725556666'),
(4, '1988-11-03', '0717778888');

-- Categories
INSERT INTO Category (Name, Description) VALUES
('5 km', 'Fun run / walk'),
('10 km', 'Road race'),
('21 km', 'Half marathon'),
('42 km', 'Full marathon'),
('Cycle 50 km', 'Cycling event');

-- 3 Events
INSERT INTO Event (OrganiserId, Title, Description, Location, EventDate, RegistrationDeadline, Status)
VALUES
(1, 'Soweto Marathon Prep 10 km', 'Community road race in Soweto', 'Soweto, Johannesburg', '2026-10-15 07:00', '2026-10-10', 'Published'),
(1, 'Joburg Park Run Series', 'Weekly park run style event', 'Delta Park, Johannesburg', '2026-09-20 08:00', '2026-09-18', 'Published'),
(2, 'Cape Town Cycle Challenge', 'Scenic coastal cycle', 'Sea Point, Cape Town', '2026-11-05 06:30', '2026-10-28', 'Published');

-- Event Categories (at least one per event)
INSERT INTO EventCategory (EventId, CategoryId, MaxParticipants, EntryFee) VALUES
(1, 2, 500, 150.00),   -- Soweto 10 km
(1, 3, 300, 250.00),   -- Soweto 21 km
(2, 1, 200, 50.00),    -- Park Run 5 km
(3, 5, 400, 350.00);   -- Cape Town Cycle 50 km

-- Sample Enrolments
INSERT INTO Enrolment (ParticipantId, EventCategoryId, Status) VALUES
(3, 1, 'Confirmed'),   -- Sipho → Soweto 10 km
(3, 3, 'Confirmed'),   -- Sipho → Park Run 5 km
(4, 1, 'Confirmed'),   -- Aisha → Soweto 10 km
(4, 4, 'Confirmed');   -- Aisha → Cape Town Cycle

-- Sample Results
INSERT INTO Result (EnrolmentId, OrganiserId, FinishTime, Position, Notes)
VALUES
(1, 1, '00:48:22', 15, 'Strong finish'),
(2, 1, '00:28:05', 42, NULL);

PRINT 'RaceDay database schema and seed data created successfully.';
GO