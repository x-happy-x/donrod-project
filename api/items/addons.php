<?php

namespace api\items {
    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Control;

    // Подключение к базе и авторизация
    Control::start(true, true);
    $db = Control::$db;
    $user = Control::$user;
    $_ARG = Control::$_ARG;

    // Проверка доступа
    if (!$user->perm()->read('addons')) {
        Control::noAccess();
    }

    $r = $db->run("items/addons/get");
    $result = [];
    if ($r) {
        $result['success'] = 1;
        if ($r->num_rows > 0)
            $result['addons'] = $r->fetch_all(MYSQLI_ASSOC);
        else
            $result['addons'] = [];
    } else {
        $result['success'] = 0;
        $result['message'] = $db->error();
    }
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
