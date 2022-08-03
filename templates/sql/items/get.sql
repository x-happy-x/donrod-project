SELECT
    item_categories.category,
    AVG(ir.rating) as rating,
    (
        SELECT
            rating
        FROM
            items_rating
        WHERE
            user = {% user %}
            AND item = items.id
    ) as myrating,
    (
        SELECT 
            count(*) 
        FROM 
            items_rating 
        WHERE 
            item = items.id
    ) as countrating,
    items.*
FROM
    items
    LEFT JOIN item_categories ON item_categories.item = items.id
    LEFT JOIN items_rating ir on items.id = ir.item
WHERE
    {% where %} AND items.status != 0
GROUP BY
    items.id