ENGETO Projekt z SQL: Data o mzdách a cenách potravin 
Autor: Kateřina Kocianová
-----



# Project Structure

- dokumentace
- výzkumné otázky
- tabulky



# Assignment

Tento projekt se zaměřuje na analýzu růstu mezd v různých odvětvích a cen potravin v průběhu let. Cílem je zjistit, zda mzdy ve všech odvětvích rostou, nebo zda v některých odvětvích klesají. Zaměřujeme se na porovnání cen potravin a množství, které je možné za tyto ceny koupit za průměrnou mzdu v daném roce. Zkoumáme, která kategorie potravin zdražuje nejpomaleji a zároveň kdy byl meziroční nárůst jejich cen výrazně vyšší než růst mezd. Poslední část projektu se zabývá vlivem hodnoty HDP na změny ve mzdách a cenách potravin.



# Information from project work

Po přečtení zadání projektu jsem si vůbec nevěděla rady, ukázalo se ale, že hledám příliš složité řešení, místo abych se zaměřila hlavně na to, co už znám.

V rámci zpracování dat jsem bojovala zejména s dlouhým časem načítání některých tabulek, občas bohužel způsobeným technickými problémy a použitím DBeaveru na MacOS.



# Data description

## Primary table

První tabulka _t_katerina_kocianova_project_SQL_primary_final_ je spojením tabulek _czechia_payroll_, která obsahuje informace o mzdách v různých odvětvích za období několika po sobě jdoucích let, a _czechia_price_ s informacemi o cenách vybraných potravin za období několika let. Zároveň jsou k tabulce připojeny také nejrůznější číselníky (kalkulace a hodnoty mezd, odvětví, kategorie potravin apod.).

V tabulce jsou zobrazeny sloupce odvětví a jejich kód, hodnoty mezd a ceny potravin za dané roky a názvy potravin. V tabulce jsem se snažila zobrazit pouze ty nejdůležitější sloupce a záznamy, se kterých vychází odpovědi na výzkumné otázky. Většina se dala propojit přes primární klíče, v jednom případě šlo o vnější spojení. Dále bylo třeba data vyfiltrovat tak, abych získala záznamy jen pro průměrnou hrubou mzdou za plný úvazek. Nakonec jsem sloučila záznamy a seřadila tabulku podle názvu odvětví, let a názvu potravin.


## Secondary Table

t_katerina_kocianova_project_SQL_secondaryb_final

# Ansers to questions

## Question 1
Lorem ipsum dolor sit amet. This is someting.

## Question 2
Lorem ipsum dolor sit amet. This is someting.

## Question 3
Lorem ipsum dolor sit amet. This is someting.

