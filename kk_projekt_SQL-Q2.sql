-- 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

CREATE OR REPLACE VIEW v_purchase AS
SELECT
	industry,
	avg_payroll_value AS payroll_value,
	payroll_value_year AS 'year',
	avg_food_value AS food_value,
	food_name,
	CASE
        WHEN avg_payroll_value = 0 THEN NULL
        ELSE ROUND((avg_payroll_value / avg_food_value), 0)
    END AS purchase
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
WHERE (food_name = 'Chléb konzumní kmínový' OR food_name = 'Mléko polotučné pasterované')
	AND (payroll_value_year = 2006 OR payroll_value_year = 2018)
ORDER BY industry, payroll_value_year;


CREATE OR REPLACE VIEW v_avg_purchase AS
SELECT
	payroll_value_year AS 'year',
	ROUND(AVG(avg_payroll_value),2) AS avg_payroll_value,
	ROUND(AVG(avg_food_value),2) AS avg_food_value,
	food_name,
	CASE
        WHEN AVG(avg_payroll_value) = 0 THEN NULL
        ELSE ROUND((AVG(avg_payroll_value) / AVG(avg_food_value)), 0)
    END AS purchase
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
WHERE (food_name = 'Chléb konzumní kmínový' OR food_name = 'Mléko polotučné pasterované')
	AND (payroll_value_year = 2006 OR payroll_value_year = 2018)
GROUP BY food_name, payroll_value_year
ORDER BY food_name, payroll_value_year;