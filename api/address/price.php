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

    // Проверка доступа
    if (!$user->perm()->read('address')) {
        if ($user->auth) {
            Control::noAccess('Вы не можете просматривать цены на доставку');
        } else {
            Control::noAccess('Для просмотра цен на доставку необходимо авторизоваться');
        }
    }

    $result = [];
    if (!$user->auth) {
        $result['success'] = 0;
        $result['message'] = 'Вы не авторизованы';
    } else {
        $r = $db->run("user/address/get-one", ['user_id' => $user->id, 'id' => $_ARG['id']]);
        if (is_numeric($r) || $r->num_rows == 0) {
            $result['success'] = 0;
            $result['message'] = 'Адрес не найден в базе, введите заново или попробуйте позже';
        } else {
            $result['success'] = 1;
            $result['message'] = '';
            $r = $r->fetch_assoc()['address_code'];
            $r = $db->run("user/address/filter", ['address' => $r]);
            if ($r && $r->num_rows > 0) {
                $result['success'] = 1;
                $result['price'] = $r->fetch_assoc()['price'];
            } else {
                $result['message'] = 'По выбранному адресу не доступна доставка';
            }
        }
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
