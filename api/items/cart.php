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
    if (!$user->perm()->read('cart')) {
        if ($user->auth) {
            Control::noAccess('Вам не доступна корзина');
        } else {
            Control::noAccess('Для доступа к корзине необходимо авторизоваться');
        }
    }


    use api\tools\Database;
    use api\tools\User;

    function changeItems(Database $db, int $user, int $count, array | null $cart, array $addons, array $result, User $user_): array
    {
        if ($cart == null) {
            // Разрешение на добавление в корзину
            if (!$user_->perm()->add('cart')) {
                if ($user_->auth) {
                    Control::noAccess('Вам не доступна корзина');
                } else {
                    Control::noAccess('Для добавления товара в корзину необходимо авторизоваться');
                }
            }
            // Добавление записи
            $a = [];
            for ($i = 0; $i < count($addons); $i++) {
                if ($i == 0)
                    $a[] = 'SELECT ' . $addons[$i] . ' AS addon';
                else
                    $a[] = ' SELECT ' . $addons[$i] . ' ';
            }
            $r = $db->run("user/cart/add", ['user_id' => $user, 'count' => $count, 'addons' => join(' UNION ', $a)]);
            if ($r) {
                $result['success'] = 1;
                $result['message'] = 'Товар добавлен в корзину';
            } else {
                $result['success'] = 0;
                $result['message'] = 'Возникла ошибка: ' . $db->error();
            }
        } else {
            if ($count == 0) {
                // Разрешение на удаление из корзины
                if (!$user_->perm()->delete('cart')) {
                    if ($user_->auth) {
                        Control::noAccess('Вам не доступна корзина');
                    } else {
                        Control::noAccess('Для удаления товара из корзину необходимо авторизоваться');
                    }
                }
                // Удаление записи
                if ($db->run("user/cart/delete", ["cart" => $cart['id']])) {
                    $result['success'] = 1;
                    $result['message'] = 'Товар убран из корзины';
                } else {
                    $result['success'] = 0;
                    $result['message'] = 'Возникла ошибка: ' . $db->error();
                }
            } else {
                // Разрешение на запись в корзине
                if (!$user_->perm()->write('cart')) {
                    if ($user_->auth) {
                        Control::noAccess('Вам не доступна корзина');
                    } else {
                        Control::noAccess('Для обновления корзины необходимо авторизоваться');
                    }
                }
                // Обновление записи
                if ($db->run("user/cart/update", ["cart" => $cart['id'], "count" => $count])) {
                    $result['success'] = 1;
                    $result['message'] = 'Количество товара изменено';
                } else {
                    $result['success'] = 0;
                    $result['message'] = 'Возникла ошибка: ' . $db->error();
                }
            }
        }
        return $result;
    }

    $result = [];
    if (isset($_ARG['addons']) && strlen($_ARG['addons']) > 0 && isset($_ARG['id']) && is_numeric($_ARG['id'])) {
        $cart_items = $db->run("user/cart/get", ['user_id' => $user->auth ? $user->id : 0]);
        $addons = explode(',', $_ARG['addons']);
        $cur_cart = null;
        foreach ($cart_items as $item) {
            $c_addons = explode(',', $item['addons']);
            $b = true;
            if (count($c_addons) == count($addons)) {
                foreach ($c_addons as $addon) {
                    if (!in_array($addon, $addons)) {
                        $b = false;
                        break;
                    }
                }
            } else $b = false;
            if ($b) {
                $cur_cart = $item;
                break;
            }
        }
        $prev = 0;
        if (isset($_ARG['prev']) && is_numeric($_ARG['prev']))
            $prev += $_ARG['prev'];
        if (isset($_ARG['change']) && isset($_ARG['count']) && is_numeric($_ARG['count'])) {
            $rr = $db->run("user/cart/count", ['user_id' => $user->id, 'item' => $_ARG['id']]);
            if (!is_numeric($rr) && $rr->num_rows > 0) {
                $rr = $rr->fetch_assoc();
                if ($rr['current'] + $prev >= $_ARG['count']) {
                    $result = changeItems($db, $user->id, $_ARG['count'], $cur_cart, $addons, $result, $user);
                } else if ($rr['current'] == 0 && $rr['count'] != 0) {
                    // $result = changeItems($db, $_ARG['id'], $user->id, $rr['current'] + $prev, $cur_cart, $addons,  $result);\
                    $result['success'] = -1;
                    $result['message'] = 'Это весь товар, который есть в наличии';
                    $result['count'] = $prev;
                } else if ($rr['current'] < 0 && $prev + $rr['current'] > 0) {
                    $result = changeItems($db, $user->id, $prev + $rr['current'], $cur_cart, $addons, $result, $user);
                    $result['success'] = -1;
                    $result['message'] = 'Количество товара было изменено';
                    $result['count'] = $prev + $rr['current'];
                } else if ($prev != 0) {
                    $result = changeItems($db, $user->id, 0, $cur_cart, $addons, $result, $user);
                    $result['success'] = -1;
                    $result['message'] = 'Товар удален из корзины так как его больше нет в наличии';
                    $result['count'] = 0;
                } else {
                    $result['success'] = -1;
                    $result['message'] = 'Данного товара сейчас нет в наличии';
                    $result['count'] = 0;
                }
            } else {
                $result['success'] = -1;
                $result['message'] = 'Товар не найден';
                $result['count'] = 0;
            }
        } else if (isset($_ARG['delete'])) {
            $result = changeItems($db, $user->id, 0, $cur_cart, $addons, $result, $user);
        }
    } else if (isset($_ARG['count'])) {
        $result['success'] = 1;
        $result['count'] = $db->run_and_get('user/cart/all-count', ["user" => $user->id]);
    } else {
        $result['success'] = 0;
        $result['message'] = 'Не верный запрос';
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
