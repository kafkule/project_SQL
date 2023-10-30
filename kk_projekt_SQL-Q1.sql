-- 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


SELECT *
FROM v_payroll_values_changes;

SELECT *
FROM v_payroll_rising_values;

SELECT *
FROM v_payroll_falling_values;


CREATE OR REPLACE VIEW v_payroll_values_changes AS
SELECT 
	kkp.industry AS industry,
	kkp2.payroll_value_year AS previous_year, 
	kkp2.avg_payroll_value AS previous_payroll_value,
	kkp.payroll_value_year AS 'year', 
	kkp.avg_payroll_value AS payroll_value,
	ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) AS payroll_value_growth_percentage,
	CASE
        WHEN ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) < 0 THEN 'falling'
        ELSE 'rising'
    END AS payroll_value_growth_status
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.payroll_value_year = kkp2.payroll_value_year + 1
	AND kkp.industry_branch_code = kkp2.industry_branch_code
GROUP BY industry, 'year', previous_year
ORDER BY industry, 'year', previous_year;


CREATE OR REPLACE VIEW v_payroll_rising_values AS
SELECT 
	kkp.industry AS industry,	
	kkp2.payroll_value_year AS previous_year, 
	kkp2.avg_payroll_value AS previous_payroll_value,
	kkp.payroll_value_year AS 'year', 
	kkp.avg_payroll_value,
	ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) AS payroll_value_growth_percentage,
	CASE
        WHEN ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) < 0 THEN 'falling'
        ELSE 'rising'
    END AS payroll_value_growth_status
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.payroll_value_year = kkp2.payroll_value_year + 1
	AND kkp.industry_branch_code = kkp2.industry_branch_code
WHERE 
	CASE
        WHEN ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) < 0 THEN 'falling'
        ELSE 'rising'
    END = 'rising'
GROUP BY industry, 'year', previous_year
ORDER BY industry, 'year', previous_year;


CREATE OR REPLACE VIEW v_payroll_falling_values AS
SELECT 
	kkp.industry AS industry,	
	kkp2.payroll_value_year AS previous_year, 
	kkp2.avg_payroll_value AS previous_payroll_value,
	kkp.payroll_value_year AS 'year', 
	kkp.avg_payroll_value AS payroll_value,
	ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) AS payroll_value_growth_percentage,
	CASE
        WHEN ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) < 0 THEN 'falling'
        ELSE 'rising'
    END AS payroll_value_growth_status
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.payroll_value_year = kkp2.payroll_value_year + 1
	AND kkp.industry_branch_code = kkp2.industry_branch_code
WHERE 
	CASE
        WHEN ROUND(((kkp.avg_payroll_value - kkp2.avg_payroll_value) / kkp2.avg_payroll_value) * 100, 2) < 0 THEN 'falling'
        ELSE 'rising'
    END = 'falling'
GROUP BY industry, 'year', previous_year
ORDER BY industry, 'year', previous_year;