SELECT *
FROM t_katerina_kocianova_project_SQL_primary_final;


CREATE OR REPLACE TABLE `t_katerina_kocianova_project_SQL_primary_final` AS
SELECT
	ib.name AS industry,
	cpay.industry_branch_code,
	AVG(cpay.value) AS avg_payroll_value,
	cpay.payroll_year AS payroll_value_year,
	AVG(cp.value) AS avg_food_value,
	YEAR(cp.date_from) AS food_value_year,
	cpcat.name AS food_name
FROM czechia_payroll AS cpay
JOIN czechia_payroll_industry_branch AS ib ON cpay.industry_branch_code = ib.code
JOIN czechia_payroll_calculation AS cpc ON cpay.calculation_code = cpc.code
JOIN czechia_payroll_unit AS cpu ON cpay.unit_code = cpu.code
JOIN czechia_payroll_value_type AS cpvt ON cpay.value_type_code = cpvt.code
JOIN czechia_price AS cp ON cpay.payroll_year = YEAR(cp.date_from)
RIGHT JOIN czechia_price_category AS cpcat ON cp.category_code = cpcat.code
WHERE cpay.value_type_code = 5958
	AND cpay.calculation_code = 200 
	AND cpay.industry_branch_code IS NOT NULL
GROUP BY industry, payroll_value_year, food_value_year, food_name
ORDER BY industry ASC, payroll_value_year ASC, food_value_year, food_name ASC;