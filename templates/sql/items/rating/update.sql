UPDATE
  items_rating
SET
  rating = {% rating %}
WHERE
  user = {% user %}
  AND item = {% item %}