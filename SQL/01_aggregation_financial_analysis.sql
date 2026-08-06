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