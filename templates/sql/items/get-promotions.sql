SELECT
  ia.id as item,
  promotions.*
FROM
  promotions
  LEFT JOIN items_promotions ip on promotions.id = ip.promotion
  LEFT JOIN items_addons ia on ia.id = ip.item
WHERE
  ia.item IN ({% items %})
  AND promotions.state >= 1
  AND (
    worked_from_time <= NOW() 
    OR worked_from_time IS NULL
  )
  AND (
    worked_to_time > NOW() 
    OR worked_to_time IS NULL
  )