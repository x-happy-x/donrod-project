// Дополнение строк: форматирование
String.prototype.format = function () {
    let args = arguments;
    return this.replace(/{(\d+)}/g, function (match, number) {
        return typeof args[number] != 'undefined' ? args[number] : match;
    });
};
// Дополнение строк: шаблонизатор
String.prototype.template = function (params) {
    const names = Object.keys(params);
    const values = Object.values(params);
    return new Function(...names, `return \`${this}\`;`)(...values);
};
// Дополнение строк: замена всех совпадений в строке
String.prototype.replaceAll = function (search, replacement) {
    return this.replace(new RegExp(search, 'g'), replacement);
};

// Дополнение массивов: удаление всех совпадений по значению
Array.prototype.removeByValue = function (item) {
    for (let i = this.length; i--;)
        if (this[i] === item) this.splice(i, 1);
    return this;
};
// Дополнение массивов: удаление всех совпадений по индексу
Array.prototype.remove = function (index) {
    if (index >= 0 && index < this.length)
        this.splice(index, 1);
    return this;
};

// Проверка на число
isInt = (value) => {
    let x;
    return isNaN(value) ? !1 : (x = parseFloat(value), (0 | x) === x);
};


// Получение данных с формы
get_form_data = (form_id) => {
    return new FormData(form_id);
};
// Получение файла
get_file = async (url) => {
    let status, content, text;
    await send_request(url, null, (result, response) => {
        status = response.status;
        text = response.statusText;
        content = result;
    });
    return [status, text, content]
};


// Асинхронное выполнение запроса
send_request = async (url, data, on_result, on_progress) => {
    if (on_progress) await on_progress(0);
    console.log(url);
    let response;
    if (data !== undefined && data !== null) {
        response = await fetch(url, {
            method: "POST",
            body: data instanceof FormData ? data : JSON.stringify(data)
        });
    } else
        response = await fetch(url);
    if (on_progress) on_progress(50);
    let message = await response.text();
    try {
        message = JSON.parse(message);
    } catch {
    }
    console.log(response.status, response.statusText)
    console.log(message);
    if (on_result) await on_result(message, response);
    if (on_progress) await on_progress(100);
    return message;
};


// Выполнение нескольких функций после загрузки окна
let on_loads = [];
let on_loaded = false;
window.onload = () => {
    on_loaded = true;
    on_loads.forEach((func) => func())
};

add_on_loads = (obj) => {
    if (on_loaded)
        obj();
    else
        on_loads.push(obj);
};

// Выполнение нескольких функций после изменения размера окна
let on_resize = [];
window.onresize = () => {
    on_resize.forEach((func) => func())
};

add_on_resize = (obj) => {
    obj();
    on_resize.push(obj);
};

// Выполнение нескольких функций после скроллинга окна
let on_scroll = [];
window.onscroll = () => {
    on_scroll.forEach((func) => func())
};

add_on_scroll = (obj) => {
    obj();
    on_scroll.push(obj);
};


// При запуске
add_on_loads(() => {
    // Слушатели по-умолчанию
    let popups = document.querySelector("[popups]");
    if (popups !== undefined && popups != null) {
        popups.hidden = true;
        popups.onclick = event => Popup.hideAll(event);
    }
});

let on_updates = [];
add_on_update = (key, value) => {
    if (!(key in on_updates)) on_updates[key] = [];
    on_updates[key].push(value);
}
run_on_update = async (key, value) => {
    if (key in on_updates) {
        for (let i = 0; i < on_updates[key].length; i++) {
            await on_updates[key][i].apply(this, value);
        }
    }
}

sleep = (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Добавление
// add_on_update(User.after_auth, (signed) => {
//     if (signed) {
//         Items.load(document.querySelector('.linear'), 'item-x', 'mini-item');
//     } else {
//         User.show_profile();
//     }
// });

// Выполнение
// run_un_update(User.after_auth, [User.signed]);