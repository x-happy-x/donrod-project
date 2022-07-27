insert into cart (user, count) VALUES ({% user_id %}, {% count %});
insert into
    cart_addons (cart, item_addon)
SELECT
    LAST_INSERT_ID(),
    addon
FROM
    ({% addons %}) v;