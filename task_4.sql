/*добавьте сюда запрос для решения задания 4*/
CREATE VIEW cafe.pizzerias_with_most_pizzas AS
WITH pizza_counts AS (
    SELECT
        r.cafe_name AS "Название заведения",
        COUNT(*) AS "Количество пицц в меню"
    FROM
        cafe.restaurants r,
        jsonb_each_text(r.menu->'Пицца') AS pizza_items
    WHERE
        r.type = 'pizzeria'
    GROUP BY
        r.cafe_name
),
ranked_pizzerias AS (
    SELECT
        "Название заведения",
        "Количество пицц в меню",
        DENSE_RANK() OVER (ORDER BY "Количество пицц в меню" DESC) AS rank
    FROM
        pizza_counts
)
SELECT
    "Название заведения",
    "Количество пицц в меню"
FROM
    ranked_pizzerias
WHERE
    rank = 1
ORDER BY
    "Название заведения";
