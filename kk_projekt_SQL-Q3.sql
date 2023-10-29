-- 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?


SELECT *
FROM v_food_values_changes;

SELECT *
FROM v_food_values_changes_rank;


CREATE OR REPLACE VIEW v_food_values_changes AS
SELECT 
	kkp.food_name AS food,
	kkp.avg_food_value AS value,
	kkp2.food_value_year AS previous_year,
	kkp2.avg_food_value AS previous_value,
	kkp.food_value_year AS 'year',
	ROUND(((kkp.avg_food_value - kkp2.avg_food_value) / kkp2.avg_food_value) * 100, 2) AS food_value_growth_percentage
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.food_name = kkp2.food_name AND kkp.food_value_year = kkp2.food_value_year + 1
GROUP BY food, 'year', previous_year
ORDER BY food, 'year', previous_year;


CREATE OR REPLACE VIEW v_food_values_changes_rank AS
SELECT 
	kkp.food_name,
	ROUND(AVG(((kkp.avg_food_value - kkp2.avg_food_value) / kkp2.avg_food_value) * 100), 2) AS avg_food_value_growth_percentage
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.food_name = kkp2.food_name AND kkp.food_value_year = kkp2.food_value_year + 1
GROUP BY kkp.food_name
ORDER BY avg_food_value_growth_percentage
LIMIT 7;