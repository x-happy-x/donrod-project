SELECT
  buylist.*,
  GROUP_CONCAT(ca.item_addon) as addons
FROM
  buylist
  LEFT JOIN cart_addons ca on buylist.cart_id = ca.cart
WHERE
  order_id IN ({% orders %})
GROUP BY
  buylist.cart_id