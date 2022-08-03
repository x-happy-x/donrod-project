INSERT
  IGNORE INTO item_categories (item, category)
VALUES
  ({% item %}, {% category %});
UPDATE
  item_categories
SET
  category = {% category %}
WHERE
  item = {% item %};