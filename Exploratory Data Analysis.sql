USE superstore;

-- 	Visualize entire dataset
SELECT *
FROM superstore_sale;

-- Total number of rows
SELECT
     COUNT(*)
FROM superstore_sale;

-- Data Preprocessing

-- Find duplicate records
SELECT
     ROW_ID,
     COUNT(*) AS duplicated_count
FROM superstore_sale
GROUP BY ROW_ID
HAVING COUNT(*)>1; -- no duplicate values

SELECT *
FROM superstore_sale
WHERE ROW_ID IN (
    SELECT ROW_ID
    FROM superstore_sale
    GROUP BY ROW_ID
    HAVING COUNT(*) > 1
)
ORDER BY ROW_ID;

-- 
SET SQL_SAFE_UPDATES=0;

-- add a date column named in Ordered_date
ALTER TABLE superstore_sale ADD Fomated_Ordered_date DATE;

-- rename table
RENAME TABLE  superstore_sale TO sales;

ALTER TABLE sales 
RENAME COLUMN Ordered_date TO Formated_Ordered_date;

SELECT *
FROM sales;

-- Convert integer days to date_formated_data
UPDATE sales
SET Formated_Ordered_date= DATE_ADD('1899-12-30',INTERVAL `Order_date` DAY);

-- count each type of order priority
SELECT
   Order_Priority,
   count(*) AS CNT
FROM sales
GROUP BY 1
ORDER BY 2;

-- Uses of PARTITION BY to find total order with details of each customer
-- N.B: GROUP BY: Hides all details except total_count
SELECT *
FROM
(SELECT
     *,
     COUNT(*) OVER (PARTITION BY `Customer_ID`) AS total_count
FROM sales) C
WHERE total_count>3;

-- Perform Exploratory Data Analysis

-- Find total unique customers
SELECT
COUNT(DISTINCT `Customer_ID`) AS CNT
FROM sales;

-- Each customer analysis
SELECT
     CUSTOMER_ID,
     Customer_Name,
     COUNT(Order_id) AS Total_order,
     ROUND(SUM(sales),2) AS Total_sales,
     ROUND(AVG(sales),2) AS Average_sales,
     MIN(sales) AS min_sales,
     MAX(sales) AS max_sales
FROM sales
GROUP BY CUSTOMER_ID, CUSTOMER_NAME
ORDER BY 3,4;

-- Identify top most customer least spended customer based on total cost and total order
SELECT
     Customer_ID,
     Customer_Name,
   ROUND(SUM(Sales),2) as Total_spent
FROM sales
GROUP BY CUSTOMER_ID, Customer_Name
ORDER BY 3 DESC
LIMIT 1;

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales), 2) AS Total_spent
FROM sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_spent
LIMIT 1;

-- Number of orders per customer
SELECT
    Customer_id,
    customer_name,
    count(*) as Total_orders
FROM sales
GROUP BY 1,2
ORDER BY 3 DESC;

-- 

-- FIND MOST AND LEAST SOLD PRODUCTS
SELECT
    Product_name,
    count(*) AS Total_sold
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT
    Product_name,
    count(*) AS Total_sold
FROM sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 1;

-- Sales Distribution by region
SELECT
   Region,
   COUNT(*) AS Total_orders,
   ROUND(SUM(Sales),2) as Total_sales
FROM sales
GROUP BY Region
ORDER BY 2,3;

--  Sales performance by manager
SELECT
     Manager,
     round(SUM(Sales),2) AS Total_sales
FROM sales
GROUP BY Manager;

-- Customers who return products
SELECT
     Customer_name,
     Customer_id,
     COUNT(*) AS Total_returns
FROM sales
WHERE Return_status='Returned'
GROUP BY 1,2
ORDER BY 3 DESC;

-- Yearly Sales Performance
SELECT
     YEAR(Formated_ordered_date) AS Year,
	 ROUND(SUM(sales),2) AS Total_sales
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- Maximum and minimum order date of the superstore sales
SELECT
     MAX(Formated_ordered_date) AS Max_date,
     MIN(Formated_ordered_date) AS Min_date
FROM sales;

-- SELECT Total distinct order 
SELECT
     COUNT(Order_id)
FROM sales; -- 7306

SELECT
     COUNT(DISTINCT Order_id)
FROM sales; -- 5415