SELECT
  cart.*,
  GROUP_CONCAT(ca.item_addon) as addons
FROM
  cart
  LEFT JOIN cart_addons ca on cart.id = ca.cart
WHERE
  user = {% user_id %} AND state >= 1
GROUP BY
  cart.id