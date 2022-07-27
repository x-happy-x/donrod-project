SELECT
    i.id,
    i.count,
    i.count - ifnull(sum(c.count),0) as current
FROM
    items i
    LEFT JOIN items_addons ia on i.id = ia.item
    LEFT JOIN cart_addons ca on ia.id = ca.item_addon
    LEFT JOIN (
        select
            *
        from
            cart
        where
            user = {% user_id %} AND state >= 1
    ) c on c.id = ca.cart
GROUP BY
    i.id
HAVING
    i.id = {% item %}