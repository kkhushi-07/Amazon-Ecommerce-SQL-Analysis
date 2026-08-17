-- =========================================
-- AMAZON E-COMMERCE BUSINESS ANALYSIS
-- =========================================

-- 1. Total Revenue
-- 2. Total Orders
-- 3. Top 10 Products by Revenue
-- 4. Category-wise Revenue
-- 5. Top Customers by Spending
-- 6. Delivery Status Analysis
-- 7. Cancelled Orders
-- 8. Return Rate
-- 9. Payment Method Performance
-- 10. Channel-wise Sales
-- 11. Monthly Revenue Trend
-- 12. Best-performing Category
-- 13. Average Order Value (AOV)
-- 14. Most Returned Products
-- 15. State/City-wise Customer Analysis


-- 1. Calculate the total revenue generated from all orders

SELECT 
    SUM(LineTotal) AS Total_Revenue
FROM OrderItems;

-- Q2. Total number of orders
SELECT 
    COUNT(*) AS total_orders
FROM orders;

-- Q3. Find the top 10 products by total revenue
-- We join Products with OrderItems using ProductID
-- and calculate revenue by summing LineTotal for each product.

SELECT
    p.ProductID,
    p.ProductName,
    SUM(oi.LineTotal) AS Total_Revenue
FROM Products p

INNER JOIN OrderItems oi
    ON p.ProductID = oi.ProductID

GROUP BY
    p.ProductID,
    p.ProductName

ORDER BY
    Total_Revenue DESC

LIMIT 10;