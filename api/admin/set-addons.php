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

    $result = [];
    $r = $db->run("items/addons/delete", $_ARG);
    if ($r) {
        if (isset($_ARG['addons']) && strlen($_ARG['addons']) > 0) {
            $rr = [];
            $addons = explode(",",$_ARG['addons']);
            foreach ($addons as $addon) {
                $rr[] = "(" . $_ARG['item'] . "," . $addon . ",'" . $_ARG['type'] . "'," . $_ARG['group'] . ")";
            }
            $r = $db->run("items/addons/add", ['values' => join(",", $rr)], false);
            if ($r) {
                $result['success'] = 1;
                $result['message'] = "Группа изменена";
            } else {
                $result['success'] = 0;
                $result['message'] = $db->error();
            }
        } else {
            $result['success'] = 1;
            $result['message'] = "Группа удалена";
        }
    } else {
        $result['success'] = 0;
        $result['message'] = $db->error();
    }
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}