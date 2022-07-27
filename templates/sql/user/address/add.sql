insert into
  address (
    user,
    address_code,
    manyfloors,
    dcode,
    apartment,
    entrance,
    note,
    floor,
    house
  )
values
  (
    {% user_id %},
    '{% state_id %}.{% area_id %}.{% city_id %}.{% locality_id %}.{% street_id %}.{% house_id %}',
    {% manyfloors %},
    {% dcode %},
    {% apartment %},
    {% entrance %},
    '{% note %}',
    {% floor %},
    '{% house %}'
  );