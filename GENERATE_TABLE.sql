CREATE OR REPLACE TABLE t_rostislav_klech_project_SQL_primary_final AS
	SELECT
		AVG(cp.value) AS average_payroll,
		cp.industry_branch_code,
		cpib.name,
		cp.payroll_year,
		tppy.category_code,
		tppy.name,
		tppy.average_value_per_year
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib 
		ON cp.industry_branch_code = cpib.code
	JOIN t_prices_per_year tppy
		ON cp.YEAR(date_from) = tppy.year 
	WHERE industry_branch_code IS NOT NULL AND value_type_code = 5958 AND (payroll_year >= 2006 AND payroll_year <= 2018)
	GROUP BY cp.payroll_year, cp.industry_branch_code;
	
CREATE OR REPLACE TABLE t_prices_per_year AS
	SELECT
		AVG(cp.value) average_value_per_year,
		cp.category_code,
		cpc.name,
		YEAR(cp.date_from) AS year,
		cpc.price_value,
		cpc.price_unit
	FROM czechia_price cp
	JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	GROUP BY category_code, YEAR(date_from)
	
CREATE OR REPLACE TABLE t_rostislav_klech_czehia_gdp AS
	SELECT
		`year`,
		GDP
	FROM economies e 
	WHERE country = 'czech republic' AND `year` BETWEEN 2006 AND 2018
	ORDER BY `year`;

CREATE OR REPLACE TABLE t_rostislav_klech_project_sql_primary_final2 AS
	SELECT 	
		trkpspf.payroll_year,
		trkpspf.industry_branch_code,
		trkpspf.name name_industry,
		trkpspf.average_payroll, 
		tppy.category_code,
		tppy.name name_product,
		tppy.average_value_per_year,
		tppy.price_value,
		tppy.price_unit,
		cg.GDP 
	FROM t_rostislav_klech_project_sql_primary_final trkpspf 
	JOIN t_prices_per_year tppy 
		ON trkpspf.payroll_year = tppy.`year`
	JOIN t_rostislav_klech_czehia_gdp cg 
		ON trkpspf.payroll_year = cg.`year`;

DROP TABLE t_rostislav_klech_project_SQL_primary_final, t_prices_per_year, t_rostislav_klech_czehia_gdp

CREATE OR REPLACE TABLE t_rostislav_klech_sql_secondary_final AS
	SELECT	
		c.country,
		c.capital_city,
		e.`year`,
		e.population,
		e.GDP,
		e.gini 
	FROM countries c
	JOIN economies e 
		ON c.country = e.country
	WHERE e.`year` BETWEEN 2006 AND 2018
	GROUP BY c.country, e.`year`;

 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	







