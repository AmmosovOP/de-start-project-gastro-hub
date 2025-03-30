/*добавьте сюда запрос для решения задания 1*/
CREATE VIEW cafe.top_restaurants AS
WITH avg_checks AS (
    SELECT 
        r.cafe_name AS "Название заведения",
        r.type AS "Тип заведения",
        ROUND(AVG(s.avg_check), 2) AS "Средний чек",
        RANK() OVER (PARTITION BY r.type ORDER BY AVG(s.avg_check) DESC) AS rank
    FROM 
        cafe.sales s
    JOIN 
        cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    GROUP BY 
        r.cafe_name, r.type
)
SELECT 
    "Название заведения",
    "Тип заведения",
    "Средний чек"
FROM 
    avg_checks
WHERE 
    rank <= 3
ORDER BY 
    "Тип заведения",
    "Средний чек" DESC;
