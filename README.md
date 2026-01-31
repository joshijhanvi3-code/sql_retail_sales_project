# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project_1`

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and handle missing or null values to ensure data quality.
3. **Exploratory Data Analysis (EDA)**: Perform exploratory analysis to understand sales patterns and data distribution.
4. **Business Analysis**: Use SQL to answer key business questions and derive insights from the data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts with creating a database named 'sql_project_1'
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql

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
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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
```
- Only columns critical for sales analysis (quantity, price_per_unit, COGS, total_sale) were considered for deletion to preserve as much data as possible.

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:


1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_sales
where category ='Clothing'
and quantity>=4
and sale_date between '2022-11-01' and '2022-11-30';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,sum(total_sale),count(*) as total_orders from retail_sales 
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(avg(age),2) as avg_age from retail_sales
WHERE category='Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category ,gender,count(*) as total_transactions from retail_sales
GROUP BY category,gender 
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales.**:
```sql
SELECT customer_id,SUM(total_sale) as total_sales
from retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,COUNT(DISTINCT customer_id) as unique_customers
from retail_sales
GROUP BY category;
```


10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```


## Findings
The analysis led to the following key insights:

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

