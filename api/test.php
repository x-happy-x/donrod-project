<?php

// Настройка проекта
define('ROOT_DIR', $_SERVER['DOCUMENT_ROOT'] . "/");
require_once ROOT_DIR."api/tools/Control.php";
use api\tools\Control;

// Подключение к базе и авторизация
Control::start(true, true);
$db = Control::$db;
$user = Control::$user;
$_ARG = Control::$_ARG;

echo ROOT_DIR;

