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
    if (!$user->perm()->add('rating')) {
        if ($user->auth) {
            Control::noAccess('Вы не можете оценивать товар');
        } else {
            Control::noAccess('Для оценки товара необходимо авторизоваться');
        }
    }

    $result = [];
    if (isset($_ARG['item']) && isset($_ARG['rating']) && is_numeric($_ARG['item']) && is_numeric($_ARG['rating'])) {
        $data = [
            'user' => $user->id,
            'item' => $_ARG['item'],
            'rating' => $_ARG['rating'],
        ];
        if ($db->run_and_get('items/rating/get', $data) != null) {
            if ($db->run('items/rating/update', $data)) {
                $result['success'] = 1;
                $result['message'] = 'Рейтинг товара изменён';
                $r = $db->run('items/rating/avg', $data)->fetch_row();
                $result['rating'] = round($r[0], 1);
                $result['count'] = $r[1];
            } else {
                $result['success'] = 0;
                $result['message'] = 'Не верные параметры' . $db->error();
            }
        } else {

            if ($db->run('items/rating/add', $data)) {
                $result['success'] = 1;
                $result['message'] = 'Рейтинг товара изменён';
                $r = $db->run('items/rating/avg', $data)->fetch_row();
                $result['rating'] = round($r[0], 1);
                $result['count'] = $r[1];
            } else {
                $result['success'] = 0;
                $result['message'] = 'Не верные параметры' . $db->error();
            }
        }
    } else {
        $result['success'] = 0;
        $result['message'] = 'Не верные параметры';
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
