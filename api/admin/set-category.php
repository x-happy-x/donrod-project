<?php

namespace api\admin {
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
    if (!$user->perm()->write('items')) {
        Control::noAccess();
    }

    $r = $db->run("category/set", $_ARG);
    $result = [];
    if ($r) {
        $result['success'] = 1;
        $result['category'] = $_ARG['category'];
    } else {
        $result['success'] = 0;
        $result['message'] = $db->error();
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}