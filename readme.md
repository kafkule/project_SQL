### ENGETO Projekt z SQL: Data o mzdách a cenách potravin 

### Autor: Kateřina Kocianová (Discord: Kateřina Koci - kafkule)
-----



## Struktura projektu

- dokumentace
- tabulky
- výzkumné otázky




## Zadání projektu

Tento projekt se zaměřuje na analýzu růstu mezd v různých odvětvích a cen potravin v průběhu let. Cílem je zjistit, zda mzdy ve všech odvětvích rostou, nebo zda v některých odvětvích klesají. Zaměřujeme se na porovnání cen potravin a množství, které je možné za tyto ceny koupit za průměrnou mzdu v daném roce. Zkoumáme, která kategorie potravin zdražuje nejpomaleji a zároveň, kdy byl meziroční nárůst jejich cen výrazně vyšší než růst mezd. Poslední část projektu se zabývá vlivem hodnoty HDP na změny ve mzdách a cenách potravin.



## Dodatečné informace

Po přečtení zadání projektu jsem nevěděla, co se ode mě očekává za výstupy. Ukázalo se ale, že jsem hledala příliš složité řešení, místo toho, abych se zaměřila na to, co již znám.

Během zpracování dat jsem se setkala s dlouhým časem načítání některých tabulek, což bylo občas způsobeno technickými problémy a používáním DBeaveru na MacOS. V mezičase jsem proto přešla k DBVisualizeru, ale nakonec jsem se vrátila k DBeaveru a již se neobjevily žádné větší potíže. Časem si ale přeji vyzkoušet i další aplikace pro správu databází. Zpočátku jsem také měla potíže s prací v Gitu, ale nyní už je to pro mě běžná rutina a automatická součást práce.

Pro usnadnění práce jsem uložila obě své tabulky do databáze s názvem "data_academy_2023_09_26". Zároveň jsem se snažila pro každou tabulku vytvořit pohledy. V některých případech jsem tyto pohledy použila k vytvoření dotazů pro zodpovězení dalších otázek.


## Popis dat

### Primární tabulka

První tabulka _t_katerina_kocianova_project_SQL_primary_final_ vznikla spojením tabulek _czechia_payroll_, která obsahuje informace o mzdách v různých odvětvích za období několika po sobě jdoucích let, a _czechia_price_ s informacemi o cenách vybraných potravin za období několika let. Zároveň jsou k tabulce připojeny také nejrůznější číselníky (kalkulace a hodnoty mezd, odvětví, kategorie potravin apod.).

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

Pro jistotu přidávám ještě pohled _v_payroll_price_growth_comparsion2_, který zohledňuje přímo rozdíl mezi procentem navýšením ceny potravin a mezd. Ani zde není nikde hodnota vyšší než 10 %.


### Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Vliv HDP na mzdy a ceny potravin ukazuje pohled _v_GDP_payroll_price_growth_comparsion_. Z něj lze vyčíst, že:

- v roce 2008 klesalo HDP, klesala také cena potravin, a přesto stoupala mzda, to může znamenat, že v tomto roce došlo k výraznému zvýšení produktivity práce např. vyšším využitím technologií, lepším řízením, efektivnějším výrobním procesem nebo jinými faktory, které umožnily zaměstnavatelům platit zaměstnancům více za jejich práci, ale může to i naznačovat, že ČNB očekávala pokles inflace, a zaměstnavatelé tak mohli reagovat na tuto situaci zvyšováním mezd, aby si udrželi zaměstnance
- v letech 2009, 2012 a 2013 klesalo HDP, ceny potravin i mzdy, to naznačuje období ekonomické krize země a tedy období, kdy se zavedla opatření k obnovení ekonomické stability
- v roce 2011 rostlo HDP, cena potravin i mzdy, z toho můžeme usuzovat, že ekonomika byla již v lepší kondici, např. se zvyšovala celková produkce zboží a služeb, zvyšovala se poptávka po pracovní síle
- mezi lety 2011 - 2012 a 2016 - 2017 klesalo HDP, a přesto rostly mzdy i ceny potravin, s největší pravděpodobností je důsledkem růstu mezd a cen potravin pravděpodobně zvyšující se inflace

Pro lepší představu jsem vytvořila také graf závislosti výše HDP na výši mezd a cen potravin v meziročním srovnání. Je však třeba říct, že v ekonomice se vyznám velice málo, a tak jsem vliv HDP na výši mezd nebo cenu potravin konzultovala s AI :)

![Graf HDP](https://github.com/kafkule/project_SQL/blob/main/images/HDP.png)



## Změny na základě zpětné vazby lektora

- soubor .DS_Store by neměl být součástí repozitáře, nyní veden jako nesledovaný v souboru .gitignore
- některé skripty obsahovaly dotazy, které nevedly k výsledkům , ty byly odstraněny, aby nezahlcovaly finální scripty
- některé commit messages by měly být lépe definovány



## Závěr

Projekt z SQL: Data o mzdách a cenách potravin SPLNĚNO :white_check_mark:
