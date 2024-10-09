-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-- KORELACE

WITH average_payroll AS (
    SELECT
        payroll_year,
        avg(average_payroll) AS average_payroll_per_year
    FROM t_rostislav_klech_project_sql_primary_final2
    GROUP BY payroll_year
),
only_GDP AS (
    SELECT 
    	payroll_year,
        GDP * 23 AS GDP_CZ
    FROM t_rostislav_klech_project_sql_primary_final2
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
    sum((ap.average_payroll_per_year - a.average_payroll)*(og.GDP_CZ - a.average_GDP))/
    sqrt(sum(pow(ap.average_payroll_per_year - a.average_payroll, 2))*sum(pow(og.GDP_CZ - a.average_GDP, 2))) AS pearson_coefficient
FROM average_payroll ap
JOIN only_GDP og
    ON ap.payroll_year = og.payroll_year
JOIN averages a;

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
JOIN averages a;

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
JOIN averages a;

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
JOIN averages a;