<?php

namespace api\items {
    // Настройка проекта
    define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
    require_once ROOT_DIR . "api/tools/Control.php";

    use api\tools\Control;
    use api\tools\Items;

    // Подключение к базе и авторизация
    Control::start(true, true);
    $db = Control::$db;
    $user = Control::$user;
    $_ARG = Control::$_ARG;

    // Проверка доступа
    if (!$user->perm()->add('orders')) {
        if ($user->auth) {
            Control::noAccess('Вы не можете покупать товар');
        } else {
            Control::noAccess('Для покупки товаров необходимо авторизоваться');
        }
    }

    $result = [];
    if ($db->run_and_get("user/cart/all-count", ["user" => $user->id]) > 0) {
        $prices = Items::cart_price($db, $user, $_ARG);
        if ($prices['success'] == 1) {
            if ($db->run("user/order/add", [
                'user' => $user->id,
                'address' => $_ARG['address'],
                'date' => $_ARG['datetime'],
                'price' => $prices['price_promo'] + $prices['address_price'],
                'promo' => $prices['price'] - $prices['price_promo']
            ])) {
                $result['success'] = 1;
                $result['message'] = "Заказ успешно оформлен";
            } else {
                $result['success'] = 0;
                $message = $db->error();
                if (str_contains($message, "address")) {
                    $result['message'] = "Не верный адрес, выберите добавленный адрес или добавьте новый";
                } else if (str_contains($message, "date")) {
                    $result['message'] = "Не верный формат даты";
                } else {
                    $result['message'] = $db->error() . " " . $db->error;
                }
            }
        } else {
            $result['success'] = 0;
            $result['message'] = "При подсчете стоимости заказа возникли проблемы, повторите попытку ещё раз или свяжитесь с менеджером";
        }
    } else {
        $result['success'] = 0;
        $result['message'] = "У вас пустая корзина";
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
