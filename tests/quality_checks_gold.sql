/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/


-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 

SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
--Foreign key integrity(checking If every customer_key in fact_sales exists in dim_customers AND every product_key exists in dim_products)
--expectation  0 rows

-- Check for orphaned customer keys
SELECT s.*
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c 
    ON s.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- Check for orphaned product keys
SELECT s.*
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p 
    ON s.product_key = p.product_key
WHERE p.product_key IS NULL;