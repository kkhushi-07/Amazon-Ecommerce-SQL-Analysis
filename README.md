# 🛒 Amazon E-Commerce SQL & Power BI Analysis

A complete SQL and Power BI analytics project built to analyze e-commerce sales, customers, products, orders, payments, returns, shipments, and business performance.

---

## 📌 Project Overview

This project analyzes a relational Amazon-style e-commerce dataset using **SQL, MySQL, Microsoft Excel, and Power BI**.

The goal is to transform raw transactional data into meaningful business insights by performing SQL-based analysis and creating an interactive Power BI dashboard.

The project covers:

- Sales and revenue analysis
- Order analysis
- Product performance
- Category performance
- Customer spending behavior
- Payment method analysis
- Sales channel analysis
- Delivery and shipment analysis
- Cancellation analysis
- Return analysis
- Monthly revenue trends
- Customer geographical analysis
- Business performance insights

---

## 🎯 Project Objectives

- Practice SQL using real-world e-commerce business scenarios.
- Analyze relational data using multiple tables.
- Understand relationships between customers, orders, products, payments, shipments, and returns.
- Calculate important business metrics such as revenue, orders, Average Order Value (AOV), and return rate.
- Identify top-performing products and categories.
- Identify high-value customers.
- Analyze payment methods and sales channels.
- Analyze delivery and return performance.
- Create an interactive Power BI dashboard.
- Generate actionable business insights from data.
- Build a portfolio-ready Data Analyst project.

---

## 🛠️ Tools & Technologies

- **SQL**
- **MySQL Workbench**
- **Microsoft Power BI Desktop**
- **Microsoft Excel**
- **CSV**
- **Git & GitHub**
- **Visual Studio Code**

---

## 🗂️ Dataset

The dataset contains **7 relational tables** representing different entities in the e-commerce system.

| Table | Description |
|---|---|
| `Customers` | Contains customer information, location, joining date, and Prime membership status |
| `Products` | Contains product details, categories, brands, prices, costs, and stock |
| `Orders` | Contains order information, order status, dates, and sales channels |
| `OrderItems` | Contains products purchased in each order, quantity, discounts, tax, and line-level revenue |
| `Payments` | Contains payment methods, payment amounts, and payment status |
| `Shipments` | Contains carrier, shipping, delivery dates, and delivery status |
| `Returns` | Contains returned products, return reasons, and refund amounts |

### Dataset Size

- 👥 **Customers:** 1,000
- 🛍️ **Products:** 500
- 📦 **Orders:** 5,000
- 🧾 **Order Items:** 17,481
- 💳 **Payments:** 5,000
- 🚚 **Shipments:** 5,000
- 🔄 **Returns:** 988

---

## 🗄️ Database Schema

The project uses a relational data model connecting customers, orders, products, payments, shipments, and returns.

### Entity Relationship Diagram

![ER Diagram](docs/ER_Diagram.png)

### Main Relationships

```text
Customers
    │
    │ CustomerID
    ▼
Orders
    │
    ├──────────────► OrderItems ──────────────► Products
    │
    ├──────────────► Payments
    │
    ├──────────────► Shipments
    │
    └──────────────► Returns

    🧮 SQL Analysis

The project contains 15 business-focused SQL questions designed to simulate real-world Data Analyst business requirements.

Business Questions Covered
💰 Total Revenue
📦 Total Orders
🛍️ Top 10 Products by Revenue
📊 Category-wise Revenue
👥 Top Customers by Spending
🚚 Delivery Status Analysis
❌ Cancelled Orders
🔄 Return Rate
💳 Payment Method Performance
📱 Channel-wise Sales
📅 Monthly Revenue Trend
🏆 Best-performing Category
💸 Average Order Value (AOV)
🔁 Most Returned Products
📍 State/City-wise Customer Analysis

---

SQL Concepts Covered
SELECT
WHERE
ORDER BY
GROUP BY
Aggregate Functions
INNER JOIN
LEFT JOIN
CASE Statements
Subqueries
CTEs
DISTINCT
Date Functions
Window Functions
Ranking Functions
Business Metrics
Data Aggregation
Key Analysis Areas
Total revenue and order volume
Product and category performance
Customer spending behavior
Delivery status analysis
Cancelled order analysis
Return rate calculation
Payment method performance
Sales channel performance
Monthly revenue trends
Average Order Value
Most returned products
Customer geographical distribution

---
**SQL queries are available in:

SQL/business_analysis.sql

Additional advanced SQL analysis files are also available in the SQL/ directory.

📊 Power BI Dashboard

An interactive Power BI dashboard was created to provide a high-level overview of the e-commerce business.

Dashboard KPIs
📦 Total Orders
👥 Total Customers
💰 Total Revenue
🛍️ Total Products

Dashboard Includes
📱 Sales by Channel
📊 Revenue by Category
📦 Order Status Distribution
🏆 Top Products by Revenue
🔎 Channel-based Interactive Slicer
📈 Business KPI Overview

The dashboard provides an interactive way to explore sales performance and product-level business metrics.

The Power BI dashboard file is available in:

Dashboard/Amazon_Ecommerce_Analysis.pbix

📈 Key Business Metrics

The project calculates several important e-commerce business metrics:

💰 Total Revenue

Total revenue generated from all order items using the LineTotal field.

📦 Total Orders

Total number of orders placed in the dataset.

💸 Average Order Value

Average revenue generated per order.

Formula:

AOV = Total Revenue / Total Orders


🔄 Return Rate

Percentage of unique orders that contained at least one returned item.

Formula:

Return Rate = Returned Orders / Total Orders × 100

🏆 Product Performance

Products are ranked based on their total generated revenue.

📊 Category Performance

Revenue is aggregated by product category to identify the highest-performing categories.

🔍 Key Business Insights

The SQL analysis and Power BI dashboard can be used to identify:

💰 Overall revenue and order performance
🏆 Top revenue-generating products
📊 Highest-performing product categories
👥 Highest-spending customers
📱 Best-performing sales channels
💳 Payment method usage and payment value
🚚 Distribution of delivery statuses
❌ Number of cancelled orders
🔄 Overall return rate
📅 Monthly revenue trends
🔁 Products with the highest number of returns
📍 Customer concentration by state and city

These insights can help businesses understand sales performance, customer behavior, product demand, operational performance, and potential areas for improvement.

📁 Project Structure
Amazon-Ecommerce-SQL-Analysis/
│
├── assets/
│
├── Dashboard/
│   ├── README.md
│   └── Amazon_Ecommerce_Analysis.pbix
│
├── Dataset/
│   ├── Amazon_Advanced_Dataset_5000_Orders.xlsx
│   ├── Customers.csv
│   ├── OrderItems.csv
│   ├── Orders.csv
│   ├── Payments.csv
│   ├── Products.csv
│   ├── Returns.csv
│   └── Shipments.csv
│
├── docs/
│   ├── ER_Diagram.png
│   └── README.md
│
├── SQL/
│   ├── 00_business_analysis.sql
│   ├── 01_aggregation_financial_analysis.sql
│   ├── 02_window_functions_ranking.sql
│   ├── 03_customer_rfm_cohort_analysis.sql
│   ├── 04_complex_joins_market_basket.sql
│   ├── 05_time_series_operational_logistics.sql
│   ├── 06_advanced_ecommerce_operations.sql
│   └── README.md
│
├── .gitignore
└── README.md

---
🚀 Future Improvements

The project can be further extended with:

Advanced customer RFM segmentation
Customer Lifetime Value (CLV) analysis
Customer churn analysis
Profitability and margin analysis
Cohort and retention analysis
Advanced Power BI DAX measures
Additional Power BI dashboard pages
Automated data refresh
Sales forecasting
Product recommendation analysis
Advanced customer segmentation


----
👩‍💻 Author

Khushi

Data Analyst Portfolio Project

---

⭐ This project demonstrates practical skills in **SQL, data analysis, relational databases, business intelligence, and Power BI dashboard development**.
