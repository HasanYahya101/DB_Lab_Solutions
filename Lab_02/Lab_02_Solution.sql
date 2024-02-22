-- Create the Database
use master;
go
create database School_System;
go
use School_System;

-- DROP TABLES
DROP TABLE IF EXISTS ClassVenue;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Teacher;

-- Q1: Create tables and insert data
CREATE TABLE Student (
    RollNum VARCHAR(10) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Phone VARCHAR(100) NOT NULL
);

CREATE TABLE Teacher (
    Name VARCHAR(50) NOT NULL,
    Designation VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL
);

CREATE TABLE ClassVenue (
    ID INT NOT NULL,
    Building VARCHAR(50) NOT NULL,
    RoomNum INT NOT NULL,
    Teacher VARCHAR(50) NOT NULL,
    --FOREIGN KEY (Teacher) REFERENCES Teacher(Name)
);

CREATE TABLE Attendance (
    RollNum VARCHAR(10) NOT NULL,
    Date DATE NOT NULL,
    Status CHAR(1) NOT NULL,
    ClassVenueID INT NOT NULL,
    --FOREIGN KEY (RollNum) REFERENCES Student(RollNum),
    --FOREIGN KEY (ClassVenueID) REFERENCES ClassVenue(ID)
);

-- Inserting Data
INSERT INTO Student (RollNum, Name, Gender, Phone) VALUES
('L164123', 'Ali Ahmad', 'Male', '0333-3333333'),
('L164124', 'Rafia Ahmed', 'Female', '0333-3456789'),
('L164125', 'Basit Junaid', 'Male', '0345-3243567');

INSERT INTO Teacher (Name, Designation, Department) VALUES
('Sarim Baig', 'Assistant Prof.', 'Computer Science'),
('Bismillah Jan', 'Lecturer', 'Civil Eng.'),
('Kashif zafar', 'Professor', 'Electrical Eng.');

INSERT INTO ClassVenue (ID, Building, RoomNum, Teacher) VALUES
(1, 'CS', 2, 'Sarim Baig'),
(2, 'Civil', 7, 'Bismillah Jan');

INSERT INTO Attendance (RollNum, Date, Status, ClassVenueID) VALUES
('L164123', '2016-02-22', 'P', 2),
('L164124', '2016-02-23', 'A', 1),
('L164125', '2016-03-04', 'P', 2);

-- Select Tables
SELECT * FROM [Student];
SELECT * FROM [Teacher];
SELECT * FROM [ClassVenue];
SELECT * FROM [Attendance];

-- Q2: Add Primary Key constraints
ALTER TABLE Student
ADD PRIMARY KEY (RollNum);
ALTER TABLE Teacher
ADD PRIMARY KEY (Name);
ALTER TABLE ClassVenue
ADD PRIMARY KEY (ID);
ALTER TABLE Attendance
ADD PRIMARY KEY (RollNum);

-- Q3: Identify all the FK constraints, and add those constraints, such that:
-- a) If the Student table or ClassVenue Table or Teacher table is updated the referencing columns should also reflect the changes.
-- b) Student should not be deleted if the details of that order is present.
-- For ClassVenue table
ALTER TABLE ClassVenue
ADD CONSTRAINT FK_Teacher_ClassVenue FOREIGN KEY (Teacher) REFERENCES Teacher(Name)
ON UPDATE CASCADE
ON DELETE CASCADE;
-- For Attendance table
ALTER TABLE Attendance
ADD CONSTRAINT FK_Student_Attendance FOREIGN KEY (RollNum) REFERENCES Student(RollNum)
ON DELETE NO ACTION;
ALTER TABLE Attendance
ADD CONSTRAINT FK_ClassVenue_Attendance FOREIGN KEY (ClassVenueID) REFERENCES ClassVenue(ID)
ON DELETE NO ACTION;

-- Q4: Alter table Student by adding new column "warning count" and deleting "Phone" Column
ALTER TABLE Student
ADD WarningCount INT NOT NULL DEFAULT 0; -- Default value is 0
ALTER TABLE Student
DROP COLUMN Phone;

-- Q5: DML Actions
-- Add new row into Student table, values <L162334, Fozan Shahid, Male, 3.2 >
INSERT INTO Student (RollNum, Name, Gender, WarningCount) VALUES
('L162334', 'Fozan Shahid', 'Male', 3.2);

-- Add new row into ClassVenue table, values <3, CS, 5, Ali>
-- For this first a teacher Named Ali needs to Exst in Teacher Table
INSERT INTO Teacher (Name, Designation, Department) VALUES
('Ali', 'Assistant Prof.', 'Computer Science');
INSERT INTO ClassVenue (ID, Building, RoomNum, Teacher) VALUES
(3, 'CS', 5, 'Ali');

-- Update Teacher table Change "Kashif zafar" name to "Dr. Kashif Zafar".
UPDATE Teacher
SET Name = 'Dr. Kashif Zafar'
WHERE Name = 'Kashif zafar';

-- Delete Student with rollnum "L162334"
DELETE FROM Student
WHERE RollNum = 'L162334';

-- Delete Attendance with rollnum "L164124", if his status is absent.
DELETE FROM Attendance
WHERE RollNum = 'L164124' AND Status = 'A';

-- Q6: DDL Actions
-- Alter table teacher and add unique constraint on column "Name"
ALTER TABLE Teacher
ADD CONSTRAINT UC_Teacher_Name UNIQUE (Name);

-- Alter Student table and add a CHECK constraint for Gender
ALTER TABLE Student
ADD CONSTRAINT CHK_Gender CHECK (Gender IN ('Male', 'Female'));

-- Alter Attendance table and add a CHECK constraint for Status
ALTER TABLE Attendance
ADD CONSTRAINT CHK_Status CHECK (Status IN ('A', 'P'));