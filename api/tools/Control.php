<?php

namespace api\tools;

class Control
{

    public static array $configs;
    public static array $_ARG;

    public static Database $db;
    public static User $user;

    public static function noAccess(string $text = "Вы не обладаете нужными правами для доступа к данному разделу")
    {
        $result = [];
        $result['success'] = 0;
        $result['message'] = $text;
        echo json_encode($result, JSON_UNESCAPED_UNICODE);
        exit();
    }

    /**
     * @return mixed
     */
    public static function loadArgs(): mixed
    {
        $_ARG = json_decode(file_get_contents("php://input"), true);
        foreach ($_GET as $k => $v) {
            $_ARG[$k] = $v;
        }
        foreach ($_POST as $k => $v) {
            $_ARG[$k] = $v;
        }
        foreach ($_COOKIE as $k => $v) {
            $_ARG[$k] = $v;
        }
        return $_ARG?? [];
    }

    /**
     * @param bool|string $db
     * @param bool $user
     * @param bool $arg
     * @return void
     */
    public static function start(bool|string $db = false, bool $user = false, bool $arg = true)
    {
        $url = ROOT_DIR . "/configs/api-settings.json";
        self::$configs = json_decode(file_get_contents($url), true);
        spl_autoload_register(function ($name) {
            $fix_name = str_replace("\\","/",$name);
            require_once ROOT_DIR . "$fix_name.php";
        });
        if ($arg)
            self::$_ARG = self::loadArgs();
        if ($db) {
            if (is_string($db)) {
                self::$db = new Database($db);
            } else {
                self::$db = new Database(self::$configs['db-config']);
            }
        }
        if ($user)
            self::$user = new User(self::$db, self::$_ARG['auth_token'] ?? '');
    }
}