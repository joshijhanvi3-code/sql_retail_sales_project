create table retail_sales
       (
	   transactions_id INT PRIMARY KEY,
       sale_date DATE,
       sale_time TIME, 
       customer_id INT,
       gender VARCHAR(15),	
       age INT,
       category VARCHAR(15),
       quantiy INT,
       price_per_unit FLOAT,
       cogs	FLOAT,
       total_sale FLOAT
)

SELECT * FROM retail_sales
limit 100;

select count(*) from retail_sales;

-- Data cleaning -->

SELECT * FROM retail_sales
where 
    transactions_id is NULL
    OR 
    sale_date is NULL 
    OR
    sale_time is NULL
    OR
    customer_id is NULL
    OR
    gender is NULL
    OR
    age is NULL
    OR
    category is NULL
    OR
    quantity is NULL
    OR
    price_per_unit is NULL
    OR
    cogs is NULL
    OR
    total_sale is NULL;


DELETE FROM retail_sales
WHERE
    quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Exploration -->

-- How many sales we have :-
select count(*) as total_sale from retail_sales;

-- How many unique customers we have :-
select count(DISTINCT customer_id) as total_customer from retail_sales;


select DISTINCT category from retail_sales;

-- Data Analysis & Business Key Problems & Answers -->

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equals to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equals to 4 in the month of Nov-2022

select * from retail_sales
where category ='Clothing'
and quantity>=4
and sale_date between '2022-11-01' and '2022-11-30';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale),count(*) as total_orders from retail_sales 
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(avg(age),2) as avg_age from retail_sales
WHERE category='Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT* from retail_sales WHERE total_sale>1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category ,gender,count(*) as total_transactions from retail_sales
GROUP BY category,gender 
ORDER BY 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
	year,
	month,
	avg_sale 
from
(
SELECT
	EXTRACT(YEAR from sale_date) as year,
	EXTRACT(MONTH from sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(Year from sale_date) ORDER BY AVG(total_sale)DESC) rnk 
from retail_sales
GROUP BY 1,2
) as t1
WHERE rnk=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id,SUM(total_sale) as total_sales
from retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT category,COUNT(DISTINCT customer_id) as unique_customers
from retail_sales
GROUP BY category;
;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
AS (
SELECT *,
	CASE
	    WHEN EXTRACT(HOUR from sale_time)<12 THEN 'Morning'
	    WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		Else 'Evening'
	END as shift
from retail_sales
)

SELECT 
	shift,
	count(*) as total_orders 
from hourly_sale
GROUP BY shift



-- END of project 
