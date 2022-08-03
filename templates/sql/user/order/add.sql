INSERT INTO
  orders (user, take_date, address, price, discounts)
values
  ({% user %}, '{% date %}', {% address %}, {% price %}, {% promo %});
INSERT INTO buylist (order_id, cart_id, count, price, create_time)
SELECT LAST_INSERT_ID(),
       cart.id,
       cart.count,
       i.price + SUM(case
                         when a.type = '%' THEN i.price / 100 * a.price
                         when a.type = 'money' THEN a.price
           ENd)
           as price,
       cart.create_time
FROM cart
         LEFT OUTER JOIN cart_addons ca on cart.id = ca.cart
         LEFT JOIN items_addons ia on ia.id = ca.item_addon
         LEFT JOIN addons a ON a.id = ia.addon
         LEFT JOIN items i on i.id = ia.item
WHERE cart.user = {% user %}
  AND cart.state >= 1
GROUP BY cart.id;
UPDATE
    items,
    cart,
    cart_addons,
    items_addons
SET 
    items.count = items.count - cart.count
WHERE
    cart.user = {% user %}
    AND cart.state >= 1
    AND cart.id = cart_addons.cart
    AND cart_addons.item_addon = items_addons.id
    AND items_addons.item = items.id;
UPDATE
    cart
SET 
    state = -1
WHERE
    user = {% user %} AND state >= 1