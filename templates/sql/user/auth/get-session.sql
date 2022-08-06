SELECT
  users.*, auth.id AS session
FROM
  users
  LEFT JOIN auth ON users.id = auth.user
WHERE
  token = '{% token %}'