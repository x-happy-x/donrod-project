SELECT
  *
FROM
  address
WHERE
  user = '{% user_id %}' AND id = {% id %} AND state >= 1