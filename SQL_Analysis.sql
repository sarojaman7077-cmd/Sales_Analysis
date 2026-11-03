-- Delhi NCR Sales Analysis
-- SQL Server version
-- Source: Delhi_NCR.xlsx / Clean_Data

--bcp DelhiNCRSalesDB.dbo.SalesData in "C:\Users\Anandpratap Saroj\Desktop\A\Projects\Sql Projects\Sales\Sales_NEW.csv" -S "ANAND" -T -c -t, -F 2 -e "C:\Users\Anandpratap Saroj\Desktop\A\Projects\Sql Projects\Sales\Sales_Error.txt"

--CREATE DATABASE DelhiNCRSalesDB;
--GO
USE DelhiNCRSalesDB;
GO


IF NOT EXISTS(select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SalesData')
Begin
CREATE TABLE SalesData (
    Order_ID VARCHAR(30) PRIMARY KEY,
    Order_Date Varchar(20),
    Customer_ID VARCHAR(30),
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Product_Name VARCHAR(150),
    Segment VARCHAR(50),
    Sales_Channel VARCHAR(50),
    Payment_Method VARCHAR(50),
    Sales_Rep VARCHAR(50),
    Quantity INT,
    Unit_Price_INR DECIMAL(18,2),
    Gross_Sales_INR DECIMAL(18,2),
    Discount_Percent DECIMAL(8,2),
    Discount_Amount_INR DECIMAL(18,2),
    Sales_INR DECIMAL(18,2),
    Cost_INR DECIMAL(18,2),
    Profit_INR DECIMAL(18,2),
    Shipping_Cost_INR DECIMAL(18,2),
    Profit_After_Shipping_INR DECIMAL(18,2),
    Order_Status VARCHAR(30),
    Delivery_Days DECIMAL(10,2),
    Customer_Rating DECIMAL(4,2),
    Month VARCHAR(20),
    Month_No INT,
    Year INT,
    Quarter VARCHAR(10),
    Order_Month VARCHAR(20)
);
END
GO

-- 1. Overall KPIs
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Sales_INR) AS Total_Sales,
    SUM(Profit_After_Shipping_INR) AS Net_Profit,
    SUM(Quantity) AS Total_Quantity,
    AVG(Customer_Rating) AS Avg_Rating
FROM SalesData;

-- 2. Monthly sales and profit
SELECT Year, Month_No, Month,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit
FROM SalesData
GROUP BY Year, Month_No, Month
ORDER BY Year, Month_No;

-- 3. Category performance
SELECT Category,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit,
       ROUND(SUM(Profit_After_Shipping_INR) * 100.0 / NULLIF(SUM(Sales_INR),0),2) AS Net_Margin_Pct
FROM SalesData
GROUP BY Category
ORDER BY Sales DESC;

-- 4. City performance
SELECT City,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit
FROM SalesData
GROUP BY City
ORDER BY Sales DESC;

-- 5. Sales channel performance
SELECT Sales_Channel,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit
FROM SalesData
GROUP BY Sales_Channel
ORDER BY Sales DESC;

-- 6. Order status analysis
SELECT Order_Status,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales
FROM SalesData
GROUP BY Order_Status
ORDER BY Orders DESC;

-- 7. Top 10 products by sales
SELECT TOP 10 Product_Name,
       SUM(Quantity) AS Quantity_Sold,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit
FROM SalesData
GROUP BY Product_Name
ORDER BY Sales DESC;

-- 8. Sales representative performance
SELECT Sales_Rep,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit
FROM SalesData
GROUP BY Sales_Rep
ORDER BY Sales DESC;

-- 9. Delivery and rating
SELECT City,
       AVG(Delivery_Days) AS Avg_Delivery_Days,
       AVG(Customer_Rating) AS Avg_Rating
FROM SalesData
WHERE Delivery_Days IS NOT NULL
GROUP BY City
ORDER BY Avg_Delivery_Days;

-- 10. High-value customer analysis
SELECT TOP 20 Customer_ID, Customer_Name,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Sales_INR) AS Sales,
       SUM(Profit_After_Shipping_INR) AS Net_Profit
FROM SalesData
GROUP BY Customer_ID, Customer_Name
ORDER BY Sales DESC;
