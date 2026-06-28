/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
create or alter procedure bronze.load_bronze as
Begin
	declare @start_time datetime, @end_time datetime,@btach_start_time datetime, @btach_end_time datetime;

	begin try
			set @btach_start_time=getdate();
			print '=================********=======================================';
			print 'loading bronze layer';
			print '========================================================';

		
			print '********************************************************';
			print 'loading crm tables';
			print '********************************************************';


			set @start_time=getdate();
			print 'Truncating Table bronze.crm_cust_info';
			TRUNCATE TABLE bronze.crm_cust_info;
			print 'Inserting Table bronze.crm_cust_info';
			BULK INSERT bronze.crm_cust_info
			FROM 'C:\Users\hp\Downloads\SQL_PROJECT_FILES\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			set @end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'load duration ' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'


			set @start_time=getdate();
			print 'Truncating Table bronze.crm_prod_info';
			TRUNCATE TABLE bronze.crm_prod_info;
			print 'Inserting Table bronze.crm_prod_info';
			BULK INSERT bronze.crm_prod_info
			FROM 'C:\Users\hp\Downloads\SQL_PROJECT_FILES\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);

			set @end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'load duration ' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

			set @start_time=getdate();
			print 'Truncating Table bronze.crm_sales_details';
			TRUNCATE TABLE bronze.crm_sales_details;
			print 'Inserting Table bronze.crm_sales_details';
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\hp\Downloads\SQL_PROJECT_FILES\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);

			set @end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'load duration ' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

			print '********************************************************';
			print 'loading erp tables';
			print '********************************************************';
			print 'Truncating Table bronze.erp_loc_a101';
			set @start_time=getdate();
			TRUNCATE TABLE bronze.erp_loc_a101;
			print 'Inserting Table bronze.erp_loc_a101';
			BULK INSERT bronze.erp_loc_a101
			FROM 'C:\Users\hp\Downloads\SQL_PROJECT_FILES\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);

			set @end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'load duration ' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'


		
			print 'Truncating Table bronze.erp_cust_az12';
			set @start_time=getdate();
			TRUNCATE TABLE bronze.erp_cust_az12;
			print 'Inserting Table bronze.erp_cust_az12';
			BULK INSERT bronze.erp_cust_az12
			FROM 'C:\Users\hp\Downloads\SQL_PROJECT_FILES\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);

			set @end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'load duration ' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

			print 'Truncating Table bronze.erp_px_cat_g1v2';
			set @start_time=getdate();
			TRUNCATE TABLE bronze.erp_px_cat_g1v2;
			print 'Inserting Table bronze.erp_px_cat_g1v2';
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'C:\Users\hp\Downloads\SQL_PROJECT_FILES\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);

			set @end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'load duration ' + CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

			set @btach_end_time=getdate();
			print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
			print 'loading bronze layer is completed'
			print 'bronze layer total load duration ' + CAST(datediff(second, @btach_start_time,@btach_end_time) AS NVARCHAR)+' seconds' ;
		    print'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

	end try

	Begin catch
	print'===================================='
	print'error occured during load operation'
	print'error message ' + Cast(error_message() as nvarchar);
    print'error number ' + Cast(error_number() as nvarchar);
    print'error state ' + Cast(error_state() as nvarchar);
	print'===================================='



	end catch
end
