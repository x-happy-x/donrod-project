SELECT
    CONCAT(state_id, '.000.000.000.0000.0000') AS code,
    state_name AS real_name,
    REPLACE(template, '%', state_name) AS name,
    full_type as type
FROM
    {% address_db %}.states
    LEFT JOIN {% address_db %}.short_types ON type = state_type
WHERE
    state_id LIKE '{% state_id %}'
    OR '{% state_id %}' = '--'
    AND (
        state_name LIKE '%{% text %}%'
        OR state_type LIKE '%{% text %}%'
        OR CONCAT(state_name, ' ', state_type) LIKE '%{% text %}%'
        OR CONCAT(state_type, ' ', state_name) LIKE '%{% text %}%'
    )
ORDER BY
    CASE
        WHEN real_name LIKE '{% text %}' THEN 0
        WHEN real_name LIKE '{% text %}%' THEN 1
        WHEN type LIKE '{% text %}%' THEN 2
        ELSE 3 
    END ASC, CHAR_LENGTH(real_name) ASC
LIMIT {% limit %}