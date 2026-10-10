/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================


IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

create view  gold.dim_customers as
select 
	row_number() over(order by ci.cst_id) as customer_key, --surrogate key
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	case when ci.cst_gndr!='n/a' then ci.cst_gndr  --CRM is the MAster for gender information
	else  coalesce(ca.gen,'n/a')
	end as gender,
	ca.bdate as birthdate,
	ci.cst_marital_status as marital_status,	
	ci.cst_create_date as create_date,
	la.cntry as country
from silver.crm_cust_info ci 
left join silver.erp_cust_az12 ca 
on ci.cst_key=ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key=la.cid;
go

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

create view gold.dim_products as
select 
	ROW_NUMBER() over(order by pi.prd_start_dt,pi.prd_key) as product_key, --surrogate key
	pi.prd_id as product_id,
	pi.prd_key as product_number,
	pi.prd_nm as product_name,
	pi.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pi.prd_line as product_line,
	pc.maintenance,
	pi.prd_cost as cost,
	pi.prd_start_dt as start_date
from silver.crm_prod_info as pi
join silver.erp_px_cat_g1v2 as pc
on pi.cat_id=pc.id
where pi.prd_end_dt is null;
go

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

create view gold.fact_sales as
select  
	sls.sls_ord_num as order_number,
	prd.product_key,
	cst.customer_key,
	sls.sls_order_Dt as order_date,
	sls.sls_ship_dt as shipment_date,
	sls.sls_due_dt as due_date,
	sls.sls_sales as sales_amount,
	sls.sls_quantity as quantity,
	sls.sls_price as price
from silver.crm_sales_details as sls  left join 
gold.dim_products as prd   
on sls.sls_prd_key=prd.product_number left join 
gold.dim_customers as cst
on sls.sls_cust_id=cst.customer_id;
go


