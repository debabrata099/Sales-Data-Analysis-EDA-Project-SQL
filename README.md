# Sales-Data-Analysis-EDA-Project-SQL
A relational database project based on sales data including customers, products, and transactions.
This project covers complete Exploratory Data Analysis (EDA) using SQL with real-world business scenarios.

This project demonstrates practical SQL skills including data exploration, aggregation, joins, window functions, segmentation, and performance analysis.

## 📁 Project Structure

SQL-Sales-Analysis
customers.csv
products.csv
sales.csv
EDA_Project.sql
README.md

## 📝 Project Objectives
- Analyze sales dataset to generate business insights
- Perform data exploration and validation
- Apply SQL queries to solve real-world business problems
- Understand customer behavior and product performance
- Perform advanced analytics using SQL
## 🛠 Tech Stack
- Component	Used
- Database	MySQL
- Language	SQL
- Tools	MySQL Workbench
## 📊 Dataset Overview
### Table	Description:
- customers	Contains customer details (name, gender, country, birthdate, etc.)
- products	Includes product details (category, subcategory, cost, etc.)
- sales	Transaction data (orders, quantity, revenue, dates, etc.)
## 🧩 ER Diagram

The Entity–Relationship (ER) diagram below shows how the tables are connected in the Sales database.




## 🔍 Key SQL Learning Areas
- Filtering (WHERE, DISTINCT, NULL handling)
- Aggregations (SUM, COUNT, AVG)
- GROUP BY & HAVING
- Joins for relational mapping
- Window functions (LAG, running totals, moving average)
- Ranking analysis (Top/Bottom entities)
- Time-based analysis
- CASE statements for segmentation
## 📌 Project Tasks Overview

All SQL analysis is included in: EDA_Project.sql

### Types of Analysis Performed:
- Database exploration (tables, columns, schema)
- Data validation (missing values, relationships)
- Sales and revenue analysis
- Customer distribution by country and gender
- Product category analysis
- Time-based trends (monthly sales)
- Ranking analysis (top products & customers)
- Contribution analysis (category-wise revenue %)
- Customer segmentation (VIP, Regular, New)
- Product segmentation (cost-based and performance-based)
- Performance analysis (Year-over-Year comparison)
## 🏆 Sample Query Snippets

- Total Sales
select sum(sales_amount) as total_sales from sales;

- Top 5 products by revenue:

select p.product_name, sum(s.sales_amount) as total_revenue

from products p

join sales s on p.product_key = s.product_key

group by p.product_name

order by total_revenue desc

limit 5;

- Monthly sales trend:

select date_format(order_date, '%Y-%m') as month,

sum(sales_amount) as total_sales

from sales

group by month

order by month;

- Customer Segmentation:

case

when total_spending > 5000 then 'VIP'

when total_spending <= 5000 then 'Regular'

else 'New'
end

## 🚀 How to Run
- Open MySQL
- mysql -u root -p
- Create database
- CREATE DATABASE Data_Analytics;
- Use database
- USE Data_Analytics;
- Run SQL file
- source EDA_Project.sql;
- Import CSV files into tables
- (using MySQL Workbench or LOAD DATA INFILE)

## 🔮 Future Enhancements
- Create dashboard using Power BI / Tableau
- Automate reports using Python
- Add stored procedures and triggers
- Perform predictive analysis
## 👨‍💻 Author

Debabrata Das

Aspiring Data Analyst
