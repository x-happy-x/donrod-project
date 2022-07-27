UPDATE
  items
SET
  name = '{% name %}',
  description = '{% description %}',
  count = {% count %},
  price = {% price %},
  weight = {% weight %},
  unit = '{% unit %}',
  status = {% status %},
  update_time = NOW()
WHERE
  id = {% id %}