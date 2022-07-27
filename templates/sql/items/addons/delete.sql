DELETE FROM
  items_addons
WHERE
  item = {% item %}
  AND group_id = {% group %}