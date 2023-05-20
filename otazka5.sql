/*
*5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
*projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
*/

-- výpočet meziročního růstu/poklesu HDP pro ČR:
CREATE OR REPLACE VIEW v_rust_hdp AS
SELECT
	ts2.`year` + 1 AS year_1,
	round(( ts.GDP - ts2.GDP ) / ts2.GDP * 100, 2 ) AS HDP_growth
FROM t_denisa_louzilova_project_sql_secondary_final ts
JOIN t_denisa_louzilova_project_sql_secondary_final ts2
	ON ts.`year` = ts2.`year`+ 1
	AND ts.country = ts2.country
WHERE ts.country = 'Czech Republic';

-- přiřazení průměrného růstu cen potravin a mezd k růstu HDP na roky:
SELECT
	vrh.year_1,
	vrh.HDP_growth,
	price.food_growth,
	pay.growth_pay
FROM v_rust_hdp vrh
LEFT JOIN (
	SELECT
		year_2,
		round(avg(a.price_growth), 2) AS food_growth
	FROM (
	SELECT *
	FROM v_narust_cen_potravin vn
	GROUP BY year_2, food_name
) a
GROUP BY year_2
) price 
ON vrh.year_1 = price.year_2
LEFT JOIN (
	SELECT
		year_p,
		round(avg(a.pay_growth), 2) AS growth_pay
	FROM (
	SELECT *
	FROM v_narust_mezd vnm 
	GROUP BY year_p, industry_branch_name
) a
GROUP BY year_p
) pay
ON vrh.year_1 = pay.year_p;

/*
 * Závěrem:
 * Po analýze dat lze říct, že při nárůstu HDP stoupají ceny jídla i mzdy.
 * Pokles HDP může mít i vliv na pokles cen potravin ve stejném roce následujících letech.
 * U mezd byl klesající trend pouze v roce 2013, což také může souviset se záporným HDP v letech 2012 a 2013.
 */
