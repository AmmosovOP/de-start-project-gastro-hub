/*добавьте сюда запрос для решения задания 2*/
CREATE MATERIALIZED VIEW cafe.yearly_avg_check_changes AS
WITH yearly_avg AS (
    SELECT
        EXTRACT(YEAR FROM s.date)::INT AS year,
        r.cafe_name AS "Название заведения",
        r.type AS "Тип заведения",
        ROUND(AVG(s.avg_check), 2) AS avg_check
    FROM
        cafe.sales s
    JOIN
        cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    WHERE
        EXTRACT(YEAR FROM s.date) != 2023  -- Исключаем 2023 год
    GROUP BY
        year, r.cafe_name, r.type
)
SELECT
    current.year AS "Год",
    current."Название заведения",
    current."Тип заведения",
    current.avg_check AS "Средний чек в текущем году",
    prev.avg_check AS "Средний чек в предыдущем году",
    CASE
        WHEN prev.avg_check IS NULL THEN NULL
        ELSE ROUND(((current.avg_check - prev.avg_check) / prev.avg_check * 100), 2)
    END AS "Изменение среднего чека в %"
FROM
    yearly_avg current
LEFT JOIN
    yearly_avg prev ON current."Название заведения" = prev."Название заведения"
                    AND current.year = prev.year + 1
ORDER BY
    current."Название заведения",
    current.year;
