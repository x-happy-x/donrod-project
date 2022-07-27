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
    if (!$user->perm()->delete('address')) {
        if ($user->auth) {
            Control::noAccess('Вы не можете удалять адреса');
        } else {
            Control::noAccess('Для удаления адреса необходимо авторизоваться');
        }
    }

    $result = [];

    if ($db->run("user/address/delete", ['user' => $user->id, 'id' => $_ARG['id']])) {
        $result['success'] = 1;
        $result['message'] = 'Адрес удалён';
    } else {
        $result['success'] = 0;
        $result['message'] = $db->error();
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
