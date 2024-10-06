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

-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	name_industry,
	payroll_year,
	name_product, 
	round(average_payroll/average_value_per_year) quantity 
FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
WHERE name_product IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový') AND payroll_year IN (2006, 2018)
ORDER BY name_industry, payroll_year; 

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
 
-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-- KORELACE

WITH average_payroll AS (
    SELECT
        payroll_year,
        avg(average_payroll) AS average_payroll_per_year
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
only_GDP AS (
    SELECT 
        payroll_year,
        GDP*23 AS GDP_CZ
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
averages AS (
    SELECT
        avg(ap.average_payroll_per_year) AS average_payroll,
        avg(og.GDP_CZ) AS average_GDP
    FROM average_payroll ap
    JOIN only_GDP og
        ON ap.payroll_year = og.payroll_year
)
SELECT
    sum((ap.average_payroll_per_year - a.average_payroll) * (og.GDP_CZ - a.average_GDP)) /
    sqrt(sum(pow(ap.average_payroll_per_year - a.average_payroll, 2)) * sum(pow(og.GDP_CZ - a.average_GDP, 2))) AS pearson_coefficient
FROM average_payroll ap
JOIN only_GDP og
    ON ap.payroll_year = og.payroll_year
CROSS JOIN averages a;

WITH average_product_value AS (
    SELECT 
        payroll_year,
        avg(average_value_per_year) AS average_value_per_year
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
only_GDP AS (
    SELECT 
        payroll_year,
        GDP*23 AS GDP_CZ
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
averages AS (
    SELECT
        avg(apv.average_value_per_year) AS average_value,
        avg(og.GDP_CZ) AS average_GDP
    FROM average_product_value apv
    JOIN only_GDP og
        ON apv.payroll_year = og.payroll_year
)
SELECT
    sum((apv.average_value_per_year - a.average_value) * (og.GDP_CZ - a.average_GDP))/
    sqrt(sum(pow(apv.average_value_per_year - a.average_value, 2))*sum(pow(og.GDP_CZ - a.average_GDP, 2))) AS pearson_coefficient
FROM average_product_value apv
JOIN only_GDP og
    ON apv.payroll_year = og.payroll_year
CROSS JOIN averages a;

-- REGRESE

WITH average_payroll AS (
    SELECT
        payroll_year,
        avg(average_payroll) AS average_payroll_per_year
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
only_GDP AS (
    SELECT 
        payroll_year,
        GDP*23 AS GDP_CZ
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
averages AS (
    SELECT
        avg(ap.average_payroll_per_year) AS average_payroll,
        avg(og.GDP_CZ) AS average_GDP
    FROM average_payroll ap
    JOIN only_GDP og
        ON ap.payroll_year = og.payroll_year
)
SELECT 
	sum((ap.average_payroll_per_year - a.average_payroll) * (og.GDP_CZ - a.average_GDP))/sum(pow(og.GDP_CZ - a.average_GDP, 2)) AS slope
FROM average_payroll ap
JOIN only_GDP og	
	ON ap.payroll_year = og.payroll_year
CROSS JOIN averages a;

WITH average_product_value AS (
    SELECT 
        payroll_year,
        avg(average_value_per_year) AS average_value_per_year
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
only_GDP AS (
    SELECT 
        payroll_year,
        GDP*23 AS GDP_CZ
    FROM t_rostislav_klech_project_sql_primary_final2 trkpspf
    GROUP BY payroll_year
),
averages AS (
    SELECT
        avg(apv.average_value_per_year) AS average_value,
        avg(og.GDP_CZ) AS average_GDP
    FROM average_product_value apv
    JOIN only_GDP og
        ON apv.payroll_year = og.payroll_year
)
SELECT 
	sum((apv.average_value_per_year - a.average_value) * (og.GDP_CZ - a.average_GDP))/sum(pow(og.GDP_CZ - a.average_GDP, 2)) AS slope
FROM average_product_value apv
JOIN only_GDP og	
	ON apv.payroll_year = og.payroll_year
CROSS JOIN averages a;









































