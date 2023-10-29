SELECT *
FROM t_katerina_kocianova_project_SQL_secondary_final;


CREATE OR REPLACE TABLE `t_katerina_kocianova_project_SQL_secondary_final` AS
SELECT 
	c.country,
	c.capital_city,
	c.currency_name,
	c.government_type,
	c.surface_area,
	c.yearly_average_temperature,
	c.continent,
	c.region_in_world,
	e.year,
	e.GDP,
	e.gini,
	e.population,
	e.taxes,
	e.fertility,
	e.mortaliy_under5,
	c.avg_height,
	c.life_expectancy,
	c.median_age_2018
FROM countries AS c
JOIN economies AS e 
ON c.country = e.country
WHERE continent = 'Europe'
ORDER BY c.country, e.year;