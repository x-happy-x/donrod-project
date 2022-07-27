SELECT
    CONCAT(state_id, '.', area_id, '.000.000.0000.0000') AS code,
    area_name AS real_name,
    CASE
        WHEN state_name <> '-' AND '{% state_id %}' = '--' THEN CONCAT_WS(', ', REPLACE(template, '%', area_name), state_name)
        ELSE REPLACE(template, '%', area_name)
    END AS name,
    full_type AS type
FROM
    {% address_db %}.states NATURAL
    JOIN {% address_db %}.areas LEFT JOIN {% address_db %}.short_types ON type = area_type
WHERE
    (
        area_id LIKE '{% area_id %}'
        OR '{% area_id %}' = '---'
        AND (
            area_name LIKE '%{% text %}%'
            OR area_type LIKE '%{% text %}%'
            OR CONCAT(area_name, ' ', area_type) LIKE '%{% text %}%'
            OR CONCAT(area_type, ' ', area_name) LIKE '%{% text %}%'
        )
        AND (
            '000' = '{% area_id %}'
            OR area_id <> '000'
        )
    )
    AND (
        state_id LIKE '{% state_id %}'
        OR '{% state_id %}' = '--'
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