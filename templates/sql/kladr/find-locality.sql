SELECT
    CONCAT(
        state_id,
        '.',
        area_id,
        '.',
        city_id,
        '.', locality_id,'.0000.0000'
    ) AS code,
    locality_name AS real_name,
    CASE
        WHEN city_name <> '-' AND '{% city_id %}' = '---' THEN CONCAT_WS(', ', REPLACE(template, '%', locality_name), city_name)
        WHEN area_name <> '-' AND '{% area_id %}' = '---' THEN CONCAT_WS(', ', REPLACE(template, '%', locality_name), area_name)
        WHEN state_name <> '-' AND '{% state_id %}' = '--' THEN CONCAT_WS(', ', REPLACE(template, '%', locality_name), state_name)
        ELSE REPLACE(template, '%', locality_name)
    END AS name,
    full_type AS type
FROM
    {% address_db %}.states NATURAL
    JOIN {% address_db %}.areas NATURAL
    JOIN {% address_db %}.cities NATURAL
    JOIN {% address_db %}.localities LEFT JOIN {% address_db %}.short_types ON type = locality_type
WHERE
    (
        locality_id LIKE '{% locality_id %}'
        OR '{% locality_id %}' = '---'
        AND (
            locality_name LIKE '%{% text %}%'
            OR locality_type LIKE '%{% text %}%'
            OR CONCAT(locality_name, ' ', locality_type) LIKE '%{% text %}%'
            OR CONCAT(locality_type, ' ', locality_name) LIKE '%{% text %}%'
        )
        AND (
            '000' = '{% locality_id %}'
            OR locality_id <> '000'
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
ORDER BY
    CASE
        WHEN real_name LIKE '{% text %}' THEN 0
        WHEN real_name LIKE '{% text %}%' THEN 1
        WHEN type LIKE '{% text %}%' THEN 2
        ELSE 3 
    END ASC, CHAR_LENGTH(real_name) ASC
LIMIT
    {% limit %}