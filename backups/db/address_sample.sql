create table short_types
(
    short_types_id int auto_increment,
    type           varchar(30)  not null,
    full_type      varchar(200) null,
    template       varchar(300) null,
    primary key (short_types_id, type),
    constraint short_types_short_types_id_uindex
        unique (short_types_id),
    constraint short_types_type_uindex
        unique (type)
)
    collate = utf8mb4_general_ci;

create table states
(
    state_id   varchar(2)   not null
        primary key,
    state_name varchar(150) not null,
    state_type varchar(50)  null
)
    collate = utf8mb4_general_ci;

create table areas
(
    area_id   varchar(3)   not null,
    area_name varchar(150) null,
    area_type varchar(50)  null,
    state_id  varchar(2)   not null,
    constraint areas_pk
        unique (area_id, state_id),
    constraint areas_states_id_fk
        foreign key (state_id) references states (state_id)
)
    collate = utf8mb4_general_ci;

create table cities
(
    city_id   varchar(3)   not null,
    city_name varchar(150) null,
    city_type varchar(50)  null,
    area_id   varchar(3)   not null,
    state_id  varchar(2)   not null,
    primary key (city_id, area_id, state_id),
    constraint cities_areas_id_fk
        foreign key (area_id) references areas (area_id),
    constraint cities_states_id_fk
        foreign key (state_id) references states (state_id)
)
    collate = utf8mb4_general_ci;

create table localities
(
    locality_id   varchar(3)   not null,
    locality_name varchar(150) null,
    locality_type varchar(50)  null,
    city_id       varchar(3)   not null,
    area_id       varchar(3)   not null,
    state_id      varchar(2)   not null,
    primary key (locality_id, city_id, area_id, state_id),
    constraint locality_areas_id_fk
        foreign key (area_id) references areas (area_id),
    constraint locality_cities_id_fk
        foreign key (city_id) references cities (city_id),
    constraint locality_states_id_fk
        foreign key (state_id) references states (state_id)
)
    collate = utf8mb4_general_ci;

create table streets
(
    street_id   varchar(4)   not null,
    street_name varchar(150) null,
    street_type varchar(50)  null,
    locality_id varchar(3)   not null,
    city_id     varchar(3)   not null,
    area_id     varchar(3)   not null,
    state_id    varchar(2)   not null,
    primary key (street_id, locality_id, city_id, area_id, state_id),
    constraint streets_areas_id_fk
        foreign key (area_id) references areas (area_id),
    constraint streets_cities_id_fk
        foreign key (city_id) references cities (city_id),
    constraint streets_locality_id_fk
        foreign key (locality_id) references localities (locality_id),
    constraint streets_states_id_fk
        foreign key (state_id) references states (state_id)
)
    collate = utf8mb4_general_ci;

create table houses
(
    house_id    varchar(4)   not null,
    house_name  varchar(150) not null,
    house_index varchar(6)   null,
    street_id   varchar(4)   not null,
    locality_id varchar(3)   not null,
    city_id     varchar(3)   not null,
    area_id     varchar(3)   not null,
    state_id    varchar(3)   not null,
    primary key (house_id, house_name, street_id, city_id, area_id, state_id, locality_id),
    constraint houses_areas_area_id_fk
        foreign key (area_id) references areas (area_id)
            on update cascade on delete cascade,
    constraint houses_cities_city_id_fk
        foreign key (city_id) references cities (city_id)
            on update cascade on delete cascade,
    constraint houses_localities_locality_id_fk
        foreign key (locality_id) references localities (locality_id)
            on update cascade on delete cascade,
    constraint houses_states_state_id_fk
        foreign key (state_id) references states (state_id)
            on update cascade on delete cascade,
    constraint houses_streets_street_id_fk
        foreign key (street_id) references streets (street_id)
            on update cascade on delete cascade
)
    collate = utf8mb4_general_ci;