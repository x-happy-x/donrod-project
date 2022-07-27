<?php

namespace api\users {
    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Control;

    // Подключение к базе и авторизация
    Control::start(true, true);
    $db = Control::$db;

    $result = $db->run("user/get-class-auth", ['id' => '1=1'])->fetch_all(MYSQLI_ASSOC);
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}