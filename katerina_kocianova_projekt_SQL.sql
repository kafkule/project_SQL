-- Datové sady, které je možné použít pro získání vhodného datového podkladu

-- Primární tabulky:

SELECT *
FROM czechia_payroll; -- Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.

SELECT *
FROM czechia_payroll_calculation; -- Číselník kalkulací v tabulce mezd.

SELECT *
FROM czechia_payroll_industry_branch; -- Číselník odvětví v tabulce mezd.

SELECT *
FROM czechia_payroll_unit; -- Číselník jednotek hodnot v tabulce mezd.

SELECT *
FROM czechia_payroll_value_type; -- Číselník typů hodnot v tabulce mezd.

SELECT *
FROM czechia_price; -- Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.

SELECT *
FROM czechia_price_category; -- Číselník kategorií potravin, které se vyskytují v našem přehledu.


-- Číselníky sdílených informací o ČR: 

SELECT *
FROM czechia_region; -- Číselník krajů České republiky dle normy CZ-NUTS 2.

SELECT *
FROM czechia_district; -- Číselník okresů České republiky dle normy LAU.


-- Dodatečné tabulky:

SELECT *
FROM countries; -- Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.

SELECT *
FROM economies; -- HDP, GINI, daňová zátěž, atd. pro daný stát a rok.


/* 
Úkoly:
A) Vytvořit tabulky t_katerina_kocianova_project_SQL_primary_final a t_katerina_kocianova_project_SQL_secondary_final
B) Zodpovědět výzkumné otázky:
	1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
	2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
	3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
	4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
	5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/


-- VÝSTUP PROJEKTU - TABULKY

SELECT *
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp;

SELECT *
FROM t_katerina_kocianova_project_SQL_secondary_final AS kks;
	

-- CREATE OR REPLACE TABLE `t_katerina_kocianova_project_SQL_primary_final` AS
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


-- CREATE OR REPLACE TABLE `t_katerina_kocianova_project_SQL_secondary_final` AS
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



-- VÝZKUMNÉ OTÁZKY

-- 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT *
FROM v_payroll_values_changes;

-- CREATE OR REPLACE VIEW v_payroll_values_changes AS
SELECT 
	kkp.industry AS industry,	
	kkp.payroll_value_year AS 'year', 
	kkp.avg_payroll_value AS payroll_value,
	kkp2.payroll_value_year AS previous_year, 
	kkp2.avg_payroll_value AS previous_payroll_value,
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

-- CREATE OR REPLACE VIEW v_payroll_rising_values AS
SELECT 
	kkp.industry AS industry,	
	kkp.payroll_value_year AS 'year', 
	kkp.avg_payroll_value,
	kkp2.payroll_value_year AS previous_year, 
	kkp2.avg_payroll_value AS previous_payroll_value,
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

-- CREATE OR REPLACE VIEW v_payroll_falling_values AS
SELECT 
	kkp.industry AS industry,	
	kkp.payroll_value_year AS 'year', 
	kkp.avg_payroll_value AS payroll_value,
	kkp2.payroll_value_year AS previous_year, 
	kkp2.avg_payroll_value AS previous_payroll_value,
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


-- 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- CREATE OR REPLACE VIEW v_purchase AS
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

-- CREATE OR REPLACE VIEW v_avg_purchase AS
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


-- 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

SELECT *
FROM v_food_values_changes;

-- CREATE OR REPLACE VIEW v_food_values_changes AS
SELECT 
	kkp.food_name AS food,
	kkp.food_value_year AS 'year',
	kkp.avg_food_value AS value,
	kkp2.food_value_year AS previous_year,
	kkp2.avg_food_value AS previous_value,
	ROUND(((kkp.avg_food_value - kkp2.avg_food_value) / kkp2.avg_food_value) * 100, 2) AS food_value_growth_percentage
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.food_name = kkp2.food_name AND kkp.food_value_year = kkp2.food_value_year + 1
GROUP BY food, 'year', previous_year
ORDER BY food, 'year', previous_year;


-- CREATE OR REPLACE VIEW v_food_values_changes_rank AS
SELECT 
	kkp.food_name,
	ROUND(AVG(((kkp.avg_food_value - kkp2.avg_food_value) / kkp2.avg_food_value) * 100), 2) AS avg_food_value_growth_percentage
FROM t_katerina_kocianova_project_SQL_primary_final AS kkp
JOIN t_katerina_kocianova_project_SQL_primary_final AS kkp2
ON kkp.food_name = kkp2.food_name AND kkp.food_value_year = kkp2.food_value_year + 1
GROUP BY kkp.food_name
ORDER BY avg_food_value_growth_percentage
LIMIT 7;

SELECT *
FROM v_food_values_changes_rank;


-- 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

SELECT *
FROM v_payroll_price_growth_comparsion;

-- CREATE OR REPLACE VIEW v_payroll_price_growth_comparsion AS
SELECT 
	kkp.payroll_value_year AS 'year', 
	ROUND(AVG(kkp.avg_payroll_value),2) AS payroll_value,
	ROUND(AVG(kkp.avg_food_value),2) AS food_value,
	kkp2.payroll_value_year AS previous_year, 
	ROUND(AVG(kkp2.avg_payroll_value),2) AS previous_payroll_value,
	ROUND(AVG(kkp2.avg_food_value),2) AS previous_food_value,
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


-- 5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

SELECT
	country,
	year,
	GDP
FROM economies
WHERE country = 'European Union'
ORDER BY year;

SELECT 
	e.country,
	e.year AS time_period,
	e.GDP,
	e2.year AS previous_time_period,
	e2.GDP AS previous_GDP,
	ROUND(((e.GDP - e2.GDP) / e2.GDP) * 100, 2) AS GDP_growth_percentage
FROM economies AS e
JOIN economies AS e2
ON e.country = e2.country AND e.year = e2.year + 1
WHERE e.country = 'European Union' AND e2.country = 'European Union'
	AND e.GDP IS NOT NULL AND e2.GDP IS NOT NULL
ORDER BY time_period;
