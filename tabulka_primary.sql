/*
 * Příprava dat pro projekt
 * 
 * czechia payroll(+ další relevantní tabulky) a czechia_price(+ další relevantní tabulky)
 */

CREATE OR REPLACE INDEX czechia_payroll__value__index ON czechia_payroll(value);

CREATE OR REPLACE TABLE t_denisa_louzilova_project_SQL_primary_final AS
SELECT *
FROM (
	SELECT
		cv.name AS value_name,
		round(avg(c.value), 2) AS pay_value,
		cu.name AS unit_type,
		c.payroll_year,
		ci.name AS industry_branch_name,
		ci.code AS industry_code
	FROM czechia_payroll c
	LEFT JOIN czechia_payroll_industry_branch ci
		ON c.industry_branch_code = ci.code
	LEFT JOIN czechia_payroll_unit cu 
		ON c.unit_code = cu.code
	LEFT JOIN czechia_payroll_value_type cv
		ON c.value_type_code = cv.code
	WHERE c.value IS NOT NULL
		AND industry_branch_code IS NOT NULL
		AND cv.code = 5958
	GROUP BY industry_branch_name, c.payroll_year DESC
) a
JOIN (
	SELECT
		cpc.name AS food_name,
		cpc.code AS food_code,
		round(avg(cp.value), 2) AS price,
		cpc.price_value,
		cpc.price_unit,
		YEAR(cp.date_from) AS year_date
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code
  GROUP BY year_date, food_name
  ORDER BY cp.category_code, year_date DESC
) b
ON a.payroll_year = b.year_date;


-- zjištění uvedených roků v tabulce pomocí group by : 2006 - 2018
SELECT *
FROM (
	SELECT
		cv.name AS value_name,
		avg(c.value) AS pay_value,
		cu.name AS unit_type,
		c.payroll_year,
		ci.name AS industry_branch_name,
		ci.code AS industry_code
	FROM czechia_payroll c
	LEFT JOIN czechia_payroll_industry_branch ci
		ON c.industry_branch_code = ci.code
	LEFT JOIN czechia_payroll_unit cu 
		ON c.unit_code = cu.code
	LEFT JOIN czechia_payroll_value_type cv
		ON c.value_type_code = cv.code
	WHERE c.value IS NOT NULL
		AND industry_branch_code IS NOT NULL
		AND cv.code = 5958
	GROUP BY industry_branch_name, c.payroll_year DESC
) a
JOIN (
	SELECT
		cpc.name AS food_name,
		cpc.code AS food_code,
		round(avg(cp.value), 2) AS price,
		cpc.price_value,
		cpc.price_unit,
		YEAR(cp.date_from) AS year_date
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code
  GROUP BY year_date, food_name
  ORDER BY cp.category_code, year_date DESC
) b
ON a.payroll_year = b.year_date
GROUP BY a.industry_branch_name, a.payroll_year;

-- kontrola subselectů:
	SELECT
		cv.name AS value_name,
		round(avg(c.value), 2) AS pay_value,
		cu.name AS unit_type,
		c.payroll_year,
		ci.name AS industry_branch_name,
		ci.code AS industry_code
	FROM czechia_payroll c
	LEFT JOIN czechia_payroll_industry_branch ci
		ON c.industry_branch_code = ci.code
	LEFT JOIN czechia_payroll_unit cu 
		ON c.unit_code = cu.code
	LEFT JOIN czechia_payroll_value_type cv
		ON c.value_type_code = cv.code
	WHERE c.value IS NOT NULL
		AND industry_branch_code IS NOT NULL
		AND cv.code = 5958
	GROUP BY industry_branch_name, c.payroll_year DESC;
	
	SELECT
		cpc.name AS food_name,
		cpc.code AS food_code,
		round(avg(cp.value), 2) AS price,
		cpc.price_value,
		cpc.price_unit,
		YEAR(cp.date_from) AS year_date
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code
  GROUP BY year_date, food_name
  ORDER BY cp.category_code, year_date DESC;