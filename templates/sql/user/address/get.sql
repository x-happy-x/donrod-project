SELECT
  *
FROM
  address
WHERE
  user = '{% user_id %}' AND state >= 1