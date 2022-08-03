<?php

namespace api\address {
    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Address;
    use api\tools\Control;

    // Подключение к базе и авторизация
    Control::start(true, true);
    $db = Control::$db;
    $user = Control::$user;

    // Проверка доступа
    if (!$user->perm()->read('address')) {
        Control::noAccess('Вы не можете просматривать адреса');
    }

    $result = [];
    $find_types = ['state', 'area', 'city', 'locality', 'street'];
    if (!$user->auth) {
        $result['success'] = 0;
        $result['message'] = 'Вы не авторизованы';
    } else {
        $r = $db->run("user/address/get", ['user_id' => $user->id]);
        if (is_numeric($r) || $r->num_rows == 0) {
            $result['success'] = 0;
            $result['message'] = 'Адрес не найден в базе, введите заново или попробуйте позже';
        } else {
            $result['success'] = 1;
            $result['message'] = '';
            $result['address'] = [];
            while (($row = $r->fetch_assoc())) {
                $row['full'] = Address::get_full($db, $row['address_code'], Control::$configs['address-db'], $find_types);
                $result['address'][] = $row;
            }
        }
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
