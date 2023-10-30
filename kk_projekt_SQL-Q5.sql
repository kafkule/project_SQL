-- 5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?


SELECT *
FROM v_GDP_CZ_changes;

SELECT *
FROM v_GDP_payroll_price_growth_comparsion;


CREATE OR REPLACE VIEW v_GDP_CZ_changes AS
SELECT 
	e.country,
	e2.year AS previous_GDP_year,
	e2.GDP AS previous_GDP,
	e.year AS GDP_year,
	e.GDP AS GDP,
	ROUND(((e.GDP - e2.GDP) / e2.GDP) * 100, 2) AS GDP_growth_percentage
FROM economies AS e
JOIN economies AS e2
ON e.country = e2.country AND e.year = e2.year + 1
WHERE e.country = 'Czech Republic' AND e2.country = 'Czech Republic'
	AND e.GDP IS NOT NULL AND e2.GDP IS NOT NULL
ORDER BY GDP_year, previous_GDP_year;

SELECT *
FROM v_GDP_payroll_price_growth_comparsion;


CREATE OR REPLACE VIEW v_GDP_payroll_price_growth_comparsion AS
SELECT 
	ppgc.previous_year AS previous_year,
	ppgc.year AS 'year', 
	gcc.GDP_growth_percentage,
	ppgc.payroll_value_growth_percentage,
	ppgc.food_value_growth_percentage
FROM v_payroll_price_growth_comparsion AS ppgc
JOIN v_GDP_CZ_changes AS gcc
ON ppgc.year = gcc.GDP_year + 1
GROUP BY 'year', previous_year
ORDER BY 'year', previous_year;