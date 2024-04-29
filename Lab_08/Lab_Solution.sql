Use master;
GO
use NEON;
GO
CREATE PROCEDURE RegisterStudent
    @RollNo varchar(7),
    @CourseID int,
    @Semester varchar(15)
AS
BEGIN
    DECLARE @CGPA float;
    SELECT @CGPA = AVG(GPA) FROM Registration WHERE RollNumber = @RollNo;

    BEGIN TRANSACTION
    IF @CGPA < 2.5
    BEGIN
        ROLLBACK TRANSACTION
        PRINT 'The student with RollNo ' + @RollNo + ' cannot enroll in the course because their CGPA is less than 2.5. They can only enroll in subjects that they can improve.'
    END
    ELSE
    BEGIN
        INSERT INTO Registration (Semester, RollNumber, CourseID)
        VALUES (@Semester, @RollNo, @CourseID);
        COMMIT TRANSACTION
    END
END
GO
-- Execute the stored procedure
EXEC RegisterStudent '1', 10, 'Spring2017';
GO
USE master;
GO
-- Drop database as it is already done
DROP DATABASE NEON;