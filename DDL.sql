/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/
CREATE SCHEMA IF NOT EXISTS cafe;

--типы ресторанов
CREATE TYPE cafe.restaurant_type AS ENUM 
    ('coffee_shop', 'restaurant', 'bar', 'pizzeria');
--таблица ресторанов
CREATE TABLE cafe.restaurants (
    restaurant_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cafe_name VARCHAR(255) NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu JSONB NOT NULL
);
--таблица менеджеров
CREATE TABLE cafe.managers (
    manager_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL
);
--график работы менеджеров
CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid UUID NOT NULL,
    manager_uuid UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (restaurant_uuid, manager_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
    FOREIGN KEY (manager_uuid) REFERENCES cafe.managers(manager_uuid),
    CHECK (end_date IS NULL OR start_date <= end_date)
);
--таблица продаж
CREATE TABLE cafe.sales (
    date DATE NOT NULL,
    restaurant_uuid UUID NOT NULL,
    avg_check NUMERIC(6, 2) NOT NULL,
    PRIMARY KEY (date, restaurant_uuid),
    FOREIGN KEY (restaurant_uuid) REFERENCES cafe.restaurants(restaurant_uuid),
    CHECK (avg_check > 0)
);
