/*
 * 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 */

-- pro potraviny:
SELECT
	year_2,
	round(avg(a.price_growth), 2) AS food_growth
FROM (
SELECT *
FROM v_narust_cen_potravin vn
GROUP BY year_2, food_name
) a
GROUP BY year_2;

/*
 * Největší nárůst potravin byl v roce 2007(oproti r. 2006) a to 9,26 %.
 */

-- pro mzdy:
CREATE OR REPLACE VIEW v_narust_mezd AS
SELECT DISTINCT
	p.industry_branch_name,
	p2.payroll_year + 1 AS year_p,
	round( ( p.pay_value - p2.pay_value ) / p2.pay_value * 100, 2 ) AS pay_growth
FROM t_denisa_louzilova_project_sql_primary_final p
JOIN t_denisa_louzilova_project_sql_primary_final p2
	ON p.industry_branch_name = p2.industry_branch_name
	AND p.payroll_year = p2.payroll_year +1
ORDER BY p.industry_branch_name, year_p;

SELECT
	year_p,
	round(avg(a.pay_growth), 2) AS pay_avg 
FROM (
	SELECT *
	FROM v_narust_mezd vnm 
	GROUP BY year_p, industry_branch_name
) a
GROUP BY year_p;

-- Největší průměrný nárůst mezd byl v roce 2018 a to o 7,78%

-- porovnání průměrného růstu potravin a mezd bez ohledu na kategorie:
SELECT
	a.*,
	round(food_avg - pay_avg, 2) AS difference
FROM (
SELECT
	vp.year_2,
	round(avg(vp.price_growth), 2) AS food_avg,
	round(avg(vm.pay_growth), 2) AS pay_avg
FROM v_narust_cen_potravin vp
JOIN v_narust_mezd vm
	ON vp.year_2 = vm.year_p
GROUP BY year_2
) a;

/*
 * Závěr:
 * V žádném roce nebyl růst cen potravin oproti růstu mezd vyšší než 10% (za sledované období 2006 - 2018).
 * Největší rozdíl byl v roce 2013 - o 6,79 %, kdy došlo k rustu cen potravin a snížení průměrných platů.
 * Naopak v roce 2009 byl rozdíl -9,56 %, kdy došlo k výraznému poklesu cen potravin a mírnému růstu mezd.
 */
