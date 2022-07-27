SELECT
    CONCAT(
        state_id,
        '.',
        area_id,
        '.',
        city_id,
        '.000.0000.0000'
    ) AS code,
    city_name AS real_name,
    CASE
        WHEN area_name <> '-' AND '{% area_id %}' = '---' THEN CONCAT_WS(', ', REPLACE(template, '%', city_name), area_name)
        WHEN state_name <> '-' AND '{% state_id %}' = '--' THEN CONCAT_WS(', ', REPLACE(template, '%', city_name), state_name)
        ELSE REPLACE(template, '%', city_name)
    END AS name,
    full_type AS type
FROM
    {% address_db %}.states NATURAL
    JOIN {% address_db %}.areas NATURAL
    JOIN {% address_db %}.cities  LEFT JOIN {% address_db %}.short_types ON type = city_type
WHERE
    (
        city_id LIKE '{% city_id %}'
        OR '{% city_id %}' = '---'
        AND (
            city_name LIKE '%{% text %}%'
            OR city_type LIKE '%{% text %}%'
            OR CONCAT(city_name, ' ', city_type) LIKE '%{% text %}%'
            OR CONCAT(city_type, ' ', city_name) LIKE '%{% text %}%'
        )
        AND (
            '000' = '{% city_id %}'
            OR city_id <> '000'
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
ORDER BY
    CASE
        WHEN real_name LIKE '{% text %}' THEN 0
        WHEN real_name LIKE '{% text %}%' THEN 1
        WHEN type LIKE '{% text %}%' THEN 2
        ELSE 3 
    END ASC, CHAR_LENGTH(real_name) ASC
LIMIT
    {% limit %}