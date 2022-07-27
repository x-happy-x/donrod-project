SELECT ia.id as addon, a.name as addon_name, i.*
FROM items_addons ia
         LEFT JOIN items i on i.id = ia.item
         LEFT JOIN addons a on a.id = ia.addon
WHERE ia.id IN ({% addons %})