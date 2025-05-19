---CREATING DATABASE

CREATE DATABASE SQL_PROJECT_Retail_Sales_Analysis;

---CREATING TABLE

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id INTEGER PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INTEGER,
				gender VARCHAR(15),
				age	INTEGER,
				category VARCHAR(15),
				quantity INTEGER,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

---CHECKING IF THE DATA HAS BEEN IMPORTED CORRECTLY

SELECT * FROM retail_sales;

---CHECKING THE NUMBER OF ROWS IN THE TABLE

SELECT COUNT (*) FROM retail_sales;

---DATA CLEANING---
---SEARCHING FOR THE ROWS WITH NULL VALUES

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL;

---REMOVING THE ROWS WITH NULL VALUES

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL;

---DATA EXPLORATION

---How many sales do we have

SELECT COUNT (*) AS total_sales FROM retail_sales;

---Show the list of distinct customer_ids

SELECT DISTINCT customer_id FROM retail_sales;

---How many unique customers do we have

SELECT COUNT (DISTINCT customer_id) AS total_number_of_customers FROM retail_sales;

---Show the list of unique categories

SELECT DISTINCT category FROM retail_sales;

---DATA ANALYSIS AND KEY BUSINESS PROBLEMS AND ANSWERS---

---Q.1. Write a SQL query to retrieve all rows for sales made on '2022-11-05'.

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

---Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4
in the month of November-2022.

SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR (sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 4;

---Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, COUNT (*) AS total_sales, SUM(total_sale) AS net_sales
FROM retail_sales
GROUP BY category;

---Q.4.1. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category, ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

---Q.4.2. Write a SQL query to find the average age of customers for all the categories.

SELECT category, ROUND(AVG(age),2) AS average_age
FROM retail_sales
GROUP BY category;


---Q5. Write a SQL query to find all transactions where total_sale is greater than 1000.


SELECT * FROM retail_sales
WHERE total_sale > 1000;


---Q6. Write a SQL query to find the total number of transactions made by each gender in each category


SELECT category, gender, COUNT (*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


---Q7. Write a SQL query to calculate the average sales for each month. Find out the best selling month in each year.


SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month, ROUND(AVG(total_sale)) AS average_sales
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY TO_CHAR(sale_date, 'YYYY-MM');


---OR we can use the EXTRACT operator


SELECT
	EXTRACT (YEAR FROM sale_date) AS year,
	EXTRACT (MONTH FROM sale_date) AS month,
	AVG (total_sale) AS average_sale
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC;


---Now we can use the ranking function to rank the average sales per year


SELECT
	EXTRACT (YEAR FROM sale_date) AS year,
	EXTRACT (MONTH FROM sale_date) AS month,
	AVG (total_sale) AS average_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC;


---NOW WE CAN USE THE SUBQUERY FUNCTION TO GET THE HIGHEST SELLING MONTHS IN EACH YEAR


SELECT * FROM
(
	SELECT
		EXTRACT (YEAR FROM sale_date) AS year,
		EXTRACT (MONTH FROM sale_date) AS month,
		AVG (total_sale) AS average_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY 1, 2
		ORDER BY 1, 3 DESC
) as t1
WHERE rank = 1;


---Q.8. Write a SQL query to find the top 5 customers based on the highest total sales


SELECT customer_id, SUM (total_sale) AS customer_total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM (total_sale) DESC
LIMIT 5;


---Q.9. Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT category, COUNT (DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;


---Q.10. Write a SQL query to create each shift and number of orders (example; Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT shift, COUNT (*)
FROM
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
		FROM retail_sales
)
GROUP BY shift;


SELECT * FROM retail_sales;

----END OF PROJECT 1