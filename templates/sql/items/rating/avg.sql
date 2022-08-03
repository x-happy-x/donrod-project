SELECT
  AVG(rating), Count(*)
FROM
  items_rating
WHERE
  item = {% item %}