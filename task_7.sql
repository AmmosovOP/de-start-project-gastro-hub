/*добавьте сюда запросы для решения задания 6*/
BEGIN;

LOCK TABLE cafe.managers IN SHARE ROW EXCLUSIVE MODE;

ALTER TABLE cafe.managers 
ADD COLUMN phones TEXT[];

WITH numbered_managers AS (
    SELECT
        manager_uuid,
        full_name,
        phone,
        ROW_NUMBER() OVER (ORDER BY full_name) + 99 AS manager_num
    FROM
        cafe.managers
)
UPDATE cafe.managers m
SET 
    phones = ARRAY[
        CONCAT('8-800-2500-', nm.manager_num),  
        nm.phone                                 
    ]
FROM 
    numbered_managers nm
WHERE 
    m.manager_uuid = nm.manager_uuid;
ALTER TABLE cafe.managers 
DROP COLUMN phone;
COMMIT;
