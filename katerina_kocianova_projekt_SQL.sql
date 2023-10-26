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
A) Vytvořit tabulky t_Katerina_Kocianova_project_SQL_primary_final a t_Katerina_Kocianova_project_SQL_secondary_final
B) Zodpovědět výzkumné otázky:
	1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
	2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
	3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
	4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
	5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/

-- VÝSTUP PROJEKTU - TABULKY

SELECT *
FROM czechia_payroll AS cpay
JOIN czechia_payroll_industry_branch AS ib ON cpay.industry_branch_code = ib.code
JOIN czechia_payroll_calculation AS cpc ON cpay.calculation_code = cpc.code
JOIN czechia_payroll_unit AS cpu ON cpay.unit_code = cpu.code
JOIN czechia_payroll_value_type AS cpvt ON cpay.value_type_code = cpvt.code
JOIN czechia_price AS cp ON cpay.payroll_year = YEAR(cp.date_from)
RIGHT JOIN czechia_price_category AS cpcat ON cp.category_code = cpcat.code;

-- CREATE OR REPLACE TABLE `t_Katerina_Kocianova_project_SQL_primary_final` AS
SELECT
	ib.name AS industry,
	cpay.value AS payroll_value,
	cpay.payroll_year AS 'year',
	cp.value AS food_value,
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
	AND cpcat.code IN (111301, 114201)
ORDER BY industry;


-- CREATE OR REPLACE TABLE `t_Katerina_Kocianova_project_SQL_secondary_final` AS
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

-- CREATE OR REPLACE VIEW v_payroll_values_changes AS
SELECT 
    ib.name AS industry,	
	cpay.payroll_year AS time_period, 
	cpay.value AS payroll_value,
	cpay2.payroll_year AS previous_time_period,
	cpay2.value AS previous_time_period_value,
	ROUND(((cpay.value - cpay2.value) / cpay2.value) * 100, 2) AS value_growth_percentage
FROM czechia_payroll AS cpay
JOIN czechia_payroll AS cpay2 ON cpay.payroll_year = cpay2.payroll_year + 1
	AND cpay.industry_branch_code = cpay2.industry_branch_code
JOIN czechia_payroll_industry_branch AS ib ON cpay.industry_branch_code = ib.code
WHERE cpay.value_type_code = 5958 AND cpay2.value_type_code = 5958
	AND cpay.calculation_code = 200 AND cpay2.calculation_code = 200 
	AND cpay.industry_branch_code IS NOT NULL -- průměrná hrubá mzda za plný úvazek v oboru
	AND cpay.payroll_year BETWEEN '2006' AND '2018'
GROUP BY industry, time_period
ORDER BY industry, time_period;



-- 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- CREATE OR REPLACE VIEW v_food_values AS
SELECT
    cpc.name AS food_name, 
    cp.value AS food_value,
    YEAR (cp.date_from) AS time_period
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code
WHERE cpc.code IN (111301, 114201)
GROUP BY time_period, food_name;


SELECT *,
	CASE
        WHEN payroll_value = 0 THEN NULL
        ELSE ROUND((payroll_value / food_value),0)
    END AS purchase
FROM v_payroll_values_changes AS pv
JOIN v_food_values AS fv
ON pv.time_period = fv.time_period
ORDER BY industry, pv.time_period;


-- 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- CREATE OR REPLACE VIEW v_avg_food_values AS
SELECT 
    cpc.name AS food_name,	
	YEAR(cp.date_from) AS time_period, 
	ROUND(AVG(cp.value),2) AS food_value
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc 
ON cp.category_code = cpc.code
GROUP BY food_name, time_period
ORDER BY food_name, time_period;

-- CREATE OR REPLACE VIEW v_avg_food_values_2 AS
SELECT 
    cpc.name AS food_name,	
	YEAR(cp.date_from) AS previous_time_period, 
	ROUND(AVG(cp.value),2) AS previous_time_period_food_value
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc 
ON cp.category_code = cpc.code
GROUP BY food_name, previous_time_period
ORDER BY food_name, previous_time_period;

-- CREATE OR REPLACE VIEW v_food_values_changes AS
SELECT 
	afv.food_name,
	afv.time_period,
	afv.food_value,
	afv2.previous_time_period,
	afv2.previous_time_period_food_value,
	ROUND(((afv.food_value - afv2.previous_time_period_food_value) / afv2.previous_time_period_food_value) * 100, 2) AS food_value_growth_percentage
FROM v_avg_food_values AS afv
JOIN v_avg_food_values_2 AS afv2
ON afv.food_name = afv2.food_name AND afv.time_period = afv2.previous_time_period + 1;

-- CREATE OR REPLACE VIEW v_food_values_changes_rank AS
SELECT 
	afv.food_name,
	ROUND(AVG(((afv.food_value - afv2.previous_time_period_food_value) / afv2.previous_time_period_food_value) * 100), 2) AS avg_food_value_growth_percentage
FROM v_avg_food_values AS afv
JOIN v_avg_food_values_2 AS afv2
ON afv.food_name = afv2.food_name AND afv.time_period = afv2.previous_time_period + 1
GROUP BY afv.food_name
ORDER BY avg_food_value_growth_percentage;



SELECT 
    cpc.name AS food_name,	
	YEAR(cp.date_from) AS time_period, 
	cp.value AS food_value,
	YEAR(cp2.date_from) AS previous_time_period,
	cp2.value AS previous_time_period_food_value,
	ROUND(((cp.value - cp2.value) / cp2.value) * 100, 2) AS food_value_growth_percentage
FROM czechia_price AS cp
JOIN czechia_price AS cp2 ON YEAR(cp.date_from)= YEAR(cp2.date_from) + 1
	AND cp.category_code = cp2.category_code
JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code
GROUP BY food_name, time_period
ORDER BY food_name, time_period;


-- 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- CREATE OR REPLACE VIEW v_avg_grocery_values AS
SELECT 
    YEAR(cp.date_from) AS time_period, 
	ROUND(AVG(cp.value),2) AS grocery_value
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc 
ON cp.category_code = cpc.code
GROUP BY time_period
ORDER BY time_period;

-- CREATE OR REPLACE VIEW v_avg_grocery_values_2 AS
SELECT 
    YEAR(cp.date_from) AS previous_time_period, 
	ROUND(AVG(cp.value),2) AS previous_time_period_grocery_value
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc 
ON cp.category_code = cpc.code
GROUP BY previous_time_period
ORDER BY previous_time_period;

SELECT 
	agv.time_period,
	agv.grocery_value,
	agv2.previous_time_period,
	agv2.previous_time_period_grocery_value,
	ROUND(((agv.grocery_value - agv2.previous_time_period_grocery_value) / agv2.previous_time_period_grocery_value) * 100, 2) AS grocery_value_growth_percentage
FROM v_avg_grocery_values AS agv
JOIN v_avg_grocery_values_2 AS agv2
ON agv.time_period = agv2.previous_time_period + 1;

-- CREATE OR REPLACE VIEW v_avg_payroll_values_changes AS
SELECT 
    cpay.payroll_year AS time_period, 
	cpay.value AS payroll_value,
	cpay2.payroll_year AS previous_time_period,
	cpay2.value AS previous_time_period_value,
	ROUND(((cpay.value - cpay2.value) / cpay2.value) * 100, 2) AS payroll_value_growth_percentage
FROM czechia_payroll AS cpay
JOIN czechia_payroll AS cpay2 ON cpay.payroll_year = cpay2.payroll_year + 1
	AND cpay.industry_branch_code = cpay2.industry_branch_code
JOIN czechia_payroll_industry_branch AS ib ON cpay.industry_branch_code = ib.code
WHERE cpay.value_type_code = 5958 AND cpay2.value_type_code = 5958
	AND cpay.calculation_code = 200 AND cpay2.calculation_code = 200 
	AND cpay.industry_branch_code IS NOT NULL -- průměrná hrubá mzda za plný úvazek v oboru
	AND cpay.payroll_year BETWEEN '2006' AND '2018'
GROUP BY time_period
ORDER BY time_period;


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
