/*
 * Příprava dat pro projekt - porovnání s evropskými státy
 */
CREATE TABLE t_denisa_louzilova_project_SQL_secondary_final AS
SELECT
	c.country,
	e.`year`,
	e.GDP,
	e.gini,
	e.taxes,
	e.population
FROM countries c
JOIN economies e
	ON c.country = e.country
WHERE c.continent = 'Europe'
	AND e.`year` BETWEEN 2006 AND 2018
ORDER BY c.country, e.`year`;


