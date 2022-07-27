SELECT
  *
FROM
  users
WHERE
  mail = '{% mail %}'
  AND pass = '{% pass %}'