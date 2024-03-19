-- Assuming the database OrderSystem already exists
use master;
GO
use OrderSystem;
-- Selecting all Tables
SELECT * FROM [Customers];
SELECT * FROM [Order];
SELECT * FROM [OrderDetails];
SELECT * FROM [Items];
GO

-- Q1: PROCEDURE InsertOrderDetails
CREATE PROCEDURE InsertOrderDetails 
    @OrderNo INT,
    @ItemNo INT,
    @Quantity INT,
    @CustomerNo VARCHAR(2)
AS
BEGIN
    DECLARE @AvailableQuantity INT

    -- Check if the provided OrderNo already exists
    IF EXISTS (SELECT 1 FROM [Order] WHERE OrderNo = @OrderNo)
    BEGIN
        PRINT 'Order with OrderNo ' + CAST(@OrderNo AS VARCHAR(10)) + ' already exists. Please provide a new OrderNo.'
        RETURN
    END

    -- Check available quantity
    SELECT @AvailableQuantity = [Quantity in Store] FROM Items WHERE ItemNo = @ItemNo

    IF @AvailableQuantity < @Quantity
    BEGIN
        PRINT 'Only ' + CAST(@AvailableQuantity AS VARCHAR(10)) + ' is present, which is less than your required quantity.'
    END
    ELSE
    BEGIN
        -- get current date
        DECLARE @Date DATE
        SET @Date = GETDATE()
        -- Insert new order
        INSERT INTO [Order] (OrderNo, CustomerNo, [Date], Total_Items_Ordered) VALUES (@OrderNo, @CustomerNo, @Date, @Quantity)
        -- Insert order details
        INSERT INTO OrderDetails (OrderNo, ItemNo, Quantity) VALUES (@OrderNo, @ItemNo, @Quantity)

        -- Update quantity in store
        UPDATE Items SET [Quantity in Store] = [Quantity in Store] - @Quantity WHERE ItemNo = @ItemNo
    END
END
GO
-- Executing the procedure (testing)
-- a): Quantity is lower than available quantity
EXEC InsertOrderDetails 5, 200, 100, 'C4';
-- b): Quantity is higher than available quantity
EXEC InsertOrderDetails 5, 200, 10, 'C4';
GO

-- Q2: PROCEDURE CustomerSignup 
GO
CREATE PROCEDURE CustomerSignup
    @CustomerNo VARCHAR(2),
    @Name VARCHAR(30),
    @City VARCHAR(3),
    @Phone VARCHAR(11),
    @Flag INT OUTPUT
AS
BEGIN
    SET @Flag = 0

    -- Check rule 1
    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerNo = @CustomerNo)
    BEGIN
        SET @Flag = 1
        -- print error
        PRINT 'Customer with CustomerNo ' + @CustomerNo + ' already exists. Please provide a new CustomerNo.'
        RETURN
    END

    -- Check rule 2
    IF @City IS NULL
    BEGIN
        SET @Flag = 2
        -- print error
        PRINT 'City cannot be NULL.'
        RETURN
    END

    -- Check rule 3
    IF LEN(@Phone) != 11
    BEGIN
        SET @Flag = 3
        -- print error
        PRINT 'Phone number must be 11 digits long.'
        RETURN
    END

    -- Insert customer
    INSERT INTO Customers (CustomerNo, Name, City, Phone) VALUES (@CustomerNo, @Name, @City, @Phone)
    -- print success
    PRINT 'Customer with CustomerNo ' + @CustomerNo + ' has been successfully added.'
END
GO
-- Executing the procedure (testing)
-- a): CustomerNo already exists
EXEC CustomerSignup 'C1', 'AHMED ALI', 'LHR', 111111, 0;
-- b): City is NULL
EXEC CustomerSignup 'C7', 'HASAN YAHYA', NULL, 11111111111, 0;
-- c): Phone number is not 11 digits long
EXEC CustomerSignup 'C7', 'HASAN YAHYA', 'LHR', 1111, 0;
-- d): All rules are satisfied
EXEC CustomerSignup 'C7', 'HASAN YAHYA', 'LHR', 11111111111, 0;
GO

-- Q3: PROCEDURE CancelOrder
GO
CREATE PROCEDURE CancelOrder
    @CustomerNo VARCHAR(2),
    @OrderNo INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerName VARCHAR(30)

    -- Check if the provided order number belongs to the provided customer
    SELECT @CustomerName = [Name]
    FROM dbo.Customers
    WHERE CustomerNo = @CustomerNo;

    IF EXISTS (
        SELECT 1
        FROM dbo.[Order]
        WHERE OrderNo = @OrderNo AND CustomerNo = @CustomerNo
    )
    BEGIN
        -- Delete order details first
        DELETE FROM dbo.OrderDetails
        WHERE OrderNo = @OrderNo;

        -- Delete the order
        DELETE FROM dbo.[Order]
        WHERE OrderNo = @OrderNo;

        PRINT 'Order no ' + CAST(@OrderNo AS VARCHAR) + ' is cancelled for customer ' + @CustomerNo + ';' + @CustomerName + '.';
    END
    ELSE
    BEGIN
        PRINT 'Order no ' + CAST(@OrderNo AS VARCHAR) + ' is not of ' + @CustomerNo + ';' + @CustomerName + '.';
    END
END
GO
-- Executing the procedure (testing)
-- a): OrderNo does not belong to the provided CustomerNo
EXEC CancelOrder 'C1', 2;
-- b): OrderNo belongs to the provided CustomerNo
EXEC CancelOrder 'C1', 1;
GO

-- Q4: PROCEDURE UpdateOrder
GO
CREATE PROCEDURE CalculateTotalPoints
    @CustomerName VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalPoints INT

    -- Calculate total points for the customer
    SELECT @TotalPoints = SUM(PointsEarned)
    FROM (
        SELECT o.CustomerNo, SUM(i.Price * od.Quantity) / 100 AS PointsEarned
        FROM dbo.[Order] o
        INNER JOIN dbo.OrderDetails od ON o.OrderNo = od.OrderNo
        INNER JOIN dbo.Items i ON od.ItemNo = i.ItemNo
        INNER JOIN dbo.Customers c ON o.CustomerNo = c.CustomerNo
        WHERE c.Name = @CustomerName
        GROUP BY o.CustomerNo
    ) AS CustomerPoints;

    -- Return the total points
    SELECT ISNULL(@TotalPoints, 0) AS TotalPoints;
    -- print the total points
    PRINT 'Total points for ' + @CustomerName + ' are ' + CAST(@TotalPoints AS VARCHAR) + '.';
END
GO
-- Executing the procedure (testing)
EXEC CalculateTotalPoints 'AYESHA'; -- Answer should be 1300
GO

-- Delete Database as the assignment is done
USE master;
GO
DROP DATABASE OrderSystem;