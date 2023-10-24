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

SELECT 
        ib.name AS Odvetvi,	
	cpay.payroll_year AS Rok, 
	SUM(cpay.value *
	CASE
	       WHEN cpay.payroll_quarter = 1 THEN 4
               WHEN cpay.payroll_quarter = 2 THEN 4
               WHEN cpay.payroll_quarter = 3 THEN 4
               WHEN cpay.payroll_quarter = 4 THEN 4
               ELSE 0
        END) / 
        SUM(CASE 
               WHEN cpay.payroll_quarter = 1 THEN 4
               WHEN cpay.payroll_quarter = 2 THEN 4
               WHEN cpay.payroll_quarter = 3 THEN 4
               WHEN cpay.payroll_quarter = 4 THEN 4
               ELSE 0
               END) AS Vazeny_prumer_mzdy_za_rok,
        CASE
               WHEN LAG(cpay.value) OVER (PARTITION BY cpay.industry_branch_code ORDER BY cpay.payroll_year) IS NOT NULL
               THEN (((cpay.value - LAG(cpay.value) OVER (PARTITION BY cpay.industry_branch_code ORDER BY cpay.payroll_year)) / LAG(cpay.value) OVER (PARTITION BY cpay.industry_branch_code ORDER BY cpay.payroll_year)) * 100)
               ELSE 0
        END AS Mezirocni_rust -- rozdíl [%] mezi mzdou v aktuálním a předchozím roce                     
FROM czechia_payroll AS cpay
JOIN czechia_payroll_industry_branch AS ib ON cpay.industry_branch_code = ib.code
WHERE value_type_code = 5958 AND calculation_code = 200 -- průměrná hrubá mzda za plný úvazek v oboru
GROUP BY ib.name, cpay.payroll_year
ORDER BY ib.name, cpay.payroll_year;



-- 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT
    cpc.name AS Nazev_potraviny, 
    cp.value AS Cena_potraviny,
    YEAR (cp.date_from) AS Rok
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc
    ON cp.category_code = cpc.code
WHERE cpc.code IN (111301, 114201)
GROUP BY Rok, Nazev_potraviny;

SELECT *
FROM Rust_mezd AS rm
JOIN Ceny_potravin AS cp
ON rm.Rok = cp.Rok;



SELECT
    cpib.name AS 'Odvětví', 
    cpay.value AS 'Průměrná mzda',
    cpay.payroll_year AS 'Rok', 
    cpc.name AS 'Název potraviny', 
    cp.value AS 'Cena potraviny'
FROM czechia_price AS cp
JOIN czechia_payroll AS cpay
    ON YEAR(cp.date_from) = cpay.payroll_year 
    AND cpay.value_type_code = 5958 
    AND calculation_code = 200
JOIN czechia_price_category AS cpc
    ON cp.category_code = cpc.code
JOIN czechia_payroll_industry_branch AS cpib
    ON cpay.industry_branch_code = cpib.code
WHERE cpc.code IN (111301, 114201);



 
   
SELECT
    cpc.name AS food_category, cp.value AS price,
    cpib.name AS industry, cpay.value AS average_wages,
    DATE_FORMAT(cp.date_from, '%e. %M %Y') AS price_measured_from,
    DATE_FORMAT(cp.date_to, '%d.%m.%Y') AS price_measured_to,
    cpay.payroll_year
FROM czechia_price AS cp
JOIN czechia_payroll AS cpay
    ON YEAR(cp.date_from) = cpay.payroll_year AND
    cpay.value_type_code = 5958 AND
    cp.region_code IS NULL
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
JOIN czechia_payroll_industry_branch cpib
    ON cpay.industry_branch_code = cpib.code;
