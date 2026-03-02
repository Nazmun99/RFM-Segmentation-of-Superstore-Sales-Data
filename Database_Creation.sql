DROP DATABASE superstore;

-- database creation
CREATE DATABASE superstore;
USE superstore;

-- TABLE CREATION
CREATE TABLE superstore_sale(
     ROW_ID INT PRIMARY KEY,
     Order_Priority VARCHAR(50),
     Discount DECIMAL(10,2),
     Unit_price DECIMAL(10,2),
     Shipping_cost DECIMAL(10,2),
     CUSTOMER_ID INT,
     Customer_Name VARCHAR(50),
     Ship_mode VARCHAR(50),
     Customer_segment VARCHAR(50),
     Product_category VARCHAR(50),
     Product_sub_category VARCHAR(50),
     Product_Container VARCHAR(50),
     Product_name VARCHAR(50),
     Product_base_margin VARCHAR(100),
     Region VARCHAR(50),
     Manager VARCHAR(50),
     State_or_province VARCHAR(50),
     City VARCHAR(25),
     Postal_code INT,
     Order_date TEXT,
     Ship_date TEXT,
     Profit DECIMAL(10,3),
     Quantity_ordered_now INT,
     Sales DECIMAL(15,2),
     Order_id BIGINT,
     Return_status VARCHAR(25));
	
    -- View overall dataset
     SELECT *
     FROM superstore_sale;