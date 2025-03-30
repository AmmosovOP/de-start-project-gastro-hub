/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/
INSERT INTO cafe.restaurants (cafe_name, type, menu)
SELECT 
    DISTINCT s.cafe_name,
    s.type::cafe.restaurant_type,
    m.menu
FROM 
    raw_data.sales s
JOIN 
    raw_data.menu m ON s.cafe_name = m.cafe_name;

INSERT INTO cafe.managers (full_name, phone)
SELECT 
    DISTINCT s.manager,
    s.manager_phone
FROM 
    raw_data.sales s
WHERE 
    s.manager IS NOT NULL;

INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT 
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS start_date,
    MAX(s.report_date) AS end_date
FROM 
    raw_data.sales s
JOIN 
    cafe.restaurants r ON s.cafe_name = r.cafe_name
JOIN 
    cafe.managers m ON s.manager = m.full_name AND s.manager_phone = m.phone
GROUP BY 
    r.restaurant_uuid, m.manager_uuid;

INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT 
    s.report_date,
    r.restaurant_uuid,
    s.avg_check
FROM 
    raw_data.sales s
JOIN 
    cafe.restaurants r ON s.cafe_name = r.cafe_name;
