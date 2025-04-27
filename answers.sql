-- Question one
-- Step 1: Create the original table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Step 2: Insert sample data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 3: Create a new table in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Step 4: Populate the new table with normalized data
-- Using a loop or recursive approach to split the Products column

-- First, determine the maximum number of products in any row
SET @max_products = (
    SELECT MAX(LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1)
    FROM ProductDetail
);

-- Now, insert normalized data into the new table
SET @i = 1;
WHILE @i <= @max_products DO
    INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
    SELECT 
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', @i), ',', -1))
    FROM ProductDetail
    WHERE LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= @i - 1;
    
    SET @i = @i + 1;
END WHILE;

-- Step 5: Verify the result
SELECT * FROM ProductDetail_1NF;


  -- QUESTION 2
-- Step 1: Create the 'Orders' table to store customer information
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Populate the 'Orders' table with unique OrderID and CustomerName
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create the normalized 'OrderDetails_2NF' table
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Populate the normalized 'OrderDetails_2NF' table
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Step 5: Verify the result
SELECT * FROM Orders;
SELECT * FROM OrderDetails_2NF;
