create DATABASE assignment1;

USE assignment1;

CREATE TABLE Salesman (
    SalesmanId INT,
    Name VARCHAR(255),
    Commission DECIMAL(10, 2),
    City VARCHAR(255),
    Age INT
);

INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
VALUES
    (101, 'Joe', 50, 'California', 17),
    (102, 'Simon', 75, 'Texas', 25),
    (103, 'Jessie', 105, 'Florida', 35),
    (104, 'Danny', 100, 'Texas', 22),
    (105, 'Lia', 65, 'New Jersey', 30);

SELECT * FROM Salesman;

CREATE TABLE Customer (
    SalesmanId INT,
    CustomerId INT,
    CustomerName VARCHAR(255),
    PurchaseAmount INT,
    );

INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
VALUES
    (101, 2345, 'Andrew', 550),
    (103, 1575, 'Lucky', 4500),
    (104, 2345, 'Andrew', 4000),
    (107, 3747, 'Remona', 2700),
    (110, 4004, 'Julia', 4545);

SELECT * FROM Customer;

CREATE TABLE Orders (OrderId int, CustomerId int, SalesmanId int, Orderdate Date, Amount money);

INSERT INTO Orders Values 
(5001,2345,101,'2021-07-01',550),
(5003,1234,105,'2022-02-15',1500);

Select * FROM Orders;

-- Task 1. Insert a new record in your Orders table.
INSERT INTO Orders
VALUES(5004, 6789, 107, '2022-11-28',2100);

--------------------------------------------------------------------------------------------------------------------------------------------------

/* task 2.  Add Primary key constraint for SalesmanId column in Salesman table. Add default
 constraint for City column in Salesman table. Add Foreign key constraint for SalesmanId
 column in Customer table. Add not null constraint in Customer_name column for the
 Customer table.
 */
 
/* ALTER TABLE [dbo].[Salesman]
 ADD CONSTRAINT Pk_Salesman PRIMARY KEY(SalesmanId);
 */
 /* Msg 8111, Level 16, State 1, Line 58
Cannot define PRIMARY KEY constraint on nullable column in table 'Salesman'.
Msg 1750, Level 16, State 0, Line 58
Could not create constraint or index. See previous errors.
*/
 -- Now we are dropping the table.
 DROP Table Salesman;
 
 SELECT * FROM Salesman;
 
 CREATE TABLE Salesman (
    SalesmanId INT PRIMARY KEY,
    Name VARCHAR(255),
    Commission DECIMAL(10, 2),
    City VARCHAR(255),
    Age INT
);

INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
VALUES
    (101, 'Joe', 50, 'California', 17),
    (102, 'Simon', 75, 'Texas', 25),
    (103, 'Jessie', 105, 'Florida', 35),
    (104, 'Danny', 100, 'Texas', 22),
    (105, 'Lia', 65, 'New Jersey', 30);

SELECT * FROM Salesman;
-- INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
--VALUES(101, 'Ram', 60, 'California', 22);

-- Add Default constraint to City column in Salesman table
ALTER TABLE Salesman
ADD CONSTRAINT DF_City DEFAULT 'Unknown' FOR City;

INSERT INTO Salesman (SalesmanId, Name, Commission, Age)
VALUES(106, 'Ram', 60, 22);

SELECT * FROM Salesman;

-- Add Not Null constraint to CustomerName column in Customer table
ALTER TABLE Customer
ALTER COLUMN CustomerName VARCHAR(255) NOT NULL;


-- Add Foreign Key constraint to SalesmanId column in Customer table
ALTER TABLE Customer
ADD CONSTRAINT FK_Customer_Salesman FOREIGN KEY (SalesmanId) REFERENCES Salesman(SalesmanId);

SELECT * FROM Customer;
SELECT * FROM Salesman;

-- As the records SalesmanId 107 and 110 in customer table is not present in Salesman Table. We cant add the Foreign Key
-- Contraint to SalemanId in Customer Table.
-- To resolve this issue, either we need to add this Salesman Ids in Salesman table or delete from Customer Table.

INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
VALUES(107, 'Sam', 53, 'New York', 19),
(110, 'Kevin', 59, 'Texas', 23);

ALTER TABLE Customer
ADD CONSTRAINT FK_Customer_Salesman FOREIGN KEY (SalesmanId) REFERENCES Salesman(SalesmanId);

-------------------------------------------------- TASK 3 ------------------------------------------------------
/*
Fetch the data where the Customer’s name is ending with ‘N’ also get the purchase
 amount value greater than 500.
*/


SELECT *
FROM Customer
WHERE CustomerName LIKE '%N'
AND PurchaseAmount > 500;

INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
VALUES
    (103, 7361, 'Aron', 900),
	(107, 3176, 'Kieron', 450);

SELECT *
FROM Customer
WHERE CustomerName LIKE '%N'
AND PurchaseAmount > 500;

----------------------------------------------task 4 ---------------------------------------------------------
/* Using SET operators, retrieve the first result with unique SalesmanId values from two
 tables, and the other result containing SalesmanId with duplicates from two tables.
 */


-- Retrieve unique SalesmanId values from both tables
SELECT SalesmanId
FROM Salesman
UNION
SELECT SalesmanId
FROM Customer;

-- Retrieve SalesmanId values including duplicates from both tables
SELECT SalesmanId
FROM Salesman

UNION ALL

SELECT SalesmanId
FROM Customer;

-- ------------------------------------- Task 5 ------------------------------------------------------
/* Diisplay the below columns which has the matching data.
 Orderdate, Salesman Name, Customer Name, Commission, and City which has the
 range of Purchase Amount between 500 to 1500
 */

SELECT 
    o.OrderDate,
    s.Name AS SalesmanName,
    c.CustomerName,
    s.Commission,
    s.City
FROM Orders o
JOIN Customer c ON o.CustomerId = c.CustomerId
JOIN Salesman s ON o.SalesmanId = s.SalesmanId
WHERE c.PurchaseAmount BETWEEN 500 AND 1500;


-- ----------------------------- Task 6 ---------------------------------
/*
Using right join fetch all the results from Salesman and Orders table
*/

SELECT 
    o.OrderId,
    o.CustomerId,
    o.SalesmanId,
    o.OrderDate,
    o.Amount,
    s.SalesmanId AS SalesmanSalesmanId,
    s.Name AS SalesmanName,
    s.Commission,
    s.City,
    s.Age
FROM Orders o
RIGHT JOIN Salesman s ON o.SalesmanId = s.SalesmanId;

