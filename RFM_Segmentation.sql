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

-- RFM_Segmentation

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

-- RFM Segmentation--
CREATE OR REPLACE VIEW RFM_Score_Data as
WITH CUSTOMER_AGGREGATED_DATA AS
(SELECT
     CUSTOMER_NAME,
     CUSTOMER_ID,
     DATEDIFF((SELECT MAX(Formated_Ordered_date) FROM Sales),MAX(Formated_Ordered_date)) as RECENCY,
     COUNT(*) AS FREQUENCY,
     ROUND(SUM(sales),2) as Monetary
FROM sales
GROUP BY 1,2
ORDER BY 3),

RFM_SCORE AS
(SELECT
     C.*,
	 NTILE(5) OVER (ORDER BY RECENCY DESC) AS R_SCORE,
     NTILE(5) OVER (ORDER BY FREQUENCY ASC) AS F_SCORE,
     NTILE(5) OVER (ORDER BY Monetary ASC) AS M_SCORE
FROM CUSTOMER_AGGREGATED_DATA AS C)

SELECT
      R.CUSTOMER_NAME,
      R.CUSTOMER_ID,
      R.RECENCY,
      R.R_SCORE,
      R.FREQUENCY,
      R.F_SCORE,
      R.Monetary,
      R.M_SCORE,
      (R_SCORE+F_SCORE+M_SCORE) AS RFM_Score,
      CONCAT_WS('',R_SCORE,F_SCORE,M_SCORE) AS RFM_Score_combination
 FROM RFM_SCORE AS R;     

SELECT
     *
FROM RFM_Score_Data;

CREATE OR REPLACE VIEW RFM_ANALYSIS AS
SELECT
     RS.*,
     CASE
		WHEN RFM_Score_combination IN ('555', '554', '553', '552', '551') THEN 'Champion Customers'
        WHEN RFM_Score_combination IN ('543', '542', '541', '532', '531') THEN 'Loyal Customers'
        WHEN RFM_Score_combination IN ('535', '534', '533', '525', '524', '523') THEN 'Potential Loyalists'
        WHEN RFM_Score_combination IN ('515', '514', '513', '412', '411') THEN 'Recent Customers'
        WHEN RFM_Score_combination IN ('421', '422', '423', '321', '322') THEN 'Promising Customers'
        WHEN RFM_Score_combination IN ('311', '312', '313', '211', '212') THEN 'Needs Attention'
        WHEN RFM_Score_combination IN ('431', '432', '433', '331', '332') THEN 'About to Sleep'
        WHEN RFM_Score_combination IN ('221', '222', '223', '121', '122') THEN 'At Risk'
        WHEN RFM_Score_combination IN ('113', '112', '111') THEN 'Lost Customers'
        WHEN RFM_Score_combination IN ('511', '522', '531') THEN 'Cannot Lose Them'
        ELSE 'Other'
	 END AS Customer_Segment
FROM RFM_Score_Data AS RS;

SELECT
     *
FROM RFM_ANALYSIS;

SELECT
     Customer_Segment,
     COUNT(*) AS customer_types_count,
     SUM(Monetary) AS Total_invest
FROM RFM_ANALYSIS
GROUP BY Customer_Segment;
