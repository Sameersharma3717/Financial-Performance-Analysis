/*
=========================================================
Project: Financial Performance Analysis
Author: Sameer Sharma
Database: financial_performance
Tools Used: MySQL

Description:
This SQL project analyzes financial performance data to
evaluate revenue, profitability, product performance,
customer segments, discount impact, and country-wise sales.
The analysis provides business insights to support
data-driven financial decision-making.
=========================================================
*/
/*
=========================================================
Difficulty Level : Intermediate to Advanced

Total Business Questions Solved : 45

Approximate SQL Concepts Used :

• Aggregate Functions
• GROUP BY
• HAVING
• CASE
• CTE
• Subqueries
• Window Functions
• Ranking Functions
• Running Totals
• Time Intelligence
• Financial Analysis
=========================================================
*/
/*
=========================================================
TABLE OF CONTENTS

1. Data Quality Assessment
2. Executive KPI Summary
3. Sales Performance Analysis
4. Profitability Analysis
5. Advanced SQL Analytics
6. Executive Business Reports
7. Project Summary

=========================================================
*/

/*=====================================================
1. DATA QUALITY ASSESSMENT
=====================================================

Q1.How many financial records are available for analysis?*/
SELECT COUNT(*) AS Total_Records
FROM financial;

/*This query determines the total number of financial transactions available in the dataset.
 Ensuring the expected number of records are loaded confirms that the import process was 
 successful and that the analysis is based on complete data.*/
 
 
 /*Q2.What does the dataset look like before beginning the analysis?*/
SELECT * FROM financial
LIMIT 10;

/*Previewing the first few records helps verify that the data has been imported correctly.
 It also provides an overview of the available fields and their values before performing detailed analysis.*/
 

/*Q3.Are there any missing values in the financial dataset that could affect the analysis?*/
SELECT COUNT(*) AS Total_Records,SUM(Segment IS NULL) AS Segment_Nulls,
SUM(Country IS NULL) AS Country_Nulls,SUM(Product IS NULL) AS Product_Nulls,
SUM(Discount_Band IS NULL) AS Discount_Band_Nulls,SUM(Units_Sold IS NULL) AS Units_Sold_Nulls,
SUM(Gross_Sales IS NULL) AS Gross_Sales_Nulls,SUM(Sales IS NULL) AS Sales_Nulls,
SUM(COGS IS NULL) AS COGS_Nulls,SUM(Profit IS NULL) AS Profit_Nulls
FROM financial;

/*Identifying missing values helps ensure the reliability of the analysis.
 Missing financial values could lead to incorrect revenue, profit, or performance 
 calculations and should be addressed before further analysis.*/
 
 
 /*Q4.Does the dataset contain duplicate financial transactions?*/
SELECT Segment,Country,Product,Date,COUNT(*) AS Duplicate_Count
FROM financial
GROUP BY Segment,Country,Product,Date
HAVING COUNT(*) > 1;

/*Duplicate records can inflate sales, profit, and units sold, leading to misleading business conclusions. 
Checking for duplicates helps maintain data integrity and ensures accurate reporting.*/


/*Q5.How many unique countries, products, customer segments, and discount bands are represented in the dataset?*/
SELECT COUNT(DISTINCT Country) AS Countries,COUNT(DISTINCT Product) AS Products,
COUNT(DISTINCT Segment) AS Segments,COUNT(DISTINCT Discount_Band) AS Discount_Bands
FROM financial;

/*Understanding the number of unique business entities provides an overview of the dataset's diversity.
 This helps assess market coverage and the range of products, customer segments,
 and discount strategies included in the analysis.*/
 
 
/*
=====================================================
2. EXECUTIVE KPI SUMMARY
=====================================================

Q6.What is the overall financial performance of the business?*/
SELECT
ROUND(SUM(Sales),2) AS Total_Revenue,
ROUND(SUM(Gross_Sales),2) AS Gross_Revenue,
ROUND(SUM(Profit),2) AS Total_Profit,
ROUND(SUM(Units_Sold),2) AS Total_Units_Sold,
ROUND(AVG(Sales),2) AS Average_Sale_Value,
ROUND(AVG(Profit),2) AS Average_Profit
FROM financial;

/*This query provides an executive summary of the company's financial performance by 
calculating total revenue, gross revenue, profit, units sold, and average sales. 
These KPIs serve as the foundation for evaluating overall business health.*/


/*Q7.What is the company's overall Profit Margin (%)?*/
SELECT ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Average_Profit_Margin 
FROM financial;

/*Profit Margin measures how much profit the company retains from every dollar of sales.
 A higher profit margin indicates stronger operational efficiency and better financial performance.*/
 
 
 /*
 =====================================================
3. SALES PERFORMANCE ANALYSIS
=====================================================

Q8.Which countries generate the highest sales revenue?*/
SELECT Country, ROUND(SUM(Sales),2) AS Total_Sales 
FROM financial
GROUP BY Country
ORDER BY Total_Sales DESC;

/*This analysis identifies the company's strongest revenue-generating markets 
and highlights countries that contribute the most to total sales.*/


/*Q9.Which products generate the highest sales revenue?*/
SELECT Product, ROUND(SUM(Sales),2) AS Total_Sales 
FROM financial
GROUP BY Product
ORDER BY Total_Sales DESC;

/*Understanding product-level sales helps identify top-performing products 
that drive revenue and products that may require strategic improvements.*/


/*Q10.How does each customer segment contribute to total sales?*/
SELECT Segment, ROUND(SUM(Sales),2) AS Total_Sales 
FROM financial
GROUP BY Segment
ORDER BY Total_Sales DESC;

/*Different customer segments contribute differently to total revenue. 
This analysis helps identify the organization's most valuable customer groups.*/


/*Q11.What are the monthly sales trends over time?*/
SELECT Month_Name,Month_Number,Year,ROUND(SUM(Sales),2) AS Total_Sales
FROM financial 
GROUP BY Month_Name,Month_Number,Year
ORDER BY Year,Month_Number;

/*Monthly sales trends help identify seasonality, peak sales periods,
 and months with lower demand, enabling better planning and forecasting.*/
 
 
 /*
 =====================================================
4. PROFITABILITY ANALYSIS
=====================================================

Q12.Which countries generate the highest profit?*/
SELECT Country,ROUND(SUM(Profit),2) AS Total_Profit
FROM financial
GROUP BY Country
ORDER BY Total_Profit DESC;

/*This analysis identifies the countries contributing the most to overall profitability.
 High-profit markets indicate strong pricing strategies, 
 customer demand, and operational efficiency.*/
 
 
 /*Q13.Which products generate the highest profit?*/
SELECT Product,ROUND(SUM(Profit),2) AS Total_Profit
FROM financial
GROUP BY Product
ORDER BY Total_Profit DESC;

/*Product profitability analysis helps identify which products contribute the 
most to the company's earnings rather than just generating high sales.*/


/*Q14.Which customer segments generate the highest profit?*/
SELECT Segment,ROUND(SUM(Profit),2) AS Total_Profit
FROM financial
GROUP BY Segment
ORDER BY Total_Profit DESC;

/*Different customer segments contribute differently to overall profitability.
 Understanding segment profitability supports more 
 effective resource allocation and customer targeting.*/
 
 
 /*Q15.What is the Profit Margin (%) for each product?*/
 SELECT Product,ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin_Percentage
 FROM financial
 GROUP BY Product
 ORDER BY Profit_Margin_Percentage DESC;
 
 /*Profit Margin compares profit to revenue for each product, 
 helping identify products that are both profitable and operationally efficient.*/
 
 
 /*Q16.Rank products based on total profit.*/
SELECT Product,ROUND(SUM(Profit),2) AS Total_Profit,
RANK() OVER(ORDER BY SUM(Profit) DESC) AS Profit_Rank
FROM financial
GROUP BY Product;
 
 /*Ranking products by profit helps management quickly identify the strongest and
 weakest contributors to overall profitability.*/
 
 
 /*Q17.What percentage of total revenue does each country contribute?*/
 SELECT Country,ROUND(SUM(Sales)/(
 SELECT SUM(Sales) FROM financial)*100,2) AS Total_Revenue_Percentage
 FROM financial
 GROUP BY Country
 Order by Total_Revenue_Percentage DESC;
 
 /*Revenue contribution highlights each country's share of total sales, 
 allowing management to identify the markets that drive the business.*/
 
 
 /*
=====================================================
5. ADVANCED SQL ANALYTICS
=====================================================

Q18.Which are the Top 3 highest revenue-generating products?*/
SELECT Product,ROUND(SUM(Sales),2) AS Total_Sales
FROM financial
GROUP BY Product
ORDER BY Total_Sales DESC LIMIT 3;

/*Identifying the top revenue-generating products helps management 
understand which products are driving overall business performance.*/


/*Q19.Rank all countries based on total revenue.*/
SELECT Country,ROUND(SUM(Sales),2) AS Total_Revenue, DENSE_RANK() OVER(ORDER BY SUM(Sales) DESC) AS Revenue_Rank
FROM financial
GROUP BY Country;

/*Revenue ranking highlights the strongest-performing markets and enables easy comparison across countries.*/


/*Q20.Which products generated above-average sales?*/
WITH sales_table AS(
SELECT Product,ROUND(SUM(Sales),2) AS Total_Sales
FROM financial
GROUP BY Product)
SELECT * 
FROM sales_table 
WHERE Total_Sales>(
SELECT AVG(Total_Sales) FROM sales_table);

/*Products performing above the average sales level represent the strongest contributors to overall business revenue.*/


/*(Q21.What is the cumulative sales over time?*/
SELECT Date,
ROUND(SUM(Sales),2) AS Daily_Sales,
ROUND(SUM(SUM(Sales)) OVER(ORDER BY Date),2) AS Running_Total_Sales
FROM financial
GROUP BY Date
ORDER BY Date;

/*Running totals illustrate how revenue accumulates over time,
 helping businesses monitor long-term financial growth.*/
 
 
 /*Q22.How did monthly sales change compared to the previous month?*/
 SELECT Year, Month_Number, Month_Name,ROUND(SUM(Sales),2)AS Total_Sales,
 LAG(ROUND(SUM(Sales),2))OVER(ORDER BY Year,Month_number) AS Previous_Month_Sales
 FROM financial
 GROUP BY Month_Name,Year, Month_Number
 ORDER BY Year, Month_Number ;

/*Comparing current sales with the previous month helps identify 
periods of growth or decline and reveals seasonal business patterns.*/


/*Q23.What is the Month-over-Month (MoM) sales growth percentage?*/
WITH monthly_sales AS(
SELECT  Year, Month_Number, Month_Name,ROUND(SUM(Sales),2)AS Total_Sales
FROM financial
GROUP BY Year, Month_Number, Month_Name)
SELECT *, ROUND(
((Total_Sales - LAG(Total_Sales) OVER(ORDER BY Year, Month_Number))/
LAG(Total_Sales)OVER(ORDER BY Year, Month_Number, Month_Name)*100),2) AS MoM_Growth_Percentage
FROM monthly_sales;

/*Month-over-Month growth measures the rate of change in sales 
between consecutive months, helping identify business momentum and seasonality.*/


/*Q24.Assign a unique row number to products based on total sales.*/
SELECT Product,ROUND(SUM(Sales),2)AS Total_Sales,
ROW_NUMBER()OVER(ORDER BY SUM(Sales) DESC) AS Row_Num
FROM financial
GROUP BY Product;

/*ROW_NUMBER uniquely orders products by sales performance, 
making it useful for identifying exact positions in 
performance rankings.*/


/*
=====================================================
6. EXECUTIVE BUSINESS REPORTS
=====================================================

Q25.Which discount strategy contributes the most to total sales revenue?*/
SELECT Discount_Band,ROUND(SUM(Sales),2)AS Total_Sales
FROM financial
GROUP BY Discount_Band
ORDER BY Total_Sales DESC;

/*This analysis evaluates the effectiveness of each discount strategy 
by measuring total revenue generated under different discount bands.*/


/*Q26.Which discount band delivers the highest overall profit?*/
SELECT Discount_Band,ROUND(SUM(Profit),2)AS Total_Profit
FROM financial
GROUP BY Discount_Band
ORDER BY Total_Profit DESC;

/*Comparing profit across discount bands helps determine whether
 larger discounts are improving profitability or
 simply increasing sales volume.*/
 
 
/*Q27.Which country has the highest Profit Margin (%)?*/
SELECT Country,ROUND(SUM(Profit)/SUM(Sales)*100,2)AS Profit_Margin_Percentage
FROM financial
GROUP BY Country
ORDER BY Profit_Margin_Percentage DESC;

/*Profit Margin provides a better comparison than total profit because
 it measures profitability relative to revenue generated.*/
 
 
 /*Q28. Which products contribute the most to total profit?*/
SELECT Product ,ROUND(SUM(Profit),2)AS Total_Profit,
ROUND(SUM(Profit)/(SELECT SUM(Profit)FROM financial)*100,2) AS Profit_Contribution_Percentage
FROM financial
GROUP BY Product
ORDER BY Total_Profit DESC;

/*Profit contribution identifies the products that generate the largest share of the company's total earnings.*/


/*Q29. Which customer segment has the highest average profit per transaction?*/
SELECT Segment,ROUND(AVG(Profit),2) AS Average_Profit
FROM financial
GROUP BY Segment
ORDER BY Average_Profit DESC;

/*Average profit highlights the quality of transactions within each customer segment, independent of transaction volume.*/


/*Q30. Which quarter generates the highest revenue?*/
SELECT CONCAT('Q',CEIL(Month_Number/3)) AS Quarter,
ROUND(SUM(Sales),2)AS Total_Sales 
FROM financial
GROUP BY Quarter
ORDER BY Total_Sales DESC;

/*Quarterly analysis helps identify seasonal demand patterns and supports financial planning and inventory management.*/


/*Q31. What are the Top 3 products in each country by sales?*/
WITH ProductSales AS (
SELECT Country,Product,
ROUND(SUM(Sales),2) AS Total_Sales,
ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM financial
GROUP BY Country, Product)
SELECT *
FROM ProductSales
WHERE Sales_Rank <= 3
ORDER BY Country, Sales_Rank;

/*This analysis identifies the best-performing products within each country,
 enabling localized product strategies instead of relying on global rankings.*/
 
 
 /*Q32.How can products be categorized based on their total profitability?*/
 SELECT Product,
  CASE  WHEN SUM(Profit) >= 3000000 THEN 'High Profit'
	    WHEN SUM(Profit) >= 1500000 THEN 'Medium Profit'
        ELSE 'Low Profit'
END AS Profit_Category
FROM financial
GROUP BY Product
ORDER BY SUM(Profit) DESC;

/*Categorizing products into profitability groups 
simplifies portfolio evaluation and helps prioritize strategic investments.*/


/*Q33.Which countries generate sales above the company average?*/
WITH CountrySales AS (
    SELECT Country,SUM(Sales) AS Total_Sales
    FROM financial
    GROUP BY Country)
SELECT Country,ROUND(Total_Sales,2) AS Total_Sales
FROM CountrySales
WHERE Total_Sales >(
SELECT AVG(Total_Sales)
    FROM CountrySales)
ORDER BY Total_Sales DESC;

/*Comparing each country's sales against the company average 
highlights the strongest-performing markets and those driving overall business growth.*/


/*
=====================================================
7. STRATEGIC BUSINESS ANALYSIS
=====================================================
*/

/*Q34. Which discount band generates the highest average profit?*/
SELECT Discount_Band,ROUND(AVG(Profit),2) AS Average_Profit
FROM financial
GROUP BY Discount_Band
ORDER BY Average_Profit DESC;

/*Business Insight:
This analysis compares the average profit generated under each discount band,
helping evaluate which discount strategy is the most financially effective.*/


/*Q35. How does each discount band affect Profit Margin?*/
SELECT Discount_Band,ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin_Percentage
FROM financial
GROUP BY Discount_Band
ORDER BY Profit_Margin_Percentage DESC;

/*Profit Margin by discount band helps determine whether larger discounts
improve sales while maintaining healthy profitability.*/


/*Q36. Which products are most frequently sold under High discounts?*/
SELECT Product,COUNT(*) AS Total_Transactions
FROM financial
WHERE TRIM(Discount_Band)='High'
GROUP BY Product
ORDER BY Total_Transactions DESC;

/*This analysis identifies products that rely heavily on high discounts,
which may indicate pricing or demand-related challenges.*/


/*Q37. Which products have above-average Profit Margin?*/
WITH Product_Margin AS (
SELECT Product,
ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM financial
GROUP BY Product)
SELECT *
FROM Product_Margin
WHERE Profit_Margin >
(SELECT AVG(Profit_Margin)
FROM Product_Margin)
ORDER BY Profit_Margin DESC;

/*Products with above-average profit margins contribute more efficiently
to overall profitability and should receive strategic attention.*/


/*Q38. Which is the highest-selling product in each country?*/
WITH Country_Product_Sales AS (
SELECT Country,Product,ROUND(SUM(Sales),2) AS Total_Sales,
ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM financial
GROUP BY Country, Product)
SELECT *
FROM Country_Product_Sales
WHERE Sales_Rank = 1
ORDER BY Country;

/*This report identifies the best-performing product within each country,
supporting localized sales and inventory strategies.*/


/*Q39. Which countries generate above-average profit?*/
WITH Country_Profit AS (
SELECT Country,SUM(Profit) AS Total_Profit
FROM financial
GROUP BY Country)
SELECT Country,
ROUND(Total_Profit,2) AS Total_Profit
FROM Country_Profit
WHERE Total_Profit >
(SELECT AVG(Total_Profit)
FROM Country_Profit)
ORDER BY Total_Profit DESC;

/*Countries with above-average profit represent the strongest financial markets
and should be prioritized for future business expansion.*/


/*Q40. What percentage of total profit does each country contribute?*/
SELECT Country,
ROUND(SUM(Profit),2) AS Total_Profit,
ROUND(
(SUM(Profit)/
(SELECT SUM(Profit) FROM financial))*100,2) AS Profit_Contribution_Percentage
FROM financial
GROUP BY Country
ORDER BY Profit_Contribution_Percentage DESC;

/*Profit contribution highlights the countries responsible for generating
the largest share of the company's overall earnings.*/


/*Q41. Which Country-Product combination generates the highest revenue?*/
SELECT Country,Product,
ROUND(SUM(Sales),2) AS Total_Revenue
FROM financial
GROUP BY Country, Product
ORDER BY Total_Revenue DESC
LIMIT 10;

/*This report identifies the strongest country-product combinations,
helping management focus on high-performing markets and products.*/


/*Q42. Which products generate the highest revenue per unit sold?*/
SELECT Product,
ROUND(
SUM(Sales)/SUM(Units_Sold)
,2) AS Revenue_Per_Unit
FROM financial
GROUP BY Product
ORDER BY Revenue_Per_Unit DESC;

/*Revenue per unit measures product pricing effectiveness and helps identify
premium products generating higher value per sale.*/


/*Q43. Which month generated the highest revenue?*/
SELECT Month_Name,
ROUND(SUM(Sales),2) AS Total_Revenue
FROM financial
GROUP BY Month_Name
ORDER BY Total_Revenue DESC;

/*Identifying the highest revenue month helps understand seasonal demand
and supports inventory and marketing planning.*/


/*Q44. Compare Gross Sales, Net Sales and Discounts*/
SELECT
ROUND(SUM(Gross_Sales),2) AS Gross_Sales,
ROUND(SUM(Discounts),2) AS Total_Discounts,
ROUND(SUM(Sales),2) AS Net_Sales
FROM financial;

/*Comparing Gross Sales, Discounts and Net Sales illustrates the financial
impact of discount strategies on total revenue.*/


/*Q45. Which customer segment performs best overall?*/
SELECT Segment,
ROUND(SUM(Sales),2) AS Total_Revenue,
ROUND(SUM(Profit),2) AS Total_Profit,
ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin_Percentage
FROM financial
GROUP BY Segment
ORDER BY Total_Profit DESC;

/*Evaluating revenue, profit and profit margin together provides a complete
view of customer segment performance and profitability.*/


/*
=====================================================
PROJECT SUMMARY
=====================================================

This project analyzed financial performance data using SQL to evaluate
sales, profitability, product performance, customer segments, discount
strategies, country-wise performance, and time-based financial trends.

Key SQL concepts demonstrated in this project include:

✓ Aggregate Functions (SUM, AVG, COUNT, ROUND)
✓ GROUP BY & HAVING
✓ CASE Statements
✓ Common Table Expressions (CTEs)
✓ Subqueries
✓ Window Functions
✓ RANK(), DENSE_RANK(), ROW_NUMBER()
✓ LAG()
✓ Running Totals
✓ Month-over-Month (MoM) Growth Analysis
✓ Revenue & Profit Contribution Analysis
✓ Financial KPI Calculations
✓ Executive Business Reporting

This project demonstrates the use of SQL not only for data retrieval,
but also for solving real-world business problems through analytical
thinking and data-driven insights.

=====================================================
END OF PROJECT
=====================================================
*/








 
 
 