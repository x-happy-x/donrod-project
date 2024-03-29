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

Резервное копирование:

    .\.tools\backup-db.ps1 -config .\configs\tools.json -backups .\configs\backups-db.json

Восстановление копии:

    .\.tools\restore-db.ps1 -config .\configs\tools.json -restore .\configs\restore-db.json

Перенос базы данных:

    .\.tools\migration-db.ps1 -config .\configs\tools.json -migration .\configs\migration-db.json

> Для запуска скриптов должны быть установлены: PowerShell, Python, MySQL

> Все упомянутые выше конфиги описаны ниже

### Конфигурации
*Содержимое файла - `tools.json`*:

    {
      "port": "39153",              // Порт для тестирования сервера 
      "backups_dir": "backups/db/", // Путь к резервным копиям базы
      "local-db": [                 // Локальные подключения базы данных
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

*Содержимое файла - `backups-db.json`*:

    [
      {
        "connection": "local",      // Тип подключения (local | remote)
        "connection-id": 0,         // Индекс указанного подключения из файла tools.json
        "database": "donrod"        // База данных, копию которой нужно создать
      }
    ]

*Содержимое файла - `restore-db.json`*:

    [
      {
        "connection": "local",      // Тип подключения (local | remote)
        "connection-id": 0,         // Индекс указанного подключения из файла tools.json
        "filter": "donrod*.sql",    // Фильт для поиска резервных копий
        "backup-id": 1,             // Индекс файла с конца
        "database": "donrod"        // База данных куда восстанавливается копия
      }
    ]

*Содержимое файла - `migration-db.json`*:

    [
      {
        "source-connection": "local",   // Тип исходного подключения (local | remote)
        "source-connection-id": 0,      // Индекс исходного подключения из файла tools.json
        "source-db": "donrod",          // Переносимая база данных
        "dest-connection": "remote",    // Тип конечного подключения (local | remote)
        "dest-connection-id": 0,        // Индекс конечного подключения из файла tools.json
        "dest-db": "donrod"             // Заменяемая база данных
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
        "database": "donrod",  // Имя базы данных
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