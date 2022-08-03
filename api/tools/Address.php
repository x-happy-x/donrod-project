<?php

namespace api\tools;

class Address
{
    public static function get_full(Database $db, string $code, string $address_db, array $find_types) {
        $code = explode('.', $code);
        $data = [];
        $data['address_db'] = $address_db;
        for ($i = 0; $i < count($find_types); $i++) {
            $data[$find_types[$i] . '_id'] = $code[$i];
        }
        $find_list = [];
        foreach ($find_types as $i)
            $find_list[] = "kladr/find-" . trim($i);
        return $db->union_run($find_list, $data, query_line: "SELECT name FROM (({% unions %})) T WHERE name <> '-'")->fetch_all(MYSQLI_ASSOC);
    }
}