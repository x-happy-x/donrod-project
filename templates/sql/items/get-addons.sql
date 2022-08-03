SELECT items_addons.id,
       item,
       addon,
       items_addons.type,
       group_id,
       a.name,
       a.price,
       a.type as addon_type
FROM items_addons LEFT JOIN addons a on a.id = items_addons.addon
WHERE item IN ({% items %});