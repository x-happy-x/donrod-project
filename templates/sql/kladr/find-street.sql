SELECT
    CONCAT(
        state_id,
        '.',
        area_id,
        '.',
        city_id,
        '.',
        locality_id,
        '.',
        street_id,
        '.0000'
    ) AS code,
    street_name AS real_name,
    CASE
        WHEN locality_name <> '-' AND '{% locality_id %}' = '---' THEN CONCAT_WS(', ', REPLACE(template, '%', street_name), locality_name)
        WHEN city_name <> '-' AND '{% city_id %}' = '---' THEN CONCAT_WS(', ', REPLACE(template, '%', street_name), city_name)
        WHEN area_name <> '-' AND '{% area_id %}' = '---' THEN CONCAT_WS(', ', REPLACE(template, '%', street_name), area_name)
        WHEN state_name <> '-' AND '{% state_id %}' = '--' THEN CONCAT_WS(', ', REPLACE(template, '%', street_name), state_name)
        ELSE REPLACE(template, '%', street_name)
    END AS name,
    full_type as type
FROM
    {% address_db %}.states NATURAL
    JOIN {% address_db %}.areas NATURAL
    JOIN {% address_db %}.cities NATURAL
    JOIN {% address_db %}.localities NATURAL
    JOIN {% address_db %}.streets LEFT JOIN {% address_db %}.short_types ON type = street_type
WHERE
    (
        street_id LIKE '{% street_id %}'
        OR '{% street_id %}' = '----'
        AND (
            street_name LIKE '%{% text %}%'
            OR street_type LIKE '%{% text %}%'
            OR CONCAT(street_name, ' ', street_type) LIKE '%{% text %}%'
            OR CONCAT(street_type, ' ', street_name) LIKE '%{% text %}%'
        )
        AND (
            '0000' = '{% street_id %}'
            OR street_id <> '0000'
        )
    )
    AND (
        state_id LIKE '{% state_id %}'
        OR '{% state_id %}' = '--'
    )
    AND (
        area_id LIKE '{% area_id %}'
        OR '{% area_id %}' = '---'
    )
    AND (
        city_id LIKE '{% city_id %}'
        OR '{% city_id %}' = '---'
    )
    AND (
        locality_id LIKE '{% locality_id %}'
        OR '{% locality_id %}' = '---'
    )
ORDER BY
    CASE
        WHEN real_name LIKE '{% text %}' THEN 0
        WHEN real_name LIKE '{% text %}%' THEN 1
        WHEN type LIKE '{% text %}%' THEN 2
        ELSE 3 
    END ASC, CHAR_LENGTH(real_name) ASC
LIMIT
    {% limit %}