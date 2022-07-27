<?php

namespace api\address {

    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Control;

    // Подключение к базе и авторизация
    Control::start(true, true);
    $db = Control::$db;
    $user = Control::$user;
    $_ARG = Control::$_ARG;
    $_ARG['address_db'] = Control::$configs['address-db'];

    // Проверка доступа
    if (!$user->perm()->read('address')) {
        Control::noAccess('Вы не можете смотреть адреса');
    }

    $result = [];
    $find = $_ARG['find'];
    $code = "";

    if (isset($_ARG['state_id']) && strlen($_ARG['state_id']) == 2 && is_numeric($_ARG['state_id'])) {
        $code = $_ARG['state_id'];
        if (isset($_ARG['filter_street']) && strcmp($find, "street") === 0 && strcmp($_ARG['area_id'], "---") === 0 && strcmp($_ARG['city_id'], "---") === 0 && strcmp($_ARG['locality_id'], "---") === 0) {
            $code .= '.000.000.000.' . $_ARG['street_id'];
            if (isset($_ARG['house_id']) && strlen($_ARG['house_id']) == 3 && is_numeric($_ARG['house_id'])) {
                $code .= "." . $_ARG['house_id'];
            }
        } else {
            if (isset($_ARG['area_id']) && strlen($_ARG['area_id']) == 3 && is_numeric($_ARG['area_id'])) {
                $code .= "." . $_ARG['area_id'];
                if (isset($_ARG['city_id']) && strlen($_ARG['city_id']) == 3 && is_numeric($_ARG['city_id'])) {
                    $code .= "." . $_ARG['city_id'];
                    if (isset($_ARG['locality_id']) && strlen($_ARG['locality_id']) == 3 && is_numeric($_ARG['locality_id'])) {
                        $code .= "." . $_ARG['locality_id'];
                        if (isset($_ARG['street_id']) && strlen($_ARG['street_id']) == 4 && is_numeric($_ARG['street_id'])) {
                            $code .= "." . $_ARG['street_id'];
                            if (isset($_ARG['house_id']) && strlen($_ARG['house_id']) == 4 && is_numeric($_ARG['house_id'])) {
                                $code .= "." . $_ARG['house_id'];
                            }
                        }
                    }
                }
            }
        }
    }

    $r = $db->run("user/address/filter", ['address' => $code]);
    $result['code'] = $code;
    if ($r && $r->num_rows > 0) {
        $result['success'] = 1;
        $result['message'] = '';
    } else {
        $result['success'] = 0;
        $result['message'] = 'По указанному адресу не доступна доставка';
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
