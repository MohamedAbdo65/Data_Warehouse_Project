/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY FROM` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze;
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE 'plpgsql'   
AS $BODY$
DECLARE
		start_time TIMESTAMP;
		end_time TIMESTAMP;
		batch_start_time TIMESTAMP;
		batch_end_time TIMESTAMP;
BEGIN
	batch_start_time := clock_timestamp();
	
	RAISE NOTICE '===========================================';
	RAISE NOTICE 'Loading Bronze Layer';
	RAISE NOTICE '============================================';

	RAISE NOTICE '------------------------------------------------';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '------------------------------------------------';
	
	--Loading bronze.crm_cust_info
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table : bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;
	RAISE NOTICE 'Inserting data into Table : bronze.crm_cust_info';
	COPY bronze.crm_cust_info
    FROM 'C:/data/source_crm/cust_info.csv'
    WITH (FORMAT csv, HEADER true);
    RAISE NOTICE 'Loaded % rows', (SELECT COUNT(*) FROM bronze.crm_cust_info);
	end_time := clock_timestamp();
	RAISE NOTICE 'Load duration : % seconds' , EXTRACT(EPOCH FROM (end_time - start_time)) ::NUMERIC ;
    RAISE NOTICE '---------------------------------------------------------------' ;
	
	--Loading bronze.bronze.crm_prd_info
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table : bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;
	RAISE NOTICE 'Inserting data into Table : bronze.crm_prd_info';
	COPY bronze.crm_prd_info
    FROM 'C:/data/source_crm/prd_info.csv'
    WITH (FORMAT csv, HEADER true);
    RAISE NOTICE 'Loaded % rows', (SELECT COUNT(*) FROM bronze.crm_prd_info);
	end_time := clock_timestamp();
	RAISE NOTICE 'Load duration : % seconds' , EXTRACT(EPOCH FROM (end_time - start_time)) ::NUMERIC ;
    RAISE NOTICE '---------------------------------------------------------------' ;

	--Loading bronze.crm_sales_details
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table : bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;
	RAISE NOTICE 'Inserting data into Table : bronze.crm_sales_details';
	COPY bronze.crm_sales_details
    FROM 'C:/data/source_crm/sales_details.csv'
    WITH (FORMAT csv, HEADER true);
    RAISE NOTICE 'Loaded % rows', (SELECT COUNT(*) FROM bronze.crm_sales_details);
	end_time := clock_timestamp();
	RAISE NOTICE 'Load duration : % seconds' , EXTRACT(EPOCH FROM (end_time - start_time)) ::NUMERIC ;
    RAISE NOTICE '---------------------------------------------------------------' ;

	RAISE NOTICE '-------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '-------------------------------------------';

	--Loading bronze.erp_loc_a101
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table : bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;
	RAISE NOTICE 'Inserting data into Table : bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101
    FROM 'C:/data/source_erp/LOC_A101.csv'
    WITH (FORMAT csv, HEADER true);
    RAISE NOTICE 'Loaded % rows', (SELECT COUNT(*) FROM bronze.erp_loc_a101);
	end_time := clock_timestamp();
	RAISE NOTICE 'Load duration : % seconds' , EXTRACT(EPOCH FROM (end_time - start_time)) ::NUMERIC ;
    RAISE NOTICE '---------------------------------------------------------------' ;

	--Loading bronze.erp_cust_az12
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table : bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;
	RAISE NOTICE 'Inserting data into Table : bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12
    FROM 'C:/data/source_erp/CUST_AZ12.csv'
    WITH (FORMAT csv, HEADER true);
    RAISE NOTICE 'Loaded % rows', (SELECT COUNT(*) FROM bronze.erp_cust_az12);
	end_time := clock_timestamp();
	RAISE NOTICE 'Load duration : % seconds' , EXTRACT(EPOCH FROM (end_time - start_time)) ::NUMERIC ;
    RAISE NOTICE '---------------------------------------------------------------' ;

	--Loading bronze.erp_px_cat_g1v2
	start_time := clock_timestamp();
	RAISE NOTICE 'Truncating Table : bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	RAISE NOTICE 'Inserting data into Table : bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2
    FROM 'C:/data/source_erp/PX_CAT_G1V2.csv'
    WITH (FORMAT csv, HEADER true);
    RAISE NOTICE 'Loaded % rows', (SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2);
	end_time := clock_timestamp();
	RAISE NOTICE 'Load duration : % seconds' , EXTRACT(EPOCH FROM (end_time - start_time)) ::NUMERIC ;
    RAISE NOTICE '---------------------------------------------------------------' ;
	 ----------------------------------------------------------------
    batch_end_time := clock_timestamp();
    RAISE NOTICE '===========================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE 'Total Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::NUMERIC, 2);
    RAISE NOTICE '===========================================';

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE '===========================================';
	        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BROZE LAYER';
	        RAISE NOTICE 'Error Message: %', SQLERRM;
	        RAISE NOTICE 'Error Code: %', SQLSTATE;
	        RAISE NOTICE '===========================================';
	        RAISE;  -- re-throw so the failure isn't silent
	END;
	$BODY$;
	
CALL bronze.load_bronze();
