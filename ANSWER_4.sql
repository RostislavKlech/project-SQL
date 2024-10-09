-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH average_payroll AS (
	SELECT
		payroll_year,
		avg(average_payroll) AS average_payroll_per_year
		FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
	GROUP BY payroll_year
),
average_product_value AS (
	SELECT 
		payroll_year,
		avg(average_value_per_year) AS average_value_per_year
	FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
	GROUP BY payroll_year
),
percentage_changes AS (
	SELECT
		ap.payroll_year, 
		(ap.average_payroll_per_year - LAG(ap.average_payroll_per_year) OVER (ORDER BY ap.payroll_year))/LAG(ap.average_payroll_per_year) OVER (ORDER BY ap.payroll_year)*100 AS average_percentage_growth_of_payroll,
		(apv.average_value_per_year  - LAG(apv.average_value_per_year ) OVER (ORDER BY apv.payroll_year))/LAG(apv.average_value_per_year ) OVER (ORDER BY apv.payroll_year)*100 AS average_percentage_growth_of_products
	FROM average_payroll ap
	JOIN average_product_value apv
		ON ap.payroll_year = apv.payroll_year
)
SELECT 
	payroll_year,
	average_percentage_growth_of_payroll - average_percentage_growth_of_products AS difference
FROM percentage_changes
WHERE average_percentage_growth_of_payroll - average_percentage_growth_of_products > 10;
 