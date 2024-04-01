use master
go
 
Create database Sample
go 
use Sample

go
create table Students
( StudentID int Primary Key,
  StudentName varchar(10),
  StudentBatch int,
  cgpa float
)
GO
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentBatch], [cgpa]) VALUES ('1', 'Ali', 2013, 2.625)
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentBatch], [cgpa]) VALUES ('2', 'Ayesha', 2013, 4)

INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentBatch], [cgpa]) VALUES ('3', 'Ahmed', 2013, 2.2)
INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentBatch], [cgpa]) VALUES ('4', 'Bilal', 2012, 2.5)

INSERT [dbo].[Students] ([StudentID], [StudentName], [StudentBatch], [cgpa]) VALUES ('5', 'Zafar', 2012, 3.5)
go
Create table Instructors 
(
InstructorID int Primary key,
InstructorName varchar(30),
)
GO
INSERT [dbo].[Instructors] ([InstructorID], [InstructorName]) VALUES (1, 'Zafar')
INSERT [dbo].[Instructors] ([InstructorID], [InstructorName]) VALUES (2, 'Sadia')
INSERT [dbo].[Instructors] ([InstructorID], [InstructorName]) VALUES (3, 'Saima')

go
create table Courses
(
CourseID int primary key,
CourseName varchar(40),
CourseCreditHours int,
InstructorID int Foreign Key References Instructors(InstructorID)
) 
GO
INSERT [dbo].[Courses] ([CourseID], [CourseName], [CourseCreditHours],InstructorID) VALUES (1, 'Computer Programming', 3, 1)
INSERT [dbo].[Courses] ([CourseID], [CourseName], [CourseCreditHours],InstructorID) VALUES (2, 'Computer Organization', 3, 2)
INSERT [dbo].[Courses] ([CourseID], [CourseName], [CourseCreditHours],InstructorID) VALUES (3, 'Computer Programming Lab', 1,NULL)
INSERT [dbo].[Courses] ([CourseID], [CourseName], [CourseCreditHours],InstructorID) VALUES (4, 'Database', 3,2)
INSERT [dbo].[Courses] ([CourseID], [CourseName], [CourseCreditHours],InstructorID) VALUES (5, 'Database Lab', 1,1)
go

create table Registration
(
StudentID int Foreign key References Students(StudentID),
CourseID int Foreign key References Courses(CourseID), 
GPA float,
primary key(StudentID,CourseID)
)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (1, 1, 3)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (1, 3, 3)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (1, 4, 2)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (1, 5, 3)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (2, 1, 2.5)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (2, 2, 0)
INSERT [dbo].[Registration] ([StudentID], [CourseID],GPA) VALUES (2, 4, 3)

select * from Students
select * from Courses
select * from Instructors
select * from Registration









									-----------------------------------------VIEWS-----------------------------------------
--A view to display students with 3 GPA
Create View [3GPAStudents]
as
select Distinct StudentName
from Students S join Registration R on S.StudentID=R.StudentID
where R.GPA=3



--Create A view to give Student's Name and CGPA (Calculate CGPA Using Aggregation)
Create View [StudentCGPA]
as
select S.StudentID, S.StudentName, sum(C.CourseCreditHours*R.GPA)/SUM(C.CourseCreditHours) as CurrentCGPA
from Students S join Registration R on S.StudentID=R.StudentID join Courses C on C.CourseID=R.CourseID
group by S.StudentID,S.StudentName



--Using a view
Select * from StudentCGPA



--Altering a View
Alter View [3GPAStudents]
as
select Distinct StudentName, C.CourseName
from Students S join Registration R on S.StudentID=R.StudentID join Courses C on C.CourseID=R.CourseID
where R.GPA=3

Select * from [3GPAStudents]



--Insert/Update/Delete Through View
create view Students2013Batch
as
select * from Students where StudentBatch=2013
go

insert into Students2013Batch values (12,'xyz', 2014,3)
go

Select* from Students
go
Select * from Students2014Batch



--IN  Using Check Option
create view Students2014Batch
as
select * from Students where StudentBatch=2014
WITH CHECK OPTION
go

insert into Students2014Batch values (13,'ABC', 2013,3)
go

Select* from Students
go
Select * from Students2014Batch




