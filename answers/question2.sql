/*
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 * 
 * chléb code = 111301
 * mléko code = 114201
 * 
 * rok 2006 a 2018
 */

SELECT
	industry_branch_name,
	payroll_year,
	food_name,
	round(pay_value/price, 2) AS food_amount,
	price_unit,
	price,
	pay_value,
	unit_type
FROM t_denisa_louzilova_project_sql_primary_final tp
WHERE food_code IN (111301, 114201)
	AND year_date IN (2006, 2018)
ORDER BY industry_branch_name, food_name, payroll_year;

/*
průměr kupní síly v ČR bez ohledu na odvětví: průměrný občan si mohl dovolit nakoupit
více mléka i chleba, nicméně cena chleba rostla více než u mléka
 */
SELECT
	payroll_year,
	food_name,
	round(avg(food_amount), 2)AS food_amount_final,
	price_unit,
	price,
	unit_type
FROM (
	SELECT
		payroll_year,
		food_name,
		round(pay_value/price, 2) AS food_amount,
		price_unit,
		price,
		pay_value,
		unit_type
	FROM t_denisa_louzilova_project_sql_primary_final tp
	WHERE food_code IN (111301, 114201)
		AND year_date IN (2006, 2018)
	ORDER BY food_name, payroll_year
) a
GROUP BY food_name, payroll_year;

/*
 * Závěrem:
 * 
 * Množství cen potravin, které lze nakoupit za srovnatelná období, je závislé na růstu cen potravin a zvyšování mezd.
 * Počítáme-li s průměrnou mzdou, můžeme usoudit, že zaměstnanci většiny(ne všech) sledovaných odvětví si v roce 2018 
 * mohli nakoupit více potravin než v roce 2006.
 *
 * Pokud počítáme s celorepublikovým průměrem mezd, můžeme říct, že v roce 2006 si zaměstnanci ČR mohli dovolit koupit 1287,5 kg chleba,
 * zatímco v roce 2018 to bylo 1342,2 kg chleba. U mléka byl nárůst ještě vyšší - v roce 2006 bylo možné koupit 1437,2 l mléka 
 * a v roce 2018 to bylo již 1641,6 l mléka.
 */
 
