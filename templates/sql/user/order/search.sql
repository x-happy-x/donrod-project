SELECT
  orders.*,
  os.name,
  a.id as address_id,
  a.address_code,
  a.manyfloors,
  a.dcode,
  a.apartment,
  a.entrance,
  a.note,
  a.floor,
  a.house
FROM
  orders
  LEFT JOIN order_state os on os.id = orders.state
  LEFT JOIN address a on orders.address = a.id
WHERE
    {% where %}
ORDER BY
  orders.state, orders.id DESC
LIMIT {% offset %}, {% limit %}