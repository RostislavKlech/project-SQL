-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

SELECT 
	name_product,
	avg(change_percentage) AS average_value_increase
FROM (
	SELECT
		payroll_year,
		name_product,
		category_code,
		average_value_per_year,
		CASE 
			WHEN LAG(average_value_per_year) OVER (PARTITION BY name_product ORDER BY payroll_year) IS NOT NULL 
			THEN round((average_value_per_year - LAG(average_value_per_year) OVER (PARTITION BY name_product ORDER BY payroll_year))/LAG(average_value_per_year) OVER (PARTITION BY name_product ORDER BY payroll_year)*100)
			ELSE NULL
		END AS change_percentage
	FROM t_rostislav_klech_project_sql_primary_final2 trkpspf 
) AS sub
GROUP BY name_product
ORDER BY average_value_increase;