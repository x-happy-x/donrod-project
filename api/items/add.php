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
    if (!$user->perm()->add('items')) {
        Control::noAccess();
    }

    $result = [];

    $image = $_FILES['item_name'];
    $name = $_POST['name'];
    $description = $_POST['description'];
    $count = $_POST['count'];
    $price = $_POST['price'];
    $weight = $_POST['weight'];
    $unit = $_POST['unit'];
    $upload_path = "NULL";
    # check all
    $result['success'] = 0;
    $name = $db->escape_to_string($name); //mysqli_real_escape_string($db->db, $name);// str_replace(array("/", "'" . '"', "|", "\\", "?", ":", ";"), "", $name);
    $description = str_replace(array("/", "'" . '"', "|", "\\", "?", ":", ";"), "", $description);
    if (!isset($name) || strlen($name) == 0) {
        $result['message'] = 'Название товара не должно быть пустым';
    } else if (!isset($description) || strlen($description) == 0) {
        $result['message'] = 'Описание товара не должно быть пустым';
    } else if (!isset($price) || !is_numeric($price) || $price <= 0) {
        $result['message'] = 'Проблемы с ценой' . $price;
    } else if (!isset($weight) || !is_numeric($weight) || $weight == 0) {
        $result['message'] = 'Проблемы с объемом';
    } else if (!isset($count) || !is_numeric($count)) {
        $result['message'] = 'Проблемы с количестом';
    } else if (!isset($unit) || strlen($unit) == 0) {
        $result['message'] = 'Проблемы с единицами измерения';
    } else {
        if (isset($image)) {
            $type = $image['type'];
            $error = $image["error"];
            if ($error == 0 && ($type == 'image/jpeg' || $type == 'image/png')) {
                $ext = explode('.', $image['name']);
                $ext = $ext[count($ext) - 1];
                $upload_path = 'item-' . $db->query('SELECT id FROM items ORDER BY id DESC LIMIT 1;')->fetch_row()[0] . '.' . $ext;
                if (copy($image['tmp_name'], ROOT_DIR . '/images/items/' . $upload_path)) {
                    $upload_path = "'$upload_path'";
                } else {
                    $upload_path = 'NULL';
                }
            } else if ($error != 4) {
                $result['success'] = 0;
                $result['message'] = $error == 0 ? 'Выбранный тип файла не подходит (требуется jpg, png и т.п.)' : 'Error: ' . $error;
                echo json_encode($result, JSON_UNESCAPED_UNICODE);
                exit();
            }
        }

        $db->query("INSERT INTO items VALUES (0, '$name', '$description', $price, $count, $weight, '$unit', NOW(), NOW(), $upload_path)");
        $result['success'] = 1;
        $result['message'] = 'Товар добавлен';

    }
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
