UPDATE
    cart, cart_addons, items_addons, items
SET cart.count = items.count
WHERE cart.id = cart_addons.cart
  AND cart_addons.item_addon = items_addons.id
  AND items_addons.item = items.id
  AND cart.user = {% user_id %}
  AND cart.count > items.count