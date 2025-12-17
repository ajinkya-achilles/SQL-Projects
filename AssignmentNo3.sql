CREATE DATABASE assignment3;

USE assignment3;

CREATE TABLE restaurants (
    restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    type NVARCHAR(50),
    cuisine NVARCHAR(50),
    table_booking INT,
    area NVARCHAR(50),
    rating FLOAT,
    owner_email NVARCHAR(100)
);

INSERT INTO restaurants (name, type, cuisine, table_booking, area, rating, owner_email)
VALUES
('Restaurant A', 'Fine Dining', 'Italian', 5, 'Downtown', 4.5, 'ownerA@example.com'),
('Restaurant B', 'Cafe', 'Cafe', 3, 'Uptown', 4.0, 'ownerB@example.com'),
('Restaurant C', 'Fast Food', 'American', 0, 'Suburbs', 3.5, 'ownerC@example.com'),
('Restaurant D', 'Casual Dining', 'Mexican', 2, 'Downtown', 4.2, 'ownerD@example.com'),
('Restaurant E', 'Cafe', 'Cafe', 1, 'Uptown', 4.8, 'ownerE@example.com'),
('Restaurant F', 'Fine Dining', 'French', 4, 'Downtown', 4.6, 'ownerF@example.com'),
('Restaurant G', 'Casual Dining', 'Indian', 0, 'Suburbs', 3.9, 'ownerG@example.com'),
('Restaurant H', 'Fast Food', 'Chinese', 5, 'Downtown', 4.3, 'ownerH@example.com');

SELECT * FROM restaurants;

------------------------------------ Task 1 -------------------------------------------------------
/*
Create a stored procedure to display the restaurant name, type and cuisine where the
 table booking is not zero.
*/
CREATE PROCEDURE GetRestaurantsWithBookings
AS
BEGIN
    SELECT name, type, cuisine
    FROM restaurants
    WHERE table_booking != 0;
END;

EXEC GetRestaurantsWithBookings;

------------------------------------ Task 2 -------------------------------------
/*
Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result
 and rollback it.
*/
DROP TABLE restaurants2;

SELECT *
INTO restaurants2
FROM restaurants;

SELECT * FROM restaurants2;

BEGIN TRANSACTION;
UPDATE restaurants2
SET cuisine = 'Cafeteria'
WHERE cuisine = 'Cafe';

-- Check the result
SELECT * FROM restaurants2 WHERE cuisine = 'Cafeteria';

-- Rollback the transaction
ROLLBACK;
SELECT * FROM restaurants2 WHERE cuisine = 'Cafeteria';

--------------------------------------------- TASK 3 ------------------------
/*
Generate a row number column and find the top 5 areas with the highest rating of
 restaurants.
*/

WITH RankedAreas AS (
    SELECT area, rating,
           ROW_NUMBER() OVER (ORDER BY rating DESC) AS row_num
    FROM restaurants
)
SELECT area, rating
FROM RankedAreas
WHERE row_num <= 5;

-------------------------------------- Task 4 -----------------------------------------------------
-- se the while loop to display the 1 to 50

DECLARE @counter INT = 1;

WHILE @counter <= 50
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END;

------------------------------------------ Task 5 -------------------------------------------------------
/*
Write a query to create a view for the top 5 highest rating restaurants.
*/

CREATE VIEW TopRatingRestaurants AS
WITH RankedRestaurants AS (
    SELECT name, type, cuisine, rating,
           ROW_NUMBER() OVER (ORDER BY rating DESC) AS row_num
    FROM restaurants
)
SELECT name, type, cuisine, rating
FROM RankedRestaurants
WHERE row_num <= 5;

SELECT * FROM TopRatingRestaurants;

------------------------------------------ Task 6 -------------------------------------------------
/*
 Write a trigger that sends an email notification to the restaurant owner whenever a new
 record is inserted
 */

-- Sending mail from sql server is not straightforward and often involves integration with email services.
-- The below code is written from some research and with the help of stack overflow and google.

CREATE TRIGGER NotifyRestaurantOwner
ON restaurants
AFTER INSERT
AS
BEGIN
    DECLARE @OwnerEmail NVARCHAR(100);
    DECLARE @RestaurantName NVARCHAR(100);

    SELECT @OwnerEmail = inserted.owner_email,
           @RestaurantName = inserted.name
    FROM inserted;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'RestaurantMailProfile',
        @recipients = @OwnerEmail,
        @subject = 'New Restaurant Record Added',
        @body = 'A new record for ' + @RestaurantName + ' has been added to the database.';
END;


