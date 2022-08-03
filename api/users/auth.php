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

    $result = [];
    if (isset($_ARG['sign']) && $_ARG['sign'] == 'exit') {
        if (isset($_COOKIE['auth_token'])) {
            unset($_COOKIE['auth_token']);
            setcookie('auth_token', null, -1, '/');
        }
    } elseif (!$user->auth) {
        if (isset($_ARG['sign']) && $_ARG['sign'] == 'up') {
            if (!isset($_ARG['name']) || strlen($_ARG['name']) == 0) {
                $result['success'] = 0;
                $result['message'] = 'Не указано имя пользователя';
            } else {
                $name = $_ARG['name'];
                $email = $_ARG['mail'];
                $password = $_ARG['pass'];
                if (!isset($_ARG['class-choose'])) {
                    $result['success'] = 0;
                    $result['message'] = 'Не выбран тип пользователя';
                } elseif ($db->count("users","WHERE mail = $email") > 0) {
                    $result['success'] = 0;
                    $result['message'] = 'Этот адрес эл. почты уже зарегистрирован';
                } else if ($user->reg($name, $email, $password, $_ARG['class-choose'])) {
                    $result['success'] = 1;
                    $result['user'] = [];
                    $result['user']['id'] = $user->id;
                    $result['user']['name'] = $user->name;
                    $result['user']['mail'] = $user->mail;
                    $result['user']['class'] = $user->class;
                } else {
                    $result = $user->result;
                }
            }
        } else if (isset($_ARG['sign']) && $_ARG['sign'] == 'in') {
            $email = $_ARG['mail'];
            $password = $_ARG['pass'];
            if ($user->auth($email, $password)) {
                $result['success'] = 1;
                $result['user'] = [];
                $result['user']['id'] = $user->id;
                $result['user']['name'] = $user->name;
                $result['user']['mail'] = $user->mail;
                $result['user']['class'] = $user->class;
            } else {
                $result = $user->result;
            }
        }
    } else {
        $result['success'] = 1;
        $result['user'] = [];
        $result['user']['id'] = $user->id;
        $result['user']['name'] = $user->name;
        $result['user']['mail'] = $user->mail;
        $result['user']['class'] = $user->class;
    }
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
}
