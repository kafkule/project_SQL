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
Výzkumné otázky
1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/



-- 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- CREATE OR REPLACE VIEW payroll_values AS
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

-- CREATE OR REPLACE VIEW food_values AS
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
FROM payroll_values AS pv
JOIN food_values AS fv
ON pv.time_period = fv.time_period
ORDER BY industry, pv.time_period;


