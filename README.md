<br>
<p id="logo" align="center">
    <a href="https://dr.happy-x.ru">
        <img src="images/title.png" width="200" alt="Донской родник"/>
    </a>
</p>
<br>
<p id='stat' align="center">
    <img src='https://img.shields.io/endpoint?style=for-the-badge&url=https://dr.happy-x.ru/api/stat/dev-status.php' />
    <img src='https://img.shields.io/endpoint?style=for-the-badge&url=https://dr.happy-x.ru/api/stat/all-items.php' />
    <img src='https://img.shields.io/endpoint?style=for-the-badge&url=https://dr.happy-x.ru/api/stat/all-users.php' />
</p>
<br>

### [Тестовый сервер][server]

### Описание

Данный проект выполнен для компании ООО «Донской Родник» и использовался в качестве выпуской квалификационной работы. 
Компания ООО «Донской Родник» расположена по адресу Ростовская обл., г. Зерноград, ул. им. Чехова, д. 154Г, зарегистрирована 12.03.2015. 
Основным видом деятельности компании является: производство безалкогольных напитков; производство минеральных вод и прочих питьевых вод в бутылках. 
Компания выпускает воду под торговыми марками «Донской родник», «Родничок», «H<sub>2</sub>O элитная».

Цель проекта - обеспечить автоматизацию процесса оформления заказа.

### Технические характеристики

**IDE:** PhpStorm - 2022.2 

**Frontend:**
+ HTML5
+ CSS3 (SCSS)
+ JavaScript

**Backend:**
+ PHP - 8.1.5
+ MySQL - 8.0.29
+ Python - 3.10.5

### Запуск сервера

Для тестирования только на текущем устройстве

    .\.tools\run-server\localhost.ps1 -config .\configs\tools.json

Для тестирования на любых устройствах в той же сети

    .\.tools\run-server\ipv4.ps1 -config .\configs\tools.json

### База данных
Перенос локальной базы данных осуществляется следующим скриптом:

    .\.tools\migration-db.ps1 -config .\configs\tools.json -migration .\configs\migration-db.json

> Для запуска скрипта должны быть установлены: PowerShell, Python, MySQL

### Конфигурации
*Содержимое файла - `tools.json`*:

    {
      "port": "39153", // Порт для тестирования сервера 
      "local-db": [    // Локальные подключения базы данных
        {
          "user": "root",           // Имя пользователя
          "password": "1234",       // Пароль
          "server": "localhost",    // Сервер
          "port": "3306"            // Порт
        }
      ],
      "remote-db": [    // Удаленные подключения базы данных
        {
          "user": "root",           // Имя пользователя
          "password": "1234",       // Пароль
          "server": "server.ru",    // Сервер
          "port": "3306"            // Порт
        }
      ]
    }

*Содержимое файла - `migration-db.json`*:

    [
      {
        "local-connection-id": 0,    // Индекс локального подключения из файла tools.json
        "remote-connection-id": 0,   // Индекс удаленного подключения из файла tools.json
        "local-db": "donrod_test",   // Название локальной базы данных
        "remote-db": "donrod"        // Название удаленной базы данных
      }
    ]

*Содержимое файла - `api.json`*:

    {
        "db-config": "Префикс названия файла для подключения к базе данных",
        "address-db": "Название базы данных с адресами",
        "title": "Название сайта"
    }

*Содержимое файлов  - `...-db.json`*:
> Используется для подключения к базе данных в php файлах

    {
        "user": "root",             // Имя пользователя
        "password": "1234",         // Пароль
        "database": "donrod_test",  // Имя базы данных
        "server": "localhost",      // Сервер
        "port": "3306"              // Порт
    }

*Содержимое файлов  - `...-mail.json`*:
> Используется для отправки сообщений на электронную почту в php файлах

    {
        "name": "Донской родник",           // Имя отправителя
        "charset": "UTF-8",                 // Кодировка сообщения
        "host": "mail.host.ru",             // Хост
        "password": "1234",                 // Пароль (для SMTP)
        "port": 1234,                       // Порт (для SMTP)
        "send-mail": "support@happy-x.ru",  // Почта - отправитель (для SMTP используется как логин)
        "reply-mail": "support@happy-x.ru", // Почта - для ответных сообщений
        "bcc-mail": "backup@happy-x.ru"     // Почта - для скрытых копий
    }

[server]: https://dr.happy-x.ru/ "Тестовый сервер для демонстранции работы сайта"