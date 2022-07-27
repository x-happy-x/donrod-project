SELECT
  Count(*)
FROM
  cart
WHERE
  user = {% user %}
  AND state >= 1