-- Data Cleaning --

SELECT * FROM walmartSalesData;
-- Product Analysis



-- Feature Engineering
-- Add new column time_of_day to give insights of sales
-- In the Morning, Afternoon and Evening

SELECT 
	Time, 
	(CASE 
		WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END) AS time_of_day
FROM walmartSalesData;


SELECT "Customer type" FROM walmartSalesData;


ALTER TABLE walmartSalesData 
ADD "time_of_day" VARCHAR(20);

UPDATE walmartSalesData
set time_of_day = (CASE 
		WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END
	);

-- Add a new column named day_name, containing the extracted
-- days of the week on which the given transactions took place

SELECT 
Date,DATENAME(WEEKDAY, Date)AS day_name
FROM walmartSalesData;

ALTER TABLE walmartSalesData
ADD day_name VARCHAR(10)

UPDATE walmartSalesData
SET day_name = DATENAME(WEEKDAY, Date);

-- Add Month name
SELECT 
	Date, DATENAME(MONTH, Date)AS Month_name
	FROM walmartSalesData;

ALTER TABLE walmartSalesData
ADD month_name VARCHAR(10);

UPDATE walmartSalesData
SET month_name = DATENAME(MONTH, Date);

---- Generic Questions ----------
------ How many Unique cities does the data have?
SELECT DISTINCT City FROM walmartSalesData;

------ In which city(s) are the branches located

SELECT DISTINCT City, Branch 
FROM walmartSalesData;

--- Data Exploration on Products
---- How many unique product lines does the data have?

SELECT DISTINCT [Product line] 
FROM walmartSalesData;

SELECT COUNT(DISTINCT [Product line]) AS Num_product_lines
FROM walmartSalesData;

-- What is the most common payment method
SELECT payment, COUNT(*) AS CNT
FROM walmartSalesData
GROUP BY payment
ORDER BY CNT DESC;

--- What is the most selling product line?---
SELECT [Product line], COUNT(*) AS CNT
FROM walmartSalesData
GROUP BY [Product line]
ORDER BY CNT DESC;

--- What is the total revenue by month?
SELECT 
	month_name AS Month,
	ROUND(SUM(CAST(total AS FLOAT)),2) AS total_revenue
FROM walmartSalesData
GROUP BY month_name
ORDER BY total_revenue DESC;


--- What month has the highest COGS? Cost of Goods Sold
SELECT 
	month_name AS Month,
	ROUND(SUM(CAST(cogs AS FLOAT)),2) AS cogs
FROM walmartSalesData
GROUP BY month_name
ORDER BY cogs DESC;
 

 --- What product line has the largest Revenue
 SELECT [Product line],
	SUM(CAST(Total AS FLOAT)) AS Total_Revenue
	FROM walmartSalesData
	GROUP BY [Product line]
	ORDER BY Total_Revenue DESC;

--- What City has the largest revenue
SELECT 
	Branch,
	City,
	SUM(CAST(Total AS FLOAT)) AS Total_Revenue
	FROM walmartSalesData
	GROUP BY City, Branch 
	ORDER BY Total_Revenue DESC;

	--- What Product line has the largest VAT?

SELECT 
	[Product line], 
	AVG(CAST([Tax 5%] AS FLOAT)) AS total_Vat
	FROM walmartSalesData
	GROUP BY [Product line]
	ORDER BY total_Vat DESC;




-- Which branch sold more products than average product sales?
SELECT
	Branch,
	SUM(CAST(Quantity AS INT)) AS Quantity
	FROM walmartSalesData
	GROUP BY Branch 
	HAVING SUM(CAST(Quantity AS INT)) > 
	(SELECT AVG(CAST(Quantity AS INT)) 
	FROM walmartSalesData);


--- What is the most product line by gender?
SELECT  
	Gender,
	[Product line],
	COUNT(Gender) AS total_cnt
FROM walmartSalesData
GROUP BY Gender,[Product line]
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT 
	[product line],
	AVG(CAST(Rating AS FLOAT)) AS avg_rating
	FROM walmartSalesData
	GROUP BY [Product line]
	ORDER BY avg_rating;

-- Sales ----
-- Number of sales made in each time of the day per weekday
SELECT 
	time_of_day,
	COUNT(*) AS Total_sales
	--SUM(CAST(Total AS FLOAT)) AS Total_sales
	FROM walmartSalesData
	WHERE day_name = 'Monday'
	GROUP BY time_of_day
	ORDER BY Total_sales DESC;

--- Which of the customer types brings the most revenues
SELECT 
	[Customer type],
	SUM(CAST(Total AS FLOAT)) AS total_sales
	FROM walmartSalesData
	GROUP BY [Customer type]
	ORDER BY total_sales DESC;

-- Which city has the largest tax percentVAT?
SELECT 
	City,
	ROUND(AVG(CAST([Tax 5%] AS FLOAT)),2) AS Average_Tax
	FROM walmartSalesData
	GROUP BY City
	ORDER BY Average_Tax DESC;
	   
-- Which customer type pays the most in VAT?

SELECT 
	[Customer type],
	SUM(CAST([Tax 5%] AS FLOAT)) AS VAT
	FROM walmartSalesData
	GROUP BY [Customer type]
	ORDER BY VAT DESC;

-------- Customer -------------
--- How many unique customer types does the data have?
SELECT DISTINCT [Customer type]
FROM walmartSalesData;

---- How many unique payment method does the data have?
SELECT 
	DISTINCT Payment
	FROM walmartSalesData;

--- What is the most common customer type?
SELECT 
	[Customer type], 
	COUNT(*) AS CNT
	FROM walmartSalesData
	GROUP BY [Customer type]
	ORDER BY CNT DESC;

--- What customer type buys the most?
SELECT 
	[Customer type],
	SUM(CAST(Total AS FLOAT)) AS Total_sales
	FROM walmartSalesData
	GROUP BY [Customer type]
	ORDER BY Total_sales DESC;

--- What is the gender of most of the Customers
SELECT 
	Gender,
	COUNT(*) AS gender_cnt
	FROM walmartSalesData
	GROUP BY Gender
	ORDER BY gender_cnt DESC;

--- What is the gender distribution per branch
SELECT 
	Gender,
	COUNT(*) AS gender_cnt
	FROM walmartSalesData
	WHERE Branch = 'C'
	GROUP BY Gender
	ORDER BY gender_cnt DESC;

SELECT 
	Gender,
	COUNT(*) AS gender_cnt
	FROM walmartSalesData
	WHERE Branch = 'A'
	GROUP BY Gender
	ORDER BY gender_cnt DESC;

SELECT 
	Gender,
	COUNT(*) AS gender_cnt
	FROM walmartSalesData
	WHERE Branch = 'B'
	GROUP BY Gender
	ORDER BY gender_cnt DESC;

--- What time of the day do customers give most ratings?
SELECT
	time_of_day,
	ROUND(AVG(CAST(Rating AS FLOAT)),2) AS average_rating
	FROM walmartSalesData
	GROUP BY time_of_day
	ORDER BY average_rating DESC;

-- Which day of the week have the best avg_ratings
SELECT 
	day_name,
	ROUND(AVG(CAST(Rating AS FLOAT)),2) AS average_rating
	FROM walmartSalesData
	GROUP BY day_name
	ORDER BY average_rating DESC;
