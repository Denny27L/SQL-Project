/*
 * 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */

-- výpočet meziročního nárustu cen potravin v letech:
CREATE OR REPLACE VIEW v_food_growth AS
SELECT
	tp.food_name,
	tp2.year_date + 1 AS year_2,
	tp.price,
	tp.unit_type,
	round(( tp.price - tp2.price ) / tp2.price * 100, 2 ) AS price_growth,
	tp.price_value,
	tp.price_unit
FROM t_denisa_louzilova_project_sql_primary_final tp
JOIN t_denisa_louzilova_project_sql_primary_final tp2
	ON tp.food_code = tp2.food_code
	AND tp.year_date = tp2.year_date + 1
GROUP BY tp.food_name, year_2;


SELECT
	food_name,
	round(avg(price_growth), 2) AS price_gr
FROM v_food_growth vfg
GROUP BY food_name
ORDER BY price_gr;

/*
 * Závěr: 
 * Mezi lety 2006 a 2018 je nejnižší průměrný percentuální nárůst u potraviny CUKR KRYSTALOVÝ.
 */

