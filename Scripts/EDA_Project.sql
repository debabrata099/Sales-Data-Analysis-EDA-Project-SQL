-- Drop and recreate the "Data_Analytics" database
Drop database if exists Data_Analytics;

-- Create the Database
Create database Data_Analytics;

-- Use Database
use Data_Analytics;

-- Create Tables 
-- Create Customer Table
Create table customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);

select * from customers;

-- Create Product Table
Create table products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);

select * from products;

-- Create Sales Table
create table sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
); 

select * from sales;

-- Data Insertion
-- Data imported from CSV files using MySQL Workbench Import Wizard.
select * from customers;
select * from products;
select * from sales;



-- DATABASE EXPLORATION
-- Retrive a list of all tables in database
select 
	table_schema,
    table_name,
    table_type
from information_schema.tables
where table_schema = database();

-- Retrive all columns for a spefic table
-- Customers
select
	column_name,
    data_type,
    is_nullable,
    character_maximum_length
from information_schema.columns
where table_schema = database()
and table_name = "customers";
    
-- Products
select
	column_name,
    data_type,
    is_nullable,
    character_maximum_length
from information_schema.columns
where table_schema = database()
and table_name = "products";

-- Sales
select
	column_type,
    data_type,
    is_nullable,
    character_maximum_length
from information_schema.columns
where table_schema = database()
and table_name = "sales";



-- DIMENSION EPLORATION
-- Count Records
select 
	count(*) as Total_customers
from customers;

select 
	count(*) as Total_products
from products;

select 
	count(*) as Total_sales
from sales;

-- Retrieve a list of unique countries from which customers originate
select distinct
	country
from customers
order by country;
    
-- Retrieve a list of unique categories, subcategories, and products
select distinct
	category,
    subcategory,
    product_name
from products
order by category, subcategory, product_name;
    
-- Distinct Customers
select 
	count(distinct customer_id) as unique_customers 
from customers;

-- Check null values
select * 
from customers
where customer_id is null
or country is null;

-- Country wise Distribution
select
	country,
    count(*) as Total_customers
from customers
group by country;

-- Category wise Products
select 
	category,
    count(*) as Total_products
from products
group by category;

-- Price Validation
select * 
from products
where cost <= 0;
	
-- Relationship check
-- sales with missing customers
select *
from sales s
left join customers c
on s.customer_key = c.customer_key
where c.customer_id is null;

-- Sales with missing products
select *
from sales s
left join products p
on s.product_id = p.product_id
where p.product_id is null;



-- DATE RANGE EXPLORATION
-- Determine the first and last order date and the total duration in months.
select
	min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    timestampdiff(month, min(order_date), max(order_date)) as Order_range_months
from sales;

-- Find the youngest and oldest customer based on birthdate
select
	"Oldest" as Type,
    customer_id,
    concat(first_name," ", last_name) as Name,
    birthdate
from customers
where birthdate = (select min(birthdate) from customers)
group by customer_id, birthdate, Name

union all

select
	"Youngest" as Type,
    customer_id,
    concat(first_name, " ", last_name) as Name,
    birthdate
from customers
where birthdate = (select max(birthdate) from customers)
group by customer_id, birthdate, Name;



-- MEAUSERS EXPLORATION
-- Find the Total Sales.
select
	sum(sales_amount) as Total_Sales
from sales;

-- Find how many items are sold.
select
	sum(quantity) as Total_Quantity
from sales;

-- Find the average selling price.
select
	avg(price) as Average_Price
from sales;

-- Find the Total number of Orders.
select
	count(order_number) as Total_Orders
from sales;
select
	count(distinct order_number) as Total_Orders
from sales;

-- Find the total number of products.
select
	count(product_id) as Total_Products
from products;

-- Find the total number of customers.
select
	count(customer_id) as Total_customers
from customers;

-- Find the total number of customers that has placed an order.
select
	count(distinct customer_key) as Total_customer
from sales;

-- Generate a Report that shows all key metrics of the business.
select
	"Total Sales" as Measure_Name,
    sum(sales_amount) as Measure_Value
from sales
union all
select
	"Total Quantity" as Measure_Name,
	sum(quantity) as Measure_Value
from sales
union all
select
	"Average Price" as Measure_Name,
	avg(price) as Measure_Value
from sales
union all
select
	"Total Nr. Orders" as Measure_Name,
	count(distinct order_number) as Measure_Value
from sales
union all
select
	"Total Nr. Products" as Measure_Name,
	count(product_id) as Measure_Value
from products
union all
select
	"Total Nr. Customers" as Measure_Name,
	count(customer_id) as Measure_Value
from customers;



-- MAGNITUDE ANALYSIS
-- Find total customers by countries.
select
	country,
	count(customer_key) as Total_customer
from customers
group by country
order by Total_customer desc;

-- Find total customers by gender.
select
	gender,
    count(customer_key) as Total_customer
from customers
group by gender
order by Total_customer desc;

-- Find total products by category.
select
	category,
    count(product_key) as Total_Products
from products
group by category
order by Total_Products desc;

-- What is the average costs in each category?
select
	category,
    avg(cost) as Average_Costs
from products
group by category
order by Average_Costs desc;

-- What is the total revenue generated for each category?
select
	p.category,
    sum(s.sales_amount) as Total_Revenue
from products as p
join sales as s
on p.product_key = s.product_key
group by category
order by Total_Revenue;

-- What is the total revenue generated by each customer?
select
	c.customer_key,
    c.first_name,
    c.last_name,
    sum(s.sales_amount) as Total_Revenue
from customers as c
join sales as s
on c.customer_key = s.customer_key
group by 
	c.customer_key, 
	c.first_name, 
    c.last_name
order by Total_Revenue desc;

-- What is the distribution of sold items across countries?
select
	c.country,
    sum(s.quantity) as Total_sold_items
from customers as c
join sales as s
on c.customer_key = s.customer_key
group by country
order by Total_sold_items desc;



-- RANKING ANALYSIS
-- Which 5 products Generating the Highest Revenue?
select
	p.product_key,
    p.product_name,
    sum(s.sales_amount) as Total_revenue
from products as p
join sales as s
on p.product_key = s.product_key
group by 
	p.product_key, 
    p.product_name
order by Total_revenue desc
limit 5;

-- What are the 5 worst-performing products in terms of sales?
select
	p.product_key,
    p.product_name,
    sum(s.sales_amount) as Total_revenue
from products as p
join sales as s
on p.product_key = s.product_key
group by 
	p.product_key, 
    p.product_name
order by Total_revenue
limit 5;

-- Top 5 Products by Quantity Sold
select
	p.product_key,
    p.product_name,
    sum(s.quantity) as Total_quantity
from products as p
join sales as s
on p.product_key = s.product_key
group by
	p.product_key,
    p.product_name
order by Total_quantity desc
limit 5 ;

-- Find the top 10 customers who have generated the highest revenue.
select
	c.customer_key,
    c.first_name,
    c.last_name,
    sum(s.sales_amount) as Total_revenue
from customers as c
join sales as s
on c.customer_key = s.customer_key
group by 
	c.customer_key,
    c.first_name,
    c.last_name
order by Total_revenue desc
limit 10;

-- The 3 customers with the fewest orders placed
select
	c.customer_key,
    c.first_name,
    c.last_name,
    count(distinct s.order_number) as Total_order
from customers as c
join sales as s
on c.customer_key = s.customer_key
group by
	c.customer_key,
    c.first_name,
    c.last_name
order by Total_order
limit 3;



-- CHANGE OVER TIME ANALYSIS
-- Analyze Sales,Quantity and Customer Over Time
select
	year(order_date) as Order_Year,
    monthname(order_date) as Order_Month,
    sum(sales_amount) as Total_Sales,
    count(distinct customer_key) as Total_Customers,
    sum(quantity) as Total_Quantity
from sales
where order_date is not null
group by
	year(order_date),
    monthname(order_date)
order by
	year(order_date),
    monthname(order_date);
-- OR
select
    date_format(order_date, '%Y-%m-01') as order_date,
    SUM(sales_amount) as total_sales,
    COUNT(distinct customer_key) as total_customers,
    SUM(quantity) as total_quantity
from sales
where order_date is not null
group by date_format(order_date, '%Y-%m-01')
order by date_format(order_date, '%Y-%m-01');


-- CUMULATIVE ANALYSIS
-- Calculate the total sales per month 
-- and the running total and moving average price of sales over time
select
	Order_Month,
    sum(Total_Sales) over (order by Order_Month) as Running_Total_Sales,
    avg(Avg_Price) over (order by Order_Month) as Moving_Average_Price
from(
select
	date_format(order_date, "%Y-%m-01") as Order_Month,
    sum(sales_amount) as Total_Sales,
    avg(price) as Avg_Price
from sales 
where order_date is not null
group by date_format(order_date, "%Y-%m-01")) as T
order by Order_Month;



-- PERFORMANCE ANALYSIS
-- Analyze the yearly performance of products by comparing their sales 
-- to both the average sales performance of the product and the previous year's sales
with Yearly_Product_Sales as( 
select
	year(s.order_date) as Order_year,
    p.product_name,
    sum(s.sales_amount) as Current_Sales
from sales as s
join products as p
on p.product_key = s.product_key
where s.order_date is not null
group by 
	year(s.order_date),
	p.product_name)
select
	Order_year,
    Product_name,
    Current_Sales,
    avg(Current_Sales) over(partition by product_name) as Avg_Sales,
    Current_Sales - avg(Current_Sales) over(partition by product_name) as Diff_Avg,
    case 
		when Current_Sales - avg(Current_Sales) over(partition by product_name) > 0 then "Above Avg"
        when Current_Sales - avg(Current_Sales) over(partition by product_name) < 0 then "Below Avg"
        else "Avg"
	end as Avg_Change,
    -- Year over Year Analysis
    lag(Current_Sales) over(Partition by product_name order by Order_Year) as Prvs_Yr_Sales,
    current_Sales - lag(Current_Sales) over(Partition by product_name order by Order_Year) as Diff_Prvs_yr,
    case
		when Current_Sales - lag(Current_Sales) over(Partition by product_name order by Order_Year) > 0 then "Increase"
        when Current_Sales - lag(Current_Sales) over(Partition by product_name order by Order_Year) < 0 then "Decrease"
        else "No Change" 
	end as Prvs_Yr_Change
from Yearly_Product_Sales
order by product_name, Order_Year;


-- Which categories contribute the most to overall sales?
with Category_Sales as(
select
	p.category,
    sum(s.sales_amount) as Total_Sales
from products as p 
join sales as s
on p.product_key = s.product_key
group by p.category)
select
	Category,
    Total_Sales,
    sum(Total_Sales) over() as  Overal_Sales,
    concat(round((cast(total_sales as float) / sum(total_sales) over ()) * 100, 2) , "%") as Percentage_of_Total
from Category_Sales
order by Total_Sales desc;



-- DATA SEGMANTATION ANALYSIS
-- To group data into meaningful categories for targeted insights.
-- For customer segmentation, product categorization, or regional analysis.

-- Segment products into cost ranges and 
-- count how many products fall into each segment
with Product_segments as (
select 
	product_key,
    product_name,
    cost,
    case
		when cost < 100 then "Below 100"
        when cost between 100 and 500 then "100-500"
        when cost between 500 and 1000 then "500-1000"
        else "Above 1000"
	end as Cost_range
    from products
)
select 
	Cost_range,
    count(product_key) as Total_products
from Product_segments
group by Cost_range
order by Total_products desc;


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
with Customer_Spending as (
select
	c.customer_key,
    sum(s.sales_amount) as total_spending,
    min(s.order_date) as first_order,
    max(s.order_date) as last_order,
    timestampdiff(month, min(s.order_date), max(s.order_date)) as life_span
from sales as s
left join customers as c
	on c.customer_key = s.customer_key
group by c.customer_key
)
select
	Customer_Segments,
    count(customer_key) as Total_Customers
from(
	select
		customer_key,
        case
			when life_span >= 12 and total_spending > 5000 then "VIP"
            when life_span >= 12 and total_spending <= 5000 then "Regular"
            else "New"
		end as Customer_Segments
	from Customer_Spending
) as segmented_customers
group by Customer_Segments
order by Total_Customers;




/*-- CUSTOMER REPORT
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
	- total orders
	- total sales
	- total quantity purchased
	- total products
	- lifespan (in months)
4. Calculates valuable KPIs:
	- recency (months since last order)
	- average order value
	- average monthly spend
*/
create view Customers_Report as  
with Customer_data as (
select
	s.product_key,
    s.order_number,
    s.order_date,
    s.sales_amount,
    s.quantity,
    c.customer_key,
    c.customer_number,
    concat(c.first_name, " ", c.last_name) as customer_name,
    timestampdiff(year, c.birthdate, curdate()) as age
from sales as s
left join customers as c
	on s.customer_key = c.customer_key
where s.order_date is not null
),
Customer_aggregation as (
select
	customer_key,
    customer_number,
    customer_name,
    age,
    count(distinct order_number) as Total_orders,
    sum(sales_amount) as Total_sales,
    sum(quantity) as Total_quantity,
    count(distinct product_key) as Total_products,
    max(order_date) as Last_order_date,
    timestampdiff(month, min(order_date), max(order_date)) as life_span
from Customer_data
group by
	customer_key,
    customer_number,
    customer_name,
    age
)
select
	customer_key,
    customer_number,
    customer_name,
    age,
    case
		when age < 20 then 'Under 20'
        when age between 20 and 29 then '20-29'
        WHEN age between 30 and 39 then '30-39'
        WHEN age between 40 and 49 then '40-49'
        else '50 and above'
    end as age_group,
    case 
        when life_span >= 12 and total_sales > 5000 then 'VIP'
        when life_span >= 12 and total_sales <= 5000 then 'Regular'
        else 'New'
    end as customer_segment,
    last_order_date,
    timestampdiff(month, last_order_date, curdate()) as recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    life_span,
    case 
        when total_orders = 0 then 0
        else total_sales / total_orders
    end as avg_order_value,
    case
        when life_span = 0 then total_sales
        else total_sales / life_span
    end as avg_monthly_spend
from customer_aggregation;


select * from Customers_Report;




/*-- PRODUCT REPORT
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
	- total orders
	- total sales
    - total quantity sold
	- total customers (unique)
	- lifespan (in months)
4. Calculates valuable KPIs:
	- recency (months since last sale)
	- average order revenue (AOR)
	- average monthly revenue
*/
create view Products_Report as
with  product_data as (
select
	s.order_number,
	s.order_date,
	s.customer_key,
	s.sales_amount,
	s.quantity,
    p.product_key,
    p.product_name,
    p.subcategory,
    p.category,
    p.cost
from sales as s
left join products as p
	on s.product_key = p.product_key
where order_date is not null
),
product_aggregation as (
select
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    timestampdiff(month, min(order_date), max(order_date)) as life_span,
     max(order_date) as last_sales_date,
    count(distinct order_number) as total_orders,
	COUNT(distinct customer_key) as total_customers,
    sum(sales_amount) as total_sales,
    sum(quantity) as total_quantity,
	round(avg(CAST(sales_amount as float) / nullif(quantity, 0)),1) as avg_selling_price
from product_data
group by
	product_key,
    product_name,
    category,
    subcategory,
    cost
)
select
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sales_date,
	timestampdiff(month, last_sales_date, curdate()) as recency_in_months,
    case
		when total_sales > 50000 then 'High-Performer'
        when total_sales >= 10000 then 'Mid-Range'
        else 'Low-Performer'
    end as product_segment,
    life_span,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    case
        when total_orders = 0 then 0
        else total_sales / total_orders
    end as avg_order_revenue,
    case
        when life_span = 0 then total_sales
        else total_sales / life_span
    end as avg_monthly_revenue
from product_aggregation;

select * from Products_Report;
    



