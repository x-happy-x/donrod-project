INSERT
  IGNORE INTO messages_read (message, user)
SELECT
  id,
  {% user %}
FROM
  messages
WHERE 
  user <> {% user %};
SELECT
  m.id,
  m.user,
  m.message,
  m.send_time,
  u.name,
  IF(COUNT(mr.id) = 0, false, true) AS 'read'
FROM
  messages m
  LEFT OUTER JOIN messages_read mr on m.id = mr.message
  LEFT JOIN users u on u.id = m.user
WHERE
  state >= 1
GROUP BY
  m.id
ORDER BY
  m.send_time
LIMIT
  {% limit %}