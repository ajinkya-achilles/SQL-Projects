	CREATE DATABASE assignment2;

USE assignment2;

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY IDENTITY(1,1),
    restaurant_name NVARCHAR(255),
    cuisine_type NVARCHAR(255),
    rating FLOAT,
    average_cost FLOAT
);

INSERT INTO restaurants (restaurant_name, cuisine_type, rating, average_cost)
VALUES
('Spicy Grill', 'Chicken', 4.5, 25.00),
('Vegan Delight', 'Vegetarian', 3.8, 15.00),
('Sushi World', 'Seafood', 4.2, 30.00),
('Quick Bites', 'Chicken', 2.5, 10.00),
('Pasta Palace', 'Italian', 3.9, 20.00),
('The Curry House', 'Chicken', 4.8, 35.00);

-- ---------------------------- Task 1 ------------------------------------------------------
/*  Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick
 Chicken Bites’.*/

CREATE FUNCTION dbo.stuff_chicken_into_quick_bites(@cuisine_name NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    RETURN CONCAT(@cuisine_name, ' Quick Bites');
END

-- ----------------------------------------task 2- ---------------------------------------------

/*  Use the function to display the restaurant name and cuisine type which has the
 maximum number of rating */

SELECT restaurant_name,
       dbo.stuff_chicken_into_quick_bites(cuisine_type) AS cuisine_with_bites
FROM restaurants
WHERE rating = (SELECT MAX(rating) FROM restaurants);

-- -------------------------------------Task 3 -----------------------------------------------------------
/* Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4
 start rating, ‘Good’ if it has above 3.5 and below 5 star rating, ‘Average’ if it is above 3
 and below 3.5 and ‘Bad’ if it is below 3 star rating. */

ALTER TABLE restaurants ADD rating_status NVARCHAR(50);

UPDATE restaurants
SET rating_status = CASE
    WHEN rating > 4 THEN 'Excellent'
    WHEN rating > 3.5 AND rating <= 4 THEN 'Good'
    WHEN rating > 3 AND rating <= 3.5 THEN 'Average'
    ELSE 'Bad'
END;

Select * From restaurants;
-- ------------------------- task 4 -----------------------------------------------
/*  Find the Ceil, floor and absolute values of the rating column and display the current date
 and separately display the year, month_name and day
 */

 SELECT rating,
       CEILING(rating) AS ceil_rating,
       FLOOR(rating) AS floor_rating,
       ABS(rating - 4) AS abs_rating_difference,
       GETDATE() AS current_date1,
       YEAR(GETDATE()) AS year,
       DATENAME(MONTH, GETDATE()) AS month_name,
       DAY(GETDATE()) AS day
FROM restaurants;

----------------------------- Task 5 ------------------------------
---  Display the restaurant type and total average cost using rollup
Select * From restaurants;

SELECT restaurant_type,
       AVG(average_cost) AS avg_cost
FROM restaurants
GROUP BY ROLLUP (restaurant_type);

---------------------
ALTER TABLE restaurants ADD restaurant_type NVARCHAR(255);

UPDATE restaurants
SET restaurant_type = CASE
    WHEN restaurant_name = 'Spicy Grill' THEN 'Casual Dining'
    WHEN restaurant_name = 'Vegan Delight' THEN 'Fast Food'
    WHEN restaurant_name = 'Sushi World' THEN 'Fine Dining'
    WHEN restaurant_name = 'Quick Bites' THEN 'Fast Food'
    WHEN restaurant_name = 'Pasta Palace' THEN 'Casual Dining'
    WHEN restaurant_name = 'The Curry House' THEN 'Fine Dining'
END;


INSERT INTO restaurants (restaurant_name, cuisine_type, rating, average_cost, restaurant_type)
VALUES
('BBQ Haven', 'Barbecue', 4.1, 28.00, 'Casual Dining'),
('Mexican Fiesta', 'Mexican', 4.0, 20.00, 'Fast Food'),
('Steakhouse Prime', 'Steakhouse', 4.6, 50.00, 'Fine Dining'),
('Deli Delights', 'Sandwiches', 3.9, 18.00, 'Casual Dining'),
('Seafood Central', 'Seafood', 4.3, 32.00, 'Fine Dining');


Select * From restaurants;

SELECT restaurant_type,
       AVG(average_cost) AS avg_cost
FROM restaurants
GROUP BY ROLLUP (restaurant_type);
