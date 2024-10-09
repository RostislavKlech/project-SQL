-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	name_industry,
	payroll_year,
	name_product, 
	round(average_payroll/average_value_per_year) quantity 
FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
WHERE name_product IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový') AND payroll_year IN (2006, 2018)
ORDER BY name_industry, payroll_year;