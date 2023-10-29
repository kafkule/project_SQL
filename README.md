### ENGETO Projekt z SQL: Data o mzdách a cenách potravin 

### Autor: Kateřina Kocianová
-----



## Struktura projektu

- dokumentace
- výzkumné otázky
- tabulky



## Zadání projektu

Tento projekt se zaměřuje na analýzu růstu mezd v různých odvětvích a cen potravin v průběhu let. Cílem je zjistit, zda mzdy ve všech odvětvích rostou, nebo zda v některých odvětvích klesají. Zaměřujeme se na porovnání cen potravin a množství, které je možné za tyto ceny koupit za průměrnou mzdu v daném roce. Zkoumáme, která kategorie potravin zdražuje nejpomaleji a zároveň kdy byl meziroční nárůst jejich cen výrazně vyšší než růst mezd. Poslední část projektu se zabývá vlivem hodnoty HDP na změny ve mzdách a cenách potravin.



## Dodatečné informace

Po přečtení zadání projektu jsem si vůbec nevěděla rady, ukázalo se ale, že hledám příliš složité řešení, místo abych se zaměřila hlavně na to, co už znám.

V rámci zpracování dat jsem bojovala zejména s dlouhým časem načítání některých tabulek, občas bohužel způsobeným technickými problémy a použitím DBeaveru na MacOS.



## Popis dat

### Primární tabulka

První tabulka _t_katerina_kocianova_project_SQL_primary_final_ je spojením tabulek _czechia_payroll_, která obsahuje informace o mzdách v různých odvětvích za období několika po sobě jdoucích let, a _czechia_price_ s informacemi o cenách vybraných potravin za období několika let. Zároveň jsou k tabulce připojeny také nejrůznější číselníky (kalkulace a hodnoty mezd, odvětví, kategorie potravin apod.).

V tabulce jsou zobrazeny sloupce odvětví a jejich kód, hodnoty mezd a ceny potravin za dané roky a názvy potravin. V tabulce jsem se snažila zobrazit pouze ty nejdůležitější sloupce a záznamy, se kterých vychází odpovědi na výzkumné otázky. Většina se dala propojit přes primární klíče, v jednom případě šlo o vnější spojení. Dále bylo třeba data vyfiltrovat tak, abych získala záznamy jen pro průměrnou hrubou mzdou za plný úvazek. Nakonec jsem sloučila záznamy a seřadila tabulku podle názvu odvětví, let a názvu potravin.


### Sekundární tabulka

Druhá tabulka _t_katerina_kocianova_project_SQL_secondary_final_ propojuje tabulky _countries_ s informacemi o zemích světa a _economies_, která obsahuje data k HDP, daním apod.

V tabulce jsou zobrazeny základní informace o evropských státech, seřazené dle názvu dané země a let, za které jsou evidované konkrétní data.



## Výzkumné otázky

### Q1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Pohled _v_payroll_values_changes_ ukazuje celkový pohled na odvětví a změny mezd v průběhu let 2006 - 2018.
Pohled _v_payroll_rising_values_ říká, u kterých odvětví docházelo v určitých letech k nárůstu, naopak pohled _v_payroll_falling_values_ zobrazuje odvětví, kde mzdy v některých letech klesaly. 

Z pohledu _v_payroll_falling_values_ také vyplývá, že v odvětvích _Doprava a skladování_, Ostatní činnosti_, _Zdravotní a sociální péče_ a _Zpracovatelský průmysl_ mzdy v období 2006 - 2018 neklesaly, ale pouze rostly.


### Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Pohled _v_purchase_ zobrazuje, kolik litrů mléka a kolik kilogramů chleba je možné si koupit v letech 2006 a 2018 dle mzdy v různých odvětvích.

Pohled _v_avg_purchase_ ukazuje, kolik litrů mléka a kolik kilogramů chleba je možné si koupit v letech 2006 a 2018 za průměrnou mzdu za všechny odvětví.


### Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Pohled _v_food_values_changes_ zobrazuje změny cen jednotlivých potravin v letech 2006 - 2018.

V rámci pohledu _v_food_values_changes_rank_ můžeme vidět, která kategorie potravin zdražuje nejpomaleji. Cukr a rajčata v daném období nezdražily vůbec, naopak zlevnily. Nejpomaleji pak rostou ceny banánů, vepřové pečeně, přírodní minerální vody, šunkového salámu a jablek (pořadí prvních 5 nejpomaleji zdražujících potravin).


### Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Srovnání meziročního růstu mezd a cen potravin ukazuje pohled _v_payroll_price_growth_comparsion_. Z něj plyne, že v žádném roce nedošlo k nárůstů mezd ani cen potravin o více než 10 %. Jediný rok, který se 10 % blíží, je v případě cen potravin změna cen mezi roky 2016 a 2017 průměrně o 9,63 %.


### Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
