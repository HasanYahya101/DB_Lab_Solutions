USE master;
GO
USE Lab5;
-- Select all tables for viewing
SELECT * FROM Customers;
SELECT * FROM Items;
SELECT * FROM [Order];
SELECT * FROM OrderDetails;
GO
-- 1: Create a View that gives order number and total price of that order (price= item price * item Quantity )
CREATE VIEW OrderTotalPriceView
AS
SELECT OrderNo,
       SUM(Items.Price * OrderDetails.Quantity) AS TotalPrice
FROM [dbo].[OrderDetails]
INNER JOIN [dbo].[Items] ON OrderDetails.ItemNo = Items.ItemNo
GROUP BY OrderNo;
GO
-- testing the view
SELECT * FROM OrderTotalPriceView;
GO
-- 2: Create a View that gives all the items that are doing well in sales. The criteria to judge which item is doing good sale is that the item is has sold more than 20 pieces.
CREATE VIEW WellSellingItemsView
AS
SELECT Items.ItemNo,
       Items.Name AS ItemName,
       Items.Price,
       Items.[Quantity in Store],
       SUM(OrderDetails.Quantity) AS TotalSold
FROM [dbo].[Items]
INNER JOIN [dbo].[OrderDetails] ON Items.ItemNo = OrderDetails.ItemNo
GROUP BY Items.ItemNo, Items.Name, Items.Price, Items.[Quantity in Store]
HAVING SUM(OrderDetails.Quantity) > 20;
GO
-- testing the view
SELECT * FROM WellSellingItemsView;
GO
-- 3: Create a view that return StarCustomers. StarCustomers are the customers who have made a purchase of more than 2000.
CREATE VIEW StarCustomersView
AS
SELECT Customers.CustomerNo,
       Customers.Name AS CustomerName,
       Customers.City,
       Customers.Phone,
       SUM(Items.Price * OrderDetails.Quantity) AS TotalPurchase
FROM [dbo].[Customers]
INNER JOIN [dbo].[Order] ON Customers.CustomerNo = [Order].CustomerNo
INNER JOIN [dbo].[OrderDetails] ON [Order].OrderNo = OrderDetails.OrderNo
INNER JOIN [dbo].[Items] ON OrderDetails.ItemNo = Items.ItemNo
GROUP BY Customers.CustomerNo, Customers.Name, Customers.City, Customers.Phone
HAVING SUM(Items.Price * OrderDetails.Quantity) > 2000;
GO
-- testing the view
SELECT * FROM StarCustomersView;
GO
-- 4: Create a view that returns all the customers that have phone number not null.
-- Create it without check option.
CREATE VIEW CustomersWithPhoneNotNull
AS
SELECT *
FROM dbo.Customers
WHERE Phone IS NOT NULL;
GO
-- Create the same view with WITH CHECK option.
CREATE VIEW CustomersWithPhoneNotNull_Check
AS
SELECT *
FROM dbo.Customers
WHERE Phone IS NOT NULL
WITH CHECK OPTION;
GO
-- a. Now try to insert, delete and update though the view, and observe the results.
-- With Check:
-- Insert: It will not allow to insert a row with NULL phone number.
INSERT INTO CustomersWithPhoneNotNull_Check (CustomerNo, Name, City, Phone)
VALUES ('C7', 'John Doe', 'NYC', NULL);
-- Update: It will not allow to update a row with NULL phone number.
UPDATE CustomersWithPhoneNotNull_Check
SET Phone = NULL
WHERE CustomerNo = 'C6';
-- Delete: It will not allow to delete a row with NULL phone number (there is none with null in the data).
DELETE FROM CustomersWithPhoneNotNull_Check
WHERE CustomerNo = 'C6';
-- Without Check:
-- Insert: It will allow to insert a row with NULL phone number.
INSERT INTO CustomersWithPhoneNotNull (CustomerNo, Name, City, Phone)
VALUES ('C7', 'John Doe', 'NYC', NULL);
-- Update: It will allow to update a row with NULL phone number.
UPDATE CustomersWithPhoneNotNull
SET Phone = NULL
WHERE CustomerNo = 'C6';
-- Delete: It will allow to delete a row with NULL phone number.
DELETE FROM CustomersWithPhoneNotNull
WHERE CustomerNo = 'C6';