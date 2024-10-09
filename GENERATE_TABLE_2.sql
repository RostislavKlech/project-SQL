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