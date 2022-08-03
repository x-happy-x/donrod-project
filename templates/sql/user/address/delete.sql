UPDATE
  address
SET
  state = 0
WHERE
  user = {% user %}
  AND id = {% id %}