<?php

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
if (!$user->perm()->get('crm', 'access')) {
    Control::noAccess();
}

?>

<!DOCTYPE html>
<html lang="ru">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Шрифт -->
    <link href="/styles/fonts/Gilroy.css" rel="stylesheet"/>

    <!-- Стили -->
    <link href="/styles/theme/light.css" rel="stylesheet"/>
    <link href="/styles/main.min.css" rel="stylesheet"/>
    <link href="/styles/form.min.css" rel="stylesheet"/>
    <link href="/styles/popup.min.css" rel="stylesheet"/>
    <link href="/styles/notify.min.css" rel="stylesheet"/>
    <link href="/styles/grid-items.min.css" rel="stylesheet"/>
    <link href="/styles/item.min.css" rel="stylesheet"/>
    <link href="/styles/main-page.min.css" rel="stylesheet"/>
    <!--    <link href="/styles/actionbar.min.css" rel="stylesheet"/>-->
    <link href="/styles/address.min.css" rel="stylesheet"/>
    <link href="/styles/orders.min.css" rel="stylesheet"/>
    <link href="/styles/admin.min.css" rel="stylesheet"/>

    <!-- Скрипты -->
    <script type="text/javascript" src="/scripts/main.min.js"></script>
    <script type="text/javascript" src="/scripts/templates.min.js"></script>
    <script type="text/javascript" src="/scripts/notify.min.js"></script>
    <script type="text/javascript" src="/scripts/user.min.js"></script>
    <script type="text/javascript" src="/scripts/pages.min.js"></script>
    <script type="text/javascript" src="/scripts/popups.min.js"></script>
    <script type="text/javascript" src="/scripts/address.min.js"></script>
    <script type="text/javascript" src="/scripts/item.min.js"></script>
    <!-- Заголовок -->
    <title>Донской родник</title>
</head>

<body>
<!-- Основная часть страницы -->
<div body>
    <!-- Превью -->
    <div id="page0" page=0 pages>
    </div>
    <!-- Карта и футбар -->
    <div id="page4" page=4 style="min-height: 0;">
        <div footbar>
            © 2020-2022 <p>"Донской родник"</p>
        </div>
    </div>
</div>

<!-- Слой для затемнения -->
<div body-shadow hidden></div>

<!-- Элементы сайта которые не должны скрываться при открытии всплывающих окон -->
<div body-top>

    <div nav-menu-extended>
        <ul>
            <li><a class="menu-item" href="#page1">Товары</a></li>
            <li><a class="menu-item" href="#page2">Пользователи</a></li>
            <li><a class="menu-item" href="#page3">Активные заказы</a></li>
            <li separate><a class="menu-item profile-item">Профиль</a></li>
            <li><a class="menu-item">Параметры</a></li>
        </ul>
    </div>
    <table action-bar>
        <tr>
            <td class="actionbar-left-td" width=1>
                <div id="logo-block">
                    <img id="show_extended" src="/images/icon-menu.png">
                    <div id="crm-logo" class="menu-item">
                        CRM-система
                    </div>
                </div>
            </td>
            <td class="actionbar-center-td">
                <div id="current-state" class="actionbar-center menu-item">Товары</div>
            </td>
            <td width=1 class="actionbar-right-td">
                <div id="actionbar-controls" class="menu-item actionbar-right">
                    <img accent style="height: 30px;" src="/images/icon-add.svg">
                </div>
            </td>
        </tr>
    </table>
</div>

<!-- Всплывающие окна -->
<div popups hidden></div>

<div popups-controls hidden>
    <div popup-close onclick="Popup.close()"><img src="/images/icon-close.svg" alt="Закрыть"></div>
    <div popup-back onclick="Popup.back()"><img src="/images/icon-back.svg" alt="Назад"></div>
</div>

<!-- Уведомления -->
<div notify>
    <div notify-block></div>
</div>

<!-- Настройки при загрузке страницы -->
<script>
    add_on_loads(() => {

        let main_body = document.querySelector('[body]');
        let actionbar = document.querySelector('[action-bar]');
        let nav = document.querySelector('[nav-menu-extended]');
        User.on_crm = true;

        document.querySelector("#show_extended").onclick = () => {
            nav.classList.toggle("nav-close");
            main_body.classList.toggle("nav-closed");
        }
        document.querySelector("#crm-logo").onclick = () => {
            document.querySelector("#show_extended").onclick();
        }

        document.querySelector("#show_extended").onclick();
        // document.querySelectorAll('.menu-item').forEach(item => {
        //     item.onclick = event => {
        //         event.stopPropagation();
        //         if (item.classList.contains('profile-item'))
        //             Popup.show('profile', event);
        //     }
        // });

        // Popup.show('admin-item-full');
        Page.set_navigation([
            ["Товары", "page", "items"],
            ["Пользователи", "page", "users"],
            ["Заказы", "page", "orders"],
            [],
            ["Профиль", "popup", "profile"],
            ["Чат", "popup", "admin-chat"],
        ]);

        Popup.load('profile', (popup) => {
            if (popup != null) {
                send_request("/api/users/get-class.php", null, async (result) => {
                    let classes = await multi_template("user/class", result, {
                        "auth_available": {
                            "checked": {
                                1: "checked"
                            }
                        }
                    });
                    let class_list = await template("user/class-list", {
                        'class': classes
                    });
                    classes = popup.querySelector("#profile-classes");
                    classes.innerHTML = replace_template(classes.innerHTML, "classes", class_list);
                });
                add_on_update(User.after_auth, (signed) => {
                    nav.querySelector('#menu-item-0').onclick();
                    // Page.show('items');
                    // if (signed) {
                    //     Popup.close();
                    // }
                });
                User.auth();
                add_on_update(User.after_auth, (signed) => {
                    console.log(signed);
                    if (!signed) window.location = "/";
                });
            }
        });
    });
</script>
</body>

</html>