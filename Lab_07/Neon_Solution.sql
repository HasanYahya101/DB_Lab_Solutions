use Neon;
GO
select * from Students
select * from Courses
select * from Instructors
select * from Registration
select * from Semester
select * from Courses_Semester
select * from ChallanForm
GO
-- Create a trigger which don’t allow you to delete any student from student Table. 
-- Print message “You don’t have the permission to delete the student” 
CREATE TRIGGER trg_NoDeleteStudents
ON Students
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'You don’t have the permission to delete the student';
END;
GO
-- Create a trigger which don’t allow you to insert any course in Courses Table. 
-- Print message “You don’t have the permission to Insert a new Course” 
CREATE TRIGGER trg_NoInsertCourses
ON Courses
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'You don’t have the permission to Insert a new Course';
END;
GO
-- Create a new table, ‘Notify’ that should notify students about any important events. The table has three 
-- columns,  NotifictionID,  StudentID  and  Notification  String.  Create  a  Trigger  to  notify  student  if  his 
-- registration in the course is successful. Also inform user if registration is not successful.
CREATE TABLE Notify
(
    NotificationID int PRIMARY KEY,
    StudentID varchar(7) FOREIGN KEY REFERENCES Students(RollNo),
    Notification varchar(255)
);
GO
-- Create the trigger
CREATE TRIGGER trgNotifyRegistration
ON Registration
AFTER INSERT
AS
BEGIN
    DECLARE @Semester VARCHAR(15);
    DECLARE @RollNumber VARCHAR(7);
    DECLARE @CourseID INT;
    DECLARE @Section VARCHAR(1);
    DECLARE @GPA FLOAT;

    -- Get the inserted values
    SELECT @Semester = Semester,
           @RollNumber = RollNumber,
           @CourseID = CourseID,
           @Section = Section,
           @GPA = GPA
    FROM inserted;

    -- Check if registration is successful
    DECLARE @RegistrationStatus VARCHAR(50);
    IF EXISTS (
        SELECT 1
        FROM Courses_Semester cs
        INNER JOIN Students s ON s.Department = cs.Department
        WHERE cs.CourseID = @CourseID
        AND cs.Semester = @Semester
        AND cs.Section = @Section
        AND cs.AvailableSeats > 0
        AND s.RollNo = @RollNumber
    )
    BEGIN
        -- Successful registration
        SET @RegistrationStatus = 'Congratulations! Your registration for CourseID ' + CAST(@CourseID AS VARCHAR(10)) + ' in section ' + @Section + ' for semester ' + @Semester + ' is successful.';
    END
    ELSE
    BEGIN
        -- Unsuccessful registration
        SET @RegistrationStatus = 'Sorry, your registration for CourseID ' + CAST(@CourseID AS VARCHAR(10)) + ' in section ' + @Section + ' for semester ' + @Semester + ' was not successful due to unmet prerequisites or no available seats.';
    END

    -- Insert notification into Notify table
    INSERT INTO Notify (StudentID, Notification)
    VALUES (@RollNumber, @RegistrationStatus);
END;
-- According to university rules, Students before enrolling in new course should have no fee charges due.
-- Create a trigger to ensure that no student is enrolled in new course with more than 20,000 fee charges
-- due.
GO
CREATE TRIGGER EnforceFeeLimit
ON Registration
FOR INSERT
AS
BEGIN
    DECLARE @RollNumber varchar(7);
    DECLARE @TotalDues int;

    SELECT @RollNumber = RollNumber, @TotalDues = TotalDues
    FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM ChallanForm
        WHERE RollNumber = @RollNumber
        AND TotalDues > 20000
    )
    BEGIN
        RAISERROR ('Cannot enroll in new course. Fee charges exceed 20,000.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
-- Create a trigger that do not let you delete any course semester whose available seats are less than 10. 
-- Print ‘not possible’. 
-- Otherwise prints ‘Successfully deleted’, after you delete any course semester whose available seats are 
-- 10 or more.
GO
CREATE TRIGGER trgPreventDeleteCourseSemester
ON Courses_Semester
INSTEAD OF DELETE
AS
BEGIN
    -- Check if any rows are being deleted
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        DECLARE @Semester VARCHAR(15);
        DECLARE @Section VARCHAR(1);

        -- Get the semester and section being deleted
        SELECT @Semester = Semester, @Section = Section FROM deleted;

        -- Check if available seats are less than 10
        IF EXISTS (
            SELECT 1
            FROM Courses_Semester
            WHERE Semester = @Semester AND Section = @Section AND AvailableSeats < 10
        )
        BEGIN
            -- Print 'not possible' if available seats are less than 10
            PRINT 'Not possible';
        END
        ELSE
        BEGIN
            -- Delete the course semester if available seats are 10 or more
            DELETE FROM Courses_Semester WHERE Semester = @Semester AND Section = @Section;
            PRINT 'Successfully deleted';
        END
    END
END;
GO
-- Create a trigger to stop Instructors table, from being modified or dropped.
CREATE TRIGGER trgPreventModifyDropInstructors
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    DECLARE @Data XML;
    SET @Data = EVENTDATA();

    -- Check if the event is for modifying or dropping the Instructors table
    IF @Data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'VARCHAR(256)') = 'Instructors'
    BEGIN
        PRINT 'Modification or dropping of the Instructors table is not allowed.';
        ROLLBACK;
    END
END;
GO
-- Lastly DROP the Database as the Lab is done
use master;
GO
DROP DATABASE Neon;
