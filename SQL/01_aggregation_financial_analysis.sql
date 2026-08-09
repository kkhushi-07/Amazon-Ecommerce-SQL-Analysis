-- ============================================================================
-- AMAZON E-COMMERCE SQL ANALYSIS
-- Category 1 : Aggregation & Financial Analysis
-- ============================================================================


-- ============================================================================
-- Question 1
-- Top 3 Sub-Categories by Average Profit Margin within each Category
-- ============================================================================

/*
Business Requirement:
Find the Top 3 Sub-Categories having the highest Average Profit Margin
within each Product Category.

Formula Used:

Profit Margin % =
((Selling Price - Cost Price) / Selling Price) × 100

Tables Used:
1. Products
2. OrderItems
*/

-- ============================================================================
-- STEP 1
-- Calculate Average Profit Margin for every SubCategory
-- ============================================================================

WITH ProfitData AS
(
    SELECT

        p.Category,

        p.SubCategory,

        AVG(
            ((oi.UnitPrice - p.Cost) / oi.UnitPrice) * 100
        ) AS AvgProfitMargin

    FROM Products p

    INNER JOIN OrderItems oi

        ON p.ProductID = oi.ProductID

    GROUP BY

        p.Category,

        p.SubCategory
),

-- ============================================================================
-- STEP 2
-- Rank every SubCategory inside each Category
-- ============================================================================

RankedData AS
(
    SELECT

        Category,

        SubCategory,

        AvgProfitMargin,

        DENSE_RANK() OVER
        (
            PARTITION BY Category
            ORDER BY AvgProfitMargin DESC
        ) AS Ranking

    FROM ProfitData
)

-- ============================================================================
-- STEP 3
-- Display only Top 3 Ranked SubCategories
-- ============================================================================

SELECT

    Category,

    SubCategory,

    ROUND(AvgProfitMargin,2) AS AvgProfitMargin,

    Ranking

FROM RankedData

WHERE Ranking <= 3

ORDER BY

Category, 

Ranking;


-- ============================================================================
-- QUESTION 2: DISCOUNT VS. LOSS IMPACT
-- ============================================================================

/*
Business Requirement:
--------------------
Calculate the average discount percentage applied to orders that resulted
in a net financial loss compared to orders that generated a profit.

Business Objective:
-------------------
Determine whether loss-making orders are associated with higher discounts
than profitable orders.

---------------------------------------------------------------------------
BUSINESS LOGIC
---------------------------------------------------------------------------

Net Profit = Revenue - Product Cost - Refund Amount

Where:

Revenue
    = SUM(LineTotal)

Product Cost
    = SUM(Product Cost × Quantity)

Refund Amount
    = Total refund amount associated with the order

Weighted Discount Percentage
    = Total Discount Value / Total Gross Order Value × 100

Weighted discount is used instead of a simple AVG(DiscountPct) because
orders may contain multiple products with different prices and quantities.

---------------------------------------------------------------------------
TABLES USED
---------------------------------------------------------------------------

1. OrderItems
   - OrderID
   - ProductID
   - Qty
   - UnitPrice
   - DiscountPct
   - LineTotal

2. Products
   - ProductID
   - Cost

3. Returns
   - OrderID
   - RefundAmount

---------------------------------------------------------------------------
IMPORTANT:
---------------------------------------------------------------------------

Returns are aggregated separately at the Order level before joining with
OrderItems.

This prevents refund amounts from being duplicated when an order contains
multiple order items.
*/


-- ============================================================================
-- STEP 1: AGGREGATE RETURNS AT ORDER LEVEL
-- ============================================================================
--
-- An order can have multiple return records.
-- Therefore, we first calculate the total refund for each OrderID.
--
-- This prevents duplicate refund amounts when Returns is later joined
-- with OrderItems.
-- ============================================================================

WITH OrderReturns AS
(
    SELECT
        OrderID,

        -- Calculate total refund amount for each order
        SUM(RefundAmount) AS TotalRefund

    FROM Returns

    GROUP BY
        OrderID
),


-- ============================================================================
-- STEP 2: CALCULATE ORDER-LEVEL FINANCIAL METRICS
-- ============================================================================
--
-- Here we combine OrderItems, Products and the aggregated Returns data.
--
-- We calculate:
-- 1. Total Revenue
-- 2. Total Product Cost
-- 3. Total Refund Amount
-- 4. Weighted Discount Percentage
-- ============================================================================

OrderFinancials AS
(
    SELECT

        oi.OrderID,

        -- ------------------------------------------------------------
        -- Total Revenue
        -- ------------------------------------------------------------
        -- LineTotal represents the revenue generated by each order item.
        -- SUM() gives us the total revenue for the complete order.
        -- ------------------------------------------------------------

        SUM(oi.LineTotal) AS Revenue,


        -- ------------------------------------------------------------
        -- Total Product Cost
        -- ------------------------------------------------------------
        -- Product cost × quantity gives the total cost of products
        -- included in the order.
        -- ------------------------------------------------------------

        SUM(p.Cost * oi.Qty) AS ProductCost,


        -- ------------------------------------------------------------
        -- Total Refund Amount
        -- ------------------------------------------------------------
        -- Orders without a return have NULL refund values after the
        -- LEFT JOIN, so COALESCE() converts NULL into 0.
        -- ------------------------------------------------------------

        COALESCE(r.TotalRefund, 0) AS RefundAmount,


        -- ------------------------------------------------------------
        -- Weighted Discount Percentage
        -- ------------------------------------------------------------
        --
        -- We use a weighted discount instead of:
        --
        -- AVG(DiscountPct)
        --
        -- because products can have different prices and quantities.
        --
        -- Formula:
        --
        -- Total Discount Value
        -- -------------------- × 100
        -- Total Gross Order Value
        --
        -- NULLIF() prevents division by zero.
        -- ------------------------------------------------------------

        (
            SUM(
                oi.UnitPrice
                * oi.Qty
                * (oi.DiscountPct / 100.0)
            )
            /
            NULLIF(
                SUM(oi.UnitPrice * oi.Qty),
                0
            )
        ) * 100 AS WeightedDiscountPct


    FROM OrderItems oi


    -- Connect each order item to its product information
    INNER JOIN Products p

        ON oi.ProductID = p.ProductID


    -- Bring the already aggregated refund amount for each order
    LEFT JOIN OrderReturns r

        ON oi.OrderID = r.OrderID


    -- Calculate all financial metrics at Order level
    GROUP BY
        oi.OrderID,
        r.TotalRefund
),


-- ============================================================================
-- STEP 3: CALCULATE NET PROFIT FOR EACH ORDER
-- ============================================================================
--
-- Net Profit Formula:
--
-- Net Profit
-- = Revenue
-- - Product Cost
-- - Refund Amount
--
-- After calculating Net Profit, the final step can classify each order
-- as either Profit or Loss.
-- ============================================================================

ProfitStatus AS
(
    SELECT

        OrderID,

        WeightedDiscountPct,

        -- Calculate the final net profit for the order
        (
            Revenue
            - ProductCost
            - RefundAmount
        ) AS NetProfit

    FROM OrderFinancials
)


-- ============================================================================
-- STEP 4: CLASSIFY ORDERS AND COMPARE DISCOUNTS
-- ============================================================================
--
-- Orders are divided into two groups:
--
-- Profit → Net Profit >= 0
-- Loss   → Net Profit < 0
--
-- Then we calculate:
-- 1. Average weighted discount percentage
-- 2. Number of orders in each group
-- ============================================================================

SELECT

    CASE

        WHEN NetProfit >= 0
            THEN 'Profit'

        ELSE 'Loss'

    END AS OrderStatus,


    -- Average discount percentage for each order group
    ROUND(
        AVG(WeightedDiscountPct),
        2
    ) AS AverageDiscountPercentage,


    -- Count the number of orders in each group
    COUNT(*) AS TotalOrders


FROM ProfitStatus


-- Group orders into Profit and Loss categories
GROUP BY

    CASE

        WHEN NetProfit >= 0
            THEN 'Profit'

        ELSE 'Loss'

    END


-- Display the group with the higher average discount first
ORDER BY
    AverageDiscountPercentage DESC;



-- ============================================================================
-- QUESTION 3: CROSS-CATEGORY HEAVY BUYERS
-- ============================================================================

/*
Business Requirement:
--------------------
Identify all customers who have placed at least one order in
every available product category.

Business Logic:
---------------
A customer qualifies if the number of distinct product categories
they have purchased from is equal to the total number of distinct
categories available in the Products table.

Tables Used:
------------
1. Customers
2. Orders
3. OrderItems
4. Products
*/


-- ============================================================================
-- STEP 1: CONNECT CUSTOMERS WITH THEIR PURCHASED PRODUCTS
-- ============================================================================
--
-- Customers
--     ↓ CustomerID
-- Orders
--     ↓ OrderID
-- OrderItems
--     ↓ ProductID
-- Products
--     ↓
-- Category
--
-- This allows us to determine which product categories
-- each customer has purchased from.
-- ============================================================================

SELECT

    c.CustomerID,

    c.FirstName,

    c.LastName,

    -- Count the number of unique product categories
    -- purchased by each customer.
    COUNT(DISTINCT p.Category) AS CategoriesPurchased


FROM Customers c


-- Connect customers with their orders
INNER JOIN Orders o

    ON c.CustomerID = o.CustomerID


-- Connect orders with the products included in those orders
INNER JOIN OrderItems oi

    ON o.OrderID = oi.OrderID


-- Connect order items with product information
INNER JOIN Products p

    ON oi.ProductID = p.ProductID


-- Create one group for each customer
GROUP BY

    c.CustomerID,

    c.FirstName,

    c.LastName


-- ============================================================================
-- STEP 2: KEEP ONLY CUSTOMERS WHO PURCHASED FROM EVERY CATEGORY
-- ============================================================================
--
-- The subquery below calculates the total number of unique categories
-- available in the Products table.
--
-- Example:
--
-- Total Categories = 5
--
-- Customer Categories Purchased = 5
--
-- Therefore, the customer qualifies.
-- ============================================================================

HAVING COUNT(DISTINCT p.Category)
       =
       (
           SELECT COUNT(DISTINCT Category)
           FROM Products
       )


-- Display customers in CustomerID order
ORDER BY

    c.CustomerID;