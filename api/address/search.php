<?php

namespace api\address {

    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Control;
    use Error;

    // Подключение к базе и авторизация
    Control::start(true, true);
    $db = Control::$db;
    $user = Control::$user;
    $_ARG = Control::$_ARG;

    // Проверка доступа
    if (!$user->perm()->read('address')) {
        Control::noAccess('Вы не можете использовать поиск адресов');
    }

    $result = [];
    $result['success'] = 0;
    $result['message'] = "Не верные параметры";
    $result['datalist'] = [];

    if (!isset($_ARG['find'])) {
        echo json_encode($result, JSON_UNESCAPED_UNICODE);
        exit();
    }

    $finds = ['house', 'street', 'locality', 'city', 'area', 'state'];
    $find = $_ARG['find'];
    if (!in_array($find, $finds) && !str_contains($find, ',')) {
        echo json_encode($result, JSON_UNESCAPED_UNICODE);
        exit();
    }

    if (isset($_ARG['state_id']) && strlen($_ARG['state_id']) == 2 && is_numeric($_ARG['state_id']))
        $state_id = $_ARG['state_id'];
    else
        $state_id = '--';

    if (isset($_ARG['area_id']) && strlen($_ARG['area_id']) == 3 && is_numeric($_ARG['area_id']))
        $area_id = $_ARG['area_id'];
    else
        $area_id = '---';

    if (isset($_ARG['city_id']) && strlen($_ARG['city_id']) == 3 && is_numeric($_ARG['city_id']))
        $city_id = $_ARG['city_id'];
    else
        $city_id = '---';

    if (isset($_ARG['locality_id']) && strlen($_ARG['locality_id']) == 3 && is_numeric($_ARG['locality_id']))
        $locality_id = $_ARG['locality_id'];
    else
        $locality_id = '---';

    if (isset($_ARG['street_id']) && strlen($_ARG['street_id']) == 4 && is_numeric($_ARG['street_id']))
        $street_id = $_ARG['street_id'];
    else
        $street_id = '----';

    if (isset($_ARG['house_id']) && strlen($_ARG['house_id']) == 4 && is_numeric($_ARG['house_id']))
        $house_id = $_ARG['house_id'];
    else
        $house_id = '----';

    if (isset($_ARG['filter_street']) && strcmp($find, "street") === 0 && strcmp($area_id, "---") === 0 && strcmp($city_id, "---") === 0 && strcmp($locality_id, "---") === 0) {
        $area_id = '000';
        $city_id = '000';
        $locality_id = '000';
    }

    $data = [
        'address_db' => Control::$configs['address-db'],
        'text' => $_ARG['text'],
        'state_id' => $state_id,
        'area_id' => $area_id,
        'city_id' => $city_id,
        'locality_id' => $locality_id,
        'street_id' => $street_id,
        'house_id' => $house_id,
        'limit' => 10
    ];

    function get_address($db, $data, &$result, $find)
    {
//        $find_types = ['state', 'area', 'city', 'locality', 'street', 'house'];
        $result['success'] = 1;
        $result['message'] = $find;
        $find_list = [];
        foreach (explode(',', $find) as $i)
            $find_list[] = "kladr/find-" . trim($i);

//        $max_find = -1;
//        for ($i = 0; $i < count($find_list); $i++) {
//            $m = array_search($find_list[$i], $find_types);
//            if ($m > $max_find)
//                $max_find = $m;
//        }
//        if ($max_find == -1) $max_find = array_search($find, $find_types);

        if (str_contains($find, ',')) {
            $un = "SELECT * FROM (({% unions %})) T 
            ORDER BY
    CASE
        WHEN real_name LIKE '{% text %}' THEN 0
        WHEN real_name LIKE '{% text %}%' THEN 1
        WHEN type LIKE '{% text %}%' THEN 2
        ELSE 3 
    END, CHAR_LENGTH(real_name)";
            $pr = $db->union_run($find_list, $data, $data['limit'], query_line: $un);
            try {
                $result['datalist'] = $pr->fetch_all(MYSQLI_ASSOC);
            } catch (Error $err) {
                $result['success'] = 0;
                $result['message'] = $db->error() . $err;
            }
        } else {
            $pr = $db->run("kladr/find-$find", $data);
            try {
                $result['datalist'] = $pr->fetch_all(MYSQLI_ASSOC);
            } catch (Error $err) {
                $result['success'] = 0;
                $result['message'] = $db->error() . ' ' . $err;
            }
        }
    }

    get_address($db, $data, $result, $find);

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}