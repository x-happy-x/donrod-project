<?php

namespace api\stat {

    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Control;

    // Подключение к базе и авторизация
    Control::start(true);

    $db = Control::$db;

    $result = [];
    $result['schemaVersion'] = 1;
    $result['label'] = "Заказы";
    $result['message'] = "".$db->count('orders');
    $result['color'] = "red";

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}