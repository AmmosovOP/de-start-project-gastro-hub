/*добавьте сюда запрос для решения задания 3*/
CREATE VIEW cafe.top_restaurants_by_manager_changes AS
WITH manager_changes AS (
    SELECT
        r.cafe_name AS "Название заведения",
        COUNT(DISTINCT w.manager_uuid) AS manager_count
    FROM
        cafe.restaurant_manager_work_dates w
    JOIN
        cafe.restaurants r ON w.restaurant_uuid = r.restaurant_uuid
    GROUP BY
        r.cafe_name
)
SELECT
    "Название заведения",
    manager_count - 1 AS "Сколько раз менялся менеджер"
FROM
    manager_changes
ORDER BY
    "Сколько раз менялся менеджер" DESC
LIMIT 3; 
