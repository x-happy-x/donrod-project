<?php

namespace api\users {
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
    if (!$user->perm()->read('messages')) {
        Control::noAccess('Вы не можете читать сообщения в чате');
    }

    if (isset($_ARG['message'])) {
        // Проверка доступа
        if (!$user->perm()->add('messages')) {
            Control::noAccess('Вы не можете отправлять сообщения в чат');
        }
        $db->run("user/messages/send", ['message' => $_ARG['message'], 'user' => $user->id]);
    }

    $result = $db->run("user/messages/get", ['limit' => 100, 'user' => $user->id])->fetch_all(MYSQLI_ASSOC);
    foreach ($result as $key => $value) {
        $result[$key]['type'] =  $value['user'] == $user->id ? "send" : "receive";
        $result[$key]['name'] =  $value['user'] == $user->id ? "Вы" : $result[$key]['name'];
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
