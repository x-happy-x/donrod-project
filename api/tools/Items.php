<?php

namespace api\tools {

    class Items
    {

        /**
         * Получение списка категорий
         * Разрешения:
         * categories - read
         * @param Database $db База данных
         * @param User $user Пользователь
         * @return mixed Категории
         */
        public static function categories(Database $db, User $user): mixed
        {
            if (!$user->perm()->read('categories')) {
                Control::noAccess('Для вас не доступны категории товаров');
            }
            $cats = $db->run("category/get");
            return $cats->fetch_all(MYSQLI_ASSOC);
        }

        /**
         * Получение списка товаров в корзине
         * @param Database $db
         * @param User $user
         * @param array $_ARG
         * @return array
         */
        public static function list_cart(Database $db, User $user, array $_ARG): array
        {
            $_ARG['cart'] = true;
            return list_items($db, $user, $_ARG);
        }

        /**
         * Получение информации об одном товаре по id
         * @param Database $db
         * @param User $user
         * @param array $_ARG
         * @param int $item
         * @return array
         */
        public static function get_item(Database $db, User $user, array $_ARG, int $item): array
        {
            $_ARG['item'] = $item;
            return list_items($db, $user, $_ARG, true);
        }

        /**
         * Получение информации об одном товаре по id
         * @param Database $db
         * @param User $user
         * @param array $_ARG
         * @param bool $get_one
         * @return array
         */
        public static function list_items(Database $db, User $user, array $_ARG, bool $get_one = false): array
        {
            // Получение товаров и корзины с проверкой доступа
            $is_cart = false;
            if (isset($_ARG['cart']) && $_ARG['cart'] == 'true') {
                $is_cart = true;
                if (!$user->perm()->read('cart')) {
                    if ($user->auth) {
                        Control::noAccess('Вам не доступна корзина');
                    } else {
                        Control::noAccess('Для доступа к корзине попробуйте авторизоваться');
                    }
                }
            }
            // Фильтры
            $where = "count > 0"; // Не показывать отсутствующие
            if (isset($_ARG['show-all'])) $where = "1=1";  // Не показывать отсутствующие
            if (isset($_ARG['category']) && is_numeric($_ARG['category']))
                $where .= " AND item_categories.category = " . $_ARG['category']; // Выбрать только нужную категорию товаров
            if ($get_one || $user->perm()->get("items", "read-all")) {
                if (!isset($_ARG['all'])) {
                    $where .= " AND items.status = 1";
                }
                if (isset($_ARG['item'])) {
                    $where = "items.id = " . $_ARG['item'];
                }
            } else {
                $where .= " AND items.status = 1";
                if (isset($_ARG['item'])) {
                    $result = [];
                    $result['success'] = -1;
                    return $result;
                }
            }

            $items = $db->run("items/get", ['where' => $where, 'user' => $user->auth ? $user->id : 0]);

            $items = $items->fetch_all(MYSQLI_ASSOC);
            $id_list = [];
            foreach ($items as $row) {
                $id_list[] = $row['id'];
            }

            $result = [];
            $addons = $db->run("items/get-addons", ['items' => join(',', $id_list)]);
            $promotions = $db->run("items/get-promotions", ['items' => join(',', $id_list)]);

            if ($user->auth) {
                $normalize = $db->run("user/cart/normalize", ['user_id' => $user->id]);
                if ($normalize && $db->affected_rows() > 0) {
                    $result['success'] = 2;
                    $result['message'] = 'Количество товара в корзине было уменьшено из-за нехватки товара на складе';
                }
                $cart_items = $db->run("user/cart/get", ['user_id' => $user->id]);
            } else {
                $cart_items = [];
            }

            // Получение списка товаров
            $result['items'] = [];
            $img_path = $db->run_and_get("get-param", ['param' => 'image-path']);
            foreach ($items as $row) {
                $row['addons'] = [];
                $row['addons_list'] = [];
                $row['cart'] = [];
                $row['rating'] = round($row['rating'], 1);
                $in_cart = 0;
                $row['image-path'] = $img_path;
                foreach ($addons as $item) {
                    if ($row['id'] == $item['item']) {
                        $item['promotions'] = [];
                        foreach ($promotions as $pitem) {
                            if ($pitem['item'] == $item['id']) {
                                $item['promotions'][] = $pitem;
                            }
                        }
                        $row['addons'][] = $item;
                        $row['addons_list'][] = $item['id'];
                    }
                }
                foreach ($cart_items as $item) {
                    $b = false;
                    if (is_string($item['addons']))
                        $item['addons'] = explode(',', $item['addons']);
                    foreach ($item['addons'] as $addon) {
                        if (in_array($addon, $row['addons_list'])) {
                            $b = true;
                            break;
                        }
                    }
                    if ($b) {
                        $row['cart'][] = $item;
                        $in_cart += $item['count'];
                    }
                }
                if (!$is_cart || $in_cart > 0)
                    $result['items'][] = $row;
            }
            return $result;
        }

        /**
         * Получение информации о заказах
         * @param Database $db
         * @param User $user
         * @param array $_ARG
         * @param string $address_db
         * @param int $user_id
         * @return array
         */
        public static function list_orders(Database $db, User $user, array $_ARG, string $address_db, int $user_id): array
        {
            $result = [];
            if (!$user->auth) {
                $result['success'] = 0;
                $result['message'] = "Для доступа к заказам необходимо авторизоваться";
                return $result;
            }
            $where = [];
            if ($user->id != $user_id) {
                if (!$user->perm()->get('orders-all', 'access')) {
                    Control::noAccess();
                }
                if (isset($_ARG['state']) && is_numeric($_ARG['state']) && $_ARG['state'] >= -1) {
                    $where[] = "orders.state = $_ARG[state]";
                }
                if ($user_id != -1) {
                    $where[] = "orders.user = $user_id";
                }
            } else {
                if (!$user->perm()->read('orders')) {
                    Control::noAccess();
                }
                $where[] = "orders.user = $user_id";
            }
            $limit = 3;
            $offset = isset($_ARG['page']) && is_numeric($_ARG['page']) && $_ARG['page'] >= 1 ? ($_ARG['page']-1) * $limit : 0;
            $sql = "user/order/search";
            if (isset($_ARG['last'])) {
                $offset = 0;
                $limit = 1;
            }
            if (count($where) == 0) {
                $where = "1=1";
            } else {
                $where = join(" AND ",$where);
            }
            $r = $db->run($sql, ['where' => $where, 'offset' => $offset, 'limit' => $limit]);
            $img_path = $db->run_and_get("get-param", ['param' => 'image-path']);
            if ($r) {
                if ($r->num_rows > 0) {
                    $find_types = ['state', 'area', 'city', 'locality', 'street'];
                    $orders_ = $r->fetch_all(MYSQLI_ASSOC);
                    $list_ids = [];
                    $orders = [];
                    foreach ($orders_ as $order) {
                        $list_ids[] = $order['id'];
                        $row = array_slice($order, 0, 11); // key_exists("address_code", $order))
                        $row['address'] = array_slice($order, 11);
                        $row['address']['full'] = Address::get_full($db, $order['address_code'], $address_db, $find_types);
                        $row['image-path'] = $img_path;
                        $orders[] = $row;
                    }
                    $r = $db->run('user/order/get-buylist', ['orders' => join(", ", $list_ids)]);
                    if ($r && $r->num_rows > 0) {
                        $buy_list = $r->fetch_all(MYSQLI_ASSOC);
                        $addons_list = [];
                        $addons_buys_nav = [];
                        foreach ($orders as $key => $order) {
                            $orders[$key]['buylist'] = [];
                            foreach ($buy_list as $buy_item) {
                                if ($order['id'] == $buy_item['order_id']) {
                                    unset($buy_item['order_id']);
                                    unset($buy_item['cart_id']);
                                    $orders[$key]['buylist'][] = $buy_item;
                                    foreach (explode(",", $buy_item['addons']) as $addon) {
                                        $addons_buys_nav[] = [$key, count($orders[$key]['buylist']) - 1, $addon];
                                        $addons_list[] = $addon;
                                    }
                                }
                            }
                        }
                        $r = $db->run('items/get-by-addons', ['addons' => join(", ", $addons_list)]);
                        if ($r && $r->num_rows > 0) {
                            $items = $r->fetch_all(MYSQLI_ASSOC);
                            foreach ($items as $item) {
                                foreach ($addons_buys_nav as $row) {
                                    if (in_array($row[2], explode(",", $item['addon'])))
                                        $orders[$row[0]]['buylist'][$row[1]]['item'][] = $item;
                                }
                            }
                            $result['success'] = 1;
                            $result['message'] = "Все заказы загружены";
                        } else {
                            $result['success'] = 0;
                            $result['message'] = $db->error();
                        }
                    } else {
                        $result['success'] = 0;
                        $result['message'] = $db->error();
                    }
                    $result['orders'] = $orders;
                } else {
                    $result['success'] = 1;
                    $result['message'] = "У вас ещё не было заказов";
                }
                if ($user_id != -1)
                    $where = "user = $user_id AND state >= -1";
                else
                    $where = "state >= -1";
                $result['pages'] = ceil($db->count("orders", $where) / $limit);
                $result['current_page'] = ceil(($offset+1) / $limit);
            } else {
                $result['pages'] = 0;
                $result['success'] = 0;
                $result['message'] = $db->error();
            }
            return $result;
        }


        /**
         * Получение полной стоимости товаров в корзине
         * @param Database $db
         * @param User $user
         * @param array $_ARG
         * @return array
         */
        public static function cart_price(Database $db, User $user, array $_ARG): array
        {
            $result = [];
            if ($db->run_and_get("user/cart/all-count", ["user" => $user->id]) > 0) {
                $_ARG['cart'] = true;
                if (isset($_ARG['categories'])) {
                    $result = Items::categories($db, $user);
                } else {
                    $result = Items::list_items($db, $user, $_ARG);
                }
                $sum_price = 0;
                $sum_promo_price = 0;
                $all_count = 0;
                foreach ($result['items'] as $item) {
                    foreach ($item['cart'] as $cart) {
                        $real_price = $item['price'];
                        $price = $real_price;
                        $weight = $item['weight'];
                        $promo_price = $real_price;
                        $count = $cart['count'];
                        foreach ($cart['addons'] as $addon_id) {
                            foreach ($item['addons'] as $addon) {
                                if ($addon['id'] == $addon_id) {
                                    switch ($addon['addon_type']) {
                                        case '%':
                                            $price += $real_price * $addon['price'] / 100;
                                            break;
                                        case 'money':
                                            $price += $addon['price'];
                                            break;
                                    }
                                    $promo_price = $price;
                                    foreach ($addon['promotions'] as $promo) {
                                        $criteria = $promo['worked_from_price'] == null || $promo['worked_from_price'] <= $price * $count;
                                        $criteria = $criteria && ($promo['worked_to_price'] == null || $promo['worked_to_price'] >= $price * $count);
                                        $criteria = $criteria && ($promo['worked_from_count'] == null || $promo['worked_from_count'] <= $count);
                                        $criteria = $criteria && ($promo['worked_to_count'] == null || $promo['worked_to_count'] >= $count);
                                        $criteria = $criteria && ($promo['worked_from_weight'] == null || $promo['worked_from_weight'] <= $weight * $count);
                                        $criteria = $criteria && ($promo['worked_to_weight'] == null || $promo['worked_to_weight'] >= $weight * $count);
                                        if ($criteria) {
                                            switch ($promo['type']) {
                                                case '%':
                                                    $promo_price -= $price * $promo['size'] / 100;
                                                    break;
                                                case 'money':
                                                    $promo_price -= $promo['size'];
                                                    break;
                                            }
                                            break;
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                        $all_count += $count;
                        $sum_price += $price * $count;
                        $sum_promo_price += $promo_price * $count;
                    }
                }
                $result = [];
                $result['success'] = 1;
                if (isset($_ARG['address']) && is_numeric($_ARG['address'])) {
                    $r = $db->run("user/address/get-one", ['user_id' => $user->id, 'id' => $_ARG['address']]);
                    if (is_numeric($r) || $r->num_rows == 0) {
                        $result['success'] = 0;
                        $result['message'] = 'Адрес не найден в базе, введите заново или попробуйте позже';
                    } else {
                        $r = $r->fetch_assoc()['address_code'];
                        $r = $db->run("user/address/filter", ['address' => $r]);
                        if ($r && $r->num_rows > 0) {
                            $result['address_price'] = $r->fetch_assoc()['price'];
                        } else {
                            $result['success'] = 0;
                            $result['message'] = 'По выбранному адресу не доступна доставка';
                        }
                    }
                }
                $result['count'] = $all_count;
                $result['price'] = $sum_price;
                $result['price_promo'] = $sum_promo_price;
            } else {
                $result['success'] = 0;
                $result['count'] = 0;
                $result['price'] = 0;
                $result['price_promo'] = 0;
            }
            return $result;
        }

    }
}