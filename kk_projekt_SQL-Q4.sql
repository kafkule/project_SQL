-- 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

CREATE OR REPLACE VIEW v_payroll_price_growth_comparsion AS
SELECT 
	kkp2.payroll_value_year AS previous_year, 
	ROUND(AVG(kkp2.avg_payroll_value),2) AS previous_payroll_value,
	ROUND(AVG(kkp2.avg_food_value),2) AS previous_food_value,	
	kkp.payroll_value_year AS 'year', 
	ROUND(AVG(kkp.avg_payroll_value),2) AS payroll_value,
	ROUND(AVG(kkp.avg_food_value),2) AS food_value,
	ROUND(((AVG(kkp.avg_payroll_value) - AVG(kkp2.avg_payroll_value)) / AVG(kkp2.avg_payroll_value)) * 100, 2) AS payroll_value_growth_percentage,
	ROUND(((AVG(kkp.avg_food_value) - AVG(kkp2.avg_food_value)) / AVG(kkp2.avg_food_value)) * 100, 2) AS food_value_growth_percentage
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.payroll_value_year = kkp2.payroll_value_year + 1
	AND kkp.industry_branch_code = kkp2.industry_branch_code
	AND kkp.food_name = kkp2.food_name 
	AND kkp.food_value_year = kkp2.food_value_year + 1
GROUP BY 'year', previous_year
ORDER BY 'year', previous_year;


CREATE OR REPLACE VIEW v_payroll_price_growth_comparsion2 AS
SELECT 
	kkp2.payroll_value_year AS previous_year, 
	ROUND(AVG(kkp2.avg_payroll_value),2) AS previous_payroll_value,
	ROUND(AVG(kkp2.avg_food_value),2) AS previous_food_value,
	kkp.payroll_value_year AS 'year', 
	ROUND(AVG(kkp.avg_payroll_value),2) AS payroll_value,
	ROUND(AVG(kkp.avg_food_value),2) AS food_value,
	ROUND(((AVG(kkp.avg_payroll_value) - AVG(kkp2.avg_payroll_value)) / AVG(kkp2.avg_payroll_value)) * 100, 2) AS payroll_value_growth_percentage,
	ROUND(((AVG(kkp.avg_food_value) - AVG(kkp2.avg_food_value)) / AVG(kkp2.avg_food_value)) * 100, 2) AS food_value_growth_percentage,
	ROUND(((AVG(kkp.avg_food_value) - AVG(kkp2.avg_food_value)) / AVG(kkp2.avg_food_value)) * 100, 2) - ROUND(((AVG(kkp.avg_payroll_value) - AVG(kkp2.avg_payroll_value)) / AVG(kkp2.avg_payroll_value)) * 100, 2) AS food_payroll_value_difference
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.payroll_value_year = kkp2.payroll_value_year + 1
	AND kkp.industry_branch_code = kkp2.industry_branch_code
	AND kkp.food_name = kkp2.food_name 
	AND kkp.food_value_year = kkp2.food_value_year + 1
GROUP BY 'year', previous_year
ORDER BY 'year', previous_year;