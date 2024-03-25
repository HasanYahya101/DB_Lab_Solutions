-- Part (a)
CREATE DATABASE L227971_MID1;
GO
USE [L227971_MID1];
GO

CREATE TABLE [Machine]
(
	machine_id INT PRIMARY KEY,
	name VARCHAR(255),
	company_id INT
);
GO
CREATE TABLE [Company]
(
	company_id INT PRIMARY KEY,
	name VARCHAR(255),
	location_id INT DEFAULT NULL
);
GO
CREATE TABLE [Location]
(
	location_id INT PRIMARY KEY,
	location_name VARCHAR(255)
);
GO
CREATE TABLE [Project]
(
	project_id INT,
	machine_id INT,
	PRIMARY KEY (project_id, machine_id)
);

-- adding foreign key constraints
ALTER TABLE [Machine]
ADD CONSTRAINT FK_1
FOREIGN KEY (company_id) REFERENCES Company(company_id);

ALTER TABLE [Company]
ADD CONSTRAINT FK_2
FOREIGN KEY (location_id) REFERENCES Location(location_id);

ALTER TABLE [Project]
ADD CONSTRAINT FK_3
FOREIGN KEY (machine_id) REFERENCES Machine(machine_id);

--SELECT ALL TABLES
SELECT * FROM [Machine];
SELECT * FROM [Company];
SELECT * FROM [Project];
SELECT * FROM [Location];

-- If a machine is assigned to a project, then the machine cannot be deleted.
ALTER TABLE [Project] 
ADD CONSTRAINT CK1
FOREIGN KEY (machine_id) 
REFERENCES Machine(machine_id) 
ON DELETE NO ACTION;

-- If a company is updated, then it is updated for the machine as well.
ALTER TABLE [Machine]
ADD CONSTRAINT CK2
FOREIGN KEY (company_id)
REFERENCES Company(company_id)
ON UPDATE CASCADE;

-- If a location is deleted, then the locationtId of all companies in the deleted location is set to null.
ALTER TABLE [Company]
ADD CONSTRAINT CK3
FOREIGN KEY (location_id)
REFERENCES Location(location_id)
ON DELETE SET NULL;

-- using this when i make a mistake in table schema
USE master;
GO
DROP DATABASE [L227971_MID1];