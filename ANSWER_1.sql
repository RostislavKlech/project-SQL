-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT 
	name_industry,
	average_payroll,
	payroll_year
FROM (
	SELECT
		name_industry,
		average_payroll,
		payroll_year,
		LAG(average_payroll) OVER (PARTITION BY name_industry ORDER BY payroll_year) AS previous_year
	FROM t_rostislav_klech_project_sql_primary_final2 trkpspf		
) AS sub
WHERE average_payroll < previous_year;