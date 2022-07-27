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
    if (!$user->perm()->read('items')) {
        Control::noAccess();
    }

    use api\tools\Items;

    if (isset($_ARG['categories'])) {
        $result = Items::categories($db, $user);
    } else if (isset($_ARG['orders'])) {
        $result = Items::list_orders($db, $user, $_ARG, Control::$configs['address-db'], $user->id);
    } else {
        $result = Items::list_items($db, $user, $_ARG);
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}