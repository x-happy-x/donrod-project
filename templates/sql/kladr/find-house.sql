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
        '.', house_id
    ) AS code,
    house_name AS real_name,
    CASE
        WHEN street_name <> '-' AND '{% street_id %}' = '---' THEN CONCAT_WS(', ', house_name, street_name)
        ELSE house_name
    END AS name,
    'Дом' AS type
FROM
    {% address_db %}.states NATURAL
    JOIN {% address_db %}.areas NATURAL
    JOIN {% address_db %}.cities NATURAL
    JOIN {% address_db %}.localities NATURAL
    JOIN {% address_db %}.streets NATURAL
    JOIN {% address_db %}.houses
WHERE
    (
        house_id LIKE '{% house_id %}'
        OR '{% house_id %}' = '----'
        AND (
            house_name LIKE '%{% text %}%'
        )
        AND (
            '0000' = '{% house_id %}'
            OR house_id <> '0000'
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
    AND (
        street_id LIKE '{% street_id %}'
        OR '{% street_id %}' = '----'
    )
ORDER BY
    CASE
        WHEN real_name LIKE '{% text %}' THEN 0
        WHEN real_name LIKE '{% text %}%' THEN 1
        ELSE 3 
    END ASC, CHAR_LENGTH(real_name) ASC
LIMIT
    {% limit %}