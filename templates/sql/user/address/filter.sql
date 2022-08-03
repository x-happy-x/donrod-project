SELECT
  *
FROM
  address_filter
WHERE
  '{% address %}' LIKE SUBSTR(address, 1, LENGTH('{% address %}'))
ORDER BY
  LENGTH(REPLACE(address,'%','')) DESC