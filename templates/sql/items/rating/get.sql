SELECT
  rating
FROM
  items_rating
WHERE
  user = {% user %}
  AND item = {% item %}