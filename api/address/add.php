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
    $_ARG['address_db'] = Control::$configs['address-db'];

    // Проверка доступа
    if (!$user->perm()->add('address')) {
        if ($user->auth) {
            Control::noAccess('Вы не можете добавлять адреса');
        } else {
            Control::noAccess('Для добавления адреса необходимо авторизоваться');
        }
    }

    use Error;

    $result = [];
    $r = $db->run("user/address/get", ['user_id' => $user->id]);
    if ($r->num_rows < 4) {
        if (!isset($_ARG['apartment']) || strlen($_ARG['apartment']) == 0)
            $_ARG['apartment'] = 'NULL';
        if (!isset($_ARG['dcode']) || strlen($_ARG['dcode']) == 0)
            $_ARG['dcode'] = 'NULL';
        if (!isset($_ARG['entrance']) || strlen($_ARG['entrance']) == 0)
            $_ARG['entrance'] = 'NULL';
        if (!isset($_ARG['floor']) || strlen($_ARG['floor']) == 0)
            $_ARG['floor'] = 'NULL';
        if (!isset($_ARG['note']) || strlen($_ARG['note']) == 0)
            $_ARG['note'] = '';
        $_ARG['manyfloors'] = isset($_ARG['manyfloors']) && (strcmp($_ARG['manyfloors'], "true") === 0 || $_ARG['manyfloors'] === true) ? 1 : 0;
        $r = $db->run("user/address/check", $_ARG);
        if (is_numeric($r) || $r->num_rows == 0 || $r->fetch_array()[0][0] == 0) {
            $result['success'] = 0;
            $result['message'] = 'Адрес не найден в базе, введите заново или попробуйте позже';
        } else {
            try {
                $_ARG['user_id'] = $user->id;
                $r = $db->run("user/address/add", $_ARG);
                if ($r == 0) {
                    $result['success'] = 0;
                    $result['message'] = $db->error();
                } else {
                    $result['success'] = 1;
                    $result['message'] = 'Адрес добавлен' . $db->error();
                }
            } catch (Error $err) {
                $result['success'] = 0;
                $result['message'] = $db->error();
            }
        }
    } else {
        $result['success'] = 0;
        $result['message'] = "Лимит адресов достигнут, пожалуйста удалите ненужный и повторите попытку";
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
