/*
 * 1. výzkumná otázka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

-- růst mezd výpočet:
SELECT DISTINCT
	p.industry_branch_name,
	p.industry_code,
	p2.payroll_year + 1 AS year_p,
	round( ( p.pay_value - p2.pay_value ) / p2.pay_value * 100, 2 ) AS pay_growth
FROM t_denisa_louzilova_project_sql_primary_final p
JOIN t_denisa_louzilova_project_sql_primary_final p2
	ON p.industry_branch_name = p2.industry_branch_name
	AND p.payroll_year = p2.payroll_year + 1
ORDER BY p.industry_branch_name, year_p;

-- zobrazení klesajících mezd:
SELECT *
FROM (
SELECT DISTINCT
	p.industry_branch_name,
	p.industry_code,
	p2.payroll_year + 1 AS year_p,
	round( ( p.pay_value - p2.pay_value ) / p2.pay_value * 100, 2 ) AS pay_growth
FROM t_denisa_louzilova_project_sql_primary_final p
JOIN t_denisa_louzilova_project_sql_primary_final p2
	ON p.industry_branch_name = p2.industry_branch_name
	AND p.payroll_year = p2.payroll_year +1
ORDER BY p.industry_branch_name, year_p
) a
WHERE a.pay_growth < 0
GROUP BY a.industry_branch_name, a.year_p;

/*
Ve sledovaném období let 2006 - 2018 lze zaznamenat roky, kdy mzda klesala v mnoha odvětvích.
Nejčastěji v roce 2013.

Podle dat klesala mzda nejčastěji v odvětví Těžba a dobývání a to v letech 2009, 2013, 2014, 2016.
*/

-- nejvyšší pokles mezd:
SELECT *
FROM (
SELECT DISTINCT
	p.industry_branch_name,
	p.industry_code,
	p2.payroll_year + 1 AS year_p,
	round( ( p.pay_value - p2.pay_value ) / p2.pay_value * 100, 2 ) AS pay_growth
FROM t_denisa_louzilova_project_sql_primary_final p
JOIN t_denisa_louzilova_project_sql_primary_final p2
	ON p.industry_branch_name = p2.industry_branch_name
	AND p.payroll_year = p2.payroll_year +1
ORDER BY p.industry_branch_name, year_p
) a
WHERE a.pay_growth < 0
ORDER BY a.pay_growth;

/*
 * Nejvyšší pokles mzdy byl v odvětví Peněžnictví a pojišťovnictví v roce 2013 - o 8.91%.
 */

-- v těchto odvětvích byl zaznamenám meziroční pokles mezd (15 z 19 sledovaných odvětví):
SELECT DISTINCT
	a.industry_branch_name,
	a.industry_code
FROM (
SELECT DISTINCT
	p.industry_branch_name,
	p.industry_code,
	p2.payroll_year + 1 AS year_p,
	round( ( p.pay_value - p2.pay_value ) / p2.pay_value * 100, 2 ) AS pay_growth
FROM t_denisa_louzilova_project_sql_primary_final p
JOIN t_denisa_louzilova_project_sql_primary_final p2
	ON p.industry_branch_name = p2.industry_branch_name
	AND p.payroll_year = p2.payroll_year +1
ORDER BY p.industry_branch_name, year_p
) a
WHERE a.pay_growth < 0;

-- pomocná tabulka pro uložení poklesu mezd:
CREATE OR REPLACE VIEW v_pokles_mezd AS
SELECT DISTINCT
	a.industry_branch_name,
	a.industry_code
FROM (
SELECT DISTINCT
	p.industry_branch_name,
	p.industry_code,
	p2.payroll_year + 1 AS year_p,
	round( ( p.pay_value - p2.pay_value ) / p2.pay_value * 100, 2 ) AS pay_growth
FROM t_denisa_louzilova_project_sql_primary_final p
JOIN t_denisa_louzilova_project_sql_primary_final p2
	ON p.industry_branch_name = p2.industry_branch_name
	AND p.payroll_year = p2.payroll_year +1
ORDER BY p.industry_branch_name, year_p
) a
WHERE a.pay_growth < 0
GROUP BY a.industry_branch_name, a.year_p;


-- odvětví, ve kterých nedošlo k poklesu mezd v letech 2006-2018:
SELECT DISTINCT
	tp.industry_branch_name
FROM t_denisa_louzilova_project_sql_primary_final tp
WHERE tp.industry_branch_name NOT IN(
		SELECT vpm.industry_branch_name
		FROM v_pokles_mezd vpm
);

/*
 * Závěr: Přestože mzdy meziročně stoupají, v některých letech se s alespoň mírným poklesem mzdy setká většina odvětví.
 */
