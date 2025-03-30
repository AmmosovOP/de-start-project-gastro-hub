/*добавьте сюда запросы для решения задания 6*/
BEGIN;

WITH cafes_with_cappuccino AS (
    SELECT r.restaurant_uuid
    FROM cafe.restaurants r
    WHERE r.menu->'Напитки' ? 'Капучино'
    FOR UPDATE OF r  
)

UPDATE cafe.restaurants r
SET menu = jsonb_set(
    menu,
    '{Напитки,Капучино}',
    to_jsonb(ROUND((menu->'Напитки'->>'Капучино')::numeric * 1.2, 2)::text::jsonb
)
WHERE r.restaurant_uuid IN (
    SELECT restaurant_uuid FROM cafes_with_cappuccino
);

COMMIT;
