SELECT
  COUNT(house_id)
FROM
  {% address_db %}.houses
WHERE
  state_id = '{% state_id %}'
  and area_id = '{% area_id %}'
  and city_id = '{% city_id %}'
  and locality_id = '{% locality_id %}'
  and street_id = '{% street_id %}'
  and house_id = '{% house_id %}'