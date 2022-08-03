UPDATE
  cart
SET
  count = {% count %},
  update_time = NOW()
WHERE
  id = {% cart %}