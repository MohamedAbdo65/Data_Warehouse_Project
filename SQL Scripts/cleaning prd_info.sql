DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
		prd_id INTEGER , 
		cat_id VARCHAR(50),
		prd_key VARCHAR(50),
		prd_nm  VARCHAR(50),
		prd_cost INTEGER ,
		prd_line VARCHAR(50) ,
		prd_start_dt DATE ,
		prd_end_dt DATE,
		dwh_create_date DATE DEFAULT CURRENT_DATE
);
INSERT INTO silver.crm_prd_info(
		prd_id, 
		cat_id ,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line ,
		prd_start_dt,
		prd_end_dt )
SELECT 
prd_id ,
REPLACE(SUBSTRING(prd_key , 1 , 5) ,'-' , '_') AS cat_id , --extract columns
SUBSTRING(prd_key , 7 , length(prd_key)) AS prd_key,
prd_nm ,
COALESCE(prd_cost , 0) AS prd_cost, --replace null values with 0
CASE UPPER(TRIM(prd_line))
 	 WHEN 'R' THEN 'Road'
	 WHEN 'M' THEN 'Mountain'
	 WHEN 'S' THEN 'Other Sales'
	 WHEN 'T' THEN 'Touring'
	 ELSE 'N/A'
END AS prd_line , -- data normalization
prd_start_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt --data enrichment add new relvant data
FROM bronze.crm_prd_info

SELECT * FROM silver.crm_prd_info        
