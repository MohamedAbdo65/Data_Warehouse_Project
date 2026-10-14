INSERT INTO silver.erp_cust_az12(cid , bdate , gen)
SELECT 
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid , 4 , LENGTH(cid))
			 ELSE cid 
		END AS cid	, 
		CASE WHEN bdate > CURRENT_DATE THEN NULL
		ELSE bdate
		END AS bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('M' , 'Male') THEN 'Male'
			 WHEN UPPER(TRIM(gen)) IN ('F' , 'Female') THEN 'Female'
			 ELSE 'N/A'
		 END AS gen
FROM bronze.erp_cust_az12;


SELECT * 
FROM bronze.erp_cust_az12 
WHERE bdate > CURRENT_DATE OR bdate < '1920-01-01' --CHECK FOR INVALID DATES


SELECT DISTINCT gen
FROM bronze.erp_cust_az12  --check for gender invalid values and standrized all values

SELECT * FROM silver.erp_cust_az12