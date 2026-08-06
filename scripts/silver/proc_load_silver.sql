exec silver.load_silver;

create or alter procedure silver.load_silver As
	begin
	    declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
		begin try
			set @batch_start_time = GETDATE();
			print '===========================================';
			print 'Loading silver Layer';
			print '===========================================';

			print '===========================================';
			print 'Loading CRM Tables';
			print '===========================================';

			--loading silver.crm_cust_info
			set @start_time= GETDATE();
			print '>>truncating table:silver.crm_cust_info '
			truncate table silver.crm_cust_info;
			print '>>insrting data into: silver.crm_cust_info';

			insert into silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
			)
			select 
			cst_id,
			cst_key,
			trim(cst_firstname) as cst_firstname,
			trim(cst_lastname) as cst_lastname,
			case when upper(trim(cst_marital_status))='S' then 'single'
				 when upper(trim(cst_marital_status))='M' then 'Married'
				 else 'n/a'
			end cst_marital_status,
			case when upper(trim(cst_gndr))='M' then 'Male'
				 when upper(trim(cst_gndr))='F' then 'Female'
				 else 'n/a'
			end cst_gndr,
			cst_create_date
			from (
				select 
				*,
				row_number() over(partition by cst_id order by cst_create_date desc) flag
				from bronze.crm_cust_info 
				where cst_id is not null)t where flag=1;

			set @end_time=GETDATE();
			print '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) As varchar) + 'seconds';
			print '>>-------------------';

			------------------------------------------------------------------------------------------
			--loading silver.crm_prod_info
			set @start_time= GETDATE();
			print '>>truncating table:silver.crm_prod_info '
			truncate table silver.crm_prod_info;
			print '>>insrting data into: silver.crm_prod_info';
			insert into silver.crm_prod_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
			)
			select
			prd_id,
			Replace(substring(prd_key,1,5),'-','_') as cat_id,
			substring(prd_key,7,len(prd_key)) as prd_key,
			prd_nm,
			isnull(prd_cost,0) as prd_cost,
			case 
				 when upper(trim(prd_line)) ='M' then 'Mountain'
				 when upper(trim(prd_line)) ='R' then 'Road'
				 when upper(trim(prd_line)) ='S' then 'Other Sales'
				 when upper(trim(prd_line)) ='T' then 'Touring'
				 else 'n/a'
			end as prd_line,
			cast(prd_start_dt as date) as prd_start_dt,
			cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 as date) as prd_end_dt
			from bronze.crm_prod_info

			set @end_time=GETDATE();
			print '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) As varchar) + 'seconds';
			print '>>-------------------';


			------------------------------------------------------------------------------------------
			--loading silver.crm_sales_details
			set @start_time= GETDATE();
			print '>>truncating table:silver.crm_sales_details '
			truncate table silver.crm_sales_details;
			print '>>insrting data into: silver.crm_sales_details';

			insert into silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price 

			)
			select
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case when sls_order_dt=0 or len(sls_order_dt)!=8 then null
				 else cast(cast(sls_order_dt as varchar) as date)
			 end sls_order_dt,
			case when sls_ship_dt=0 or len(sls_ship_dt)!=8 then null
				 else cast(cast(sls_ship_dt as varchar) as date)
			 end sls_ship_dt,
			case when sls_due_dt=0 or len(sls_due_dt)!=8 then null
				 else cast(cast(sls_due_dt as varchar) as date)
			end sls_due_dt,
			case when sls_sales<=0 or sls_sales is null or sls_sales!=sls_quantity*sls_price 
				  then sls_quantity*Abs(sls_price)
				  else sls_sales
			end sls_sales,
			sls_quantity,
			case when sls_price<=0 or sls_price is null 
				  then sls_sales/abs(nullif(sls_quantity,0))
				  else sls_price
			end sls_price
			from bronze.crm_sales_details;

			set @end_time=GETDATE();
			print '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) As varchar) + 'seconds';
			print '>>-------------------';

			------------------------------------------------------------------------------------------
			print '===========================================';
			print 'Loading ERP Tables';
			print '===========================================';

			--loading silver.erp_cust_az12
			set @start_time= GETDATE();
			print '>>truncating table:silver.erp_cust_az12 '
			truncate table silver.erp_cust_az12;
			print '>>insrting data into: silver.erp_cust_az12';

			insert into silver.erp_cust_az12(cid,bdate,gen)
			select
			case when cid like 'NAS%' then substring(cid,4,len(cid)) ---removing NAs prefix if present
				 else cid
			end cid,
			case when bdate>getdate() then null --set future birthdates to null
				 else bdate
			end bdate,
			case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female' --normalise gender values and handle unknown cases
				 when upper(trim(gen)) in ('M', 'MALE') then 'Male' 
				 else 'n/a'
			end gen
			from bronze.erp_cust_az12;

			set @end_time=GETDATE();
			print '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) As varchar) + 'seconds';
			print '>>-------------------';

			------------------------------------------------------------------------------------------
			--loading silver.erp_loc_a101
			set @start_time= GETDATE();
			print '>>truncating table:silver.erp_loc_a101 '
			truncate table silver.erp_loc_a101;
			print '>>insrting data into: silver.erp_loc_a101';

			insert into silver.erp_loc_a101(cid,cntry)
			select 
			Replace(cid,'-','') cid,
			case when trim(cntry)='DE' then 'Germany'
				 when trim(cntry)='US' or trim(cntry)='USA' then 'United Sates'
				 when trim(cntry)='' or trim(cntry) is null then 'n/a'
				 else trim(cntry)
			end cntry
			from bronze.erp_loc_a101;

			set @end_time=GETDATE();
			print '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) As varchar) + 'seconds';
			print '>>-------------------';
			------------------------------------------------------------------------------------------
			--loading silver.erp_px_cat_g1v2
			set @start_time= GETDATE();
			print '>>truncating table:silver.erp_px_cat_g1v2 '
			truncate table silver.erp_px_cat_g1v2;
			print '>>insrting data into: silver.erp_px_cat_g1v2';

			insert into silver.erp_px_cat_g1v2(id,
			cat,
			subcat,
			maintenance)
			select 
			id,
			cat,
			subcat,
			maintenance
			from bronze.erp_px_cat_g1v2;

			set @end_time=GETDATE();
			print '>> Load Duration : ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) As varchar) + 'seconds';
			print '>>-------------------';

			set @batch_end_time=GETDATE();
			print '>> Batch Load duration ' +cast(datediff(second,@batch_start_time,@batch_end_time) as varchar) + 'seconds';
			print '>>-------------------';

		end try
		begin catch
			print '===========================================';
			print 'error occured during loading silver layer';
			print 'error message' + error_message();
			print 'error state' + cast(error_state() as nvarchar);
			print 'error number' + cast(error_number() as nvarchar);
			print '==========================================='
		end catch

	end
