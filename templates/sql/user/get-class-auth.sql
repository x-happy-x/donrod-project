SELECT
  id,
  name,
  auth_available
FROM
  user_class
WHERE
  auth_available >= 1 AND {% id %}