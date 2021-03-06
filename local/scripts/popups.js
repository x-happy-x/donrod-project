class Popup {

    static history = [];
    static loaded = [];
    static current;
    static prevent = false;

    static async load(name, on_result) {
        let content = await get_file('/templates/popups/' + name + '.html');
        if (content[0] !== 200) {
            Notify.error("Ошибка " + content[0], content[1]);
            return null;
        }
        content = content[2];
        let container = document.querySelector('[popups]');
        let result = null;
        if (container !== null) {
            let block = document.createElement('div');
            block.innerHTML = content;
            block = block.children[0];
            let popup = container.querySelector('[' + name + ']');
            if (popup !== null) popup.remove();
            container.appendChild(block)
            result = container.lastChild;
        } else {
            Notify.error("Не удалось открыть меню");
        }
        if (on_result !== undefined && on_result !== null)
            await on_result(result);
        if (result != null)
            Popup.loaded.push(name);
        return result;
    }

    static change_visible(name, event, visible) {
        if (event !== undefined) event.stopPropagation();
        let container = document.querySelector("[popups]");
        let controls = document.querySelector("[popups-controls]");
        let popup = container.querySelector('[' + name + ']');
        if (popup !== null) {
            visible = visible !== undefined ? visible : popup.hidden;
            popup.hidden = !visible;
            popup.onclick = (event) => {
                event.stopPropagation();
            }
            let nvisible = Popup.history.length > 0;
            container.hidden = !nvisible;
            document.querySelector('[body]').classList.toggle('blurred', nvisible);
            document.querySelector('[body-top]').classList.toggle('blurred', nvisible);
            document.querySelector('[body-shadow]').hidden = !nvisible;

            if (visible) {
                controls.style.opacity = 0;
                controls.hidden = false;
                popup.onchange = () => {
                    let rect = popup.getBoundingClientRect();
                    controls.style.left = (rect.x + rect.width) + "px";
                    controls.style.top = (rect.y) + "px";
                }
                add_on_resize(() => {
                    let rect = popup.getBoundingClientRect();
                    controls.style.left = (rect.x + rect.width) + "px";
                    controls.style.top = (rect.y) + "px";
                });
                controls.style.opacity = 1;
            } else {
                controls.hidden = true;
            }
        }
    }

    static async show(name, event, close_prevent = false) {
        if (close_prevent) Popup.hideAll(event);
        if (document.querySelector("[popups] [" + name + "]") == null)
            Popup.load(name, (result) => {
                if (result != null) Popup.show(name, event)
            });
        else {
            this.current = name;
            Popup.prevent = false;
            await run_on_update(Popup.show, [name]);
            if (!Popup.prevent && Popup.history[Popup.history.length - 1] !== name) {
                Popup.hide(Popup.history[Popup.history.length - 1], event, false, false);
                Popup.history.push(name);
                Popup.change_visible(name, event, true);
            }
        }
    }

    static close(event) {
        Popup.hideAll(event);
    }

    static back(event) {
        if (Popup.history.length > 1) {
            Popup.hide(Popup.history.pop(), event, false);
            // Popup.show(Popup.history.pop(), event);
        } else {
            Popup.close(event);
        }
    }

    static hide(name, event, remove_history = true, open_prev = true) {
        if (remove_history)
            Popup.history.removeByValue(name);
        Popup.change_visible(name, event, false);
        run_on_update(Popup.hide, [name]);
        if (open_prev && Popup.history.length > 0) {
            Popup.show(Popup.history.pop(), event);
        }
    }

    static hideAll(event) {
        Popup.loaded.forEach(popup => this.hide(popup, event, true, false));
    }
}

let chat_id = -1;

add_on_loads(() => {
    add_on_update(Popup.hide, (name) => {
        if (chat_id !== -1 && name === "admin-chat") {
            clearInterval(chat_id);
        }
        if (name === "admin-item-full")
            run_on_update(Page.show, ['items']);
    })
    add_on_update(Popup.show, async (name) => {
        switch (name) {
            case 'profile':
                let profile = document.querySelector('[popups] [' + name + ']');
                await send_request("/api/users/get-class.php", null, async (result) => {
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
                    classes = profile.querySelector("#profile-classes");
                    classes.innerHTML =  class_list;
                });
                break
            case 'admin-item-full':
                let load_item_data = () => {
                    let data = {};
                    data.id = Items.selected_item;
                    data.name = iname.value;
                    data.description = idesc.value;
                    data.price = iprice.value;
                    data.weight = weight.value;
                    data.unit = unit.value;
                    data.count = count.value;
                    data.status = istatus.checked ? 1 : -1;
                    send_request("/api/admin/set-item.php", data, (result) => {
                        if (result.success == 1) {
                            Notify.info("Информация обновлена");
                        } else {
                            Notify.error(result.message);
                        }
                    })
                }
                let set_item_data = () => {
                    iname.value = one.name;
                    idesc.value = one.description;
                    iprice.value = one.price;
                    weight.value = one.weight;
                    unit.value = one.unit;
                    count.value = one.count;
                    istatus.checked = one.status == 1;
                    let img_empty = one.image == null || one.image === "";
                    if (img_empty) {
                        image.setAttribute("accent", "");
                        image.setAttribute("padding", "");
                    } else {
                        image.removeAttribute("accent");
                        image.removeAttribute("padding");
                    }
                    image.src = one['image-path'] + (img_empty ? "icon-error.svg" : one.image);
                }
                let addons = [];
                let one// = { "category": "1", "rating": 5, "myrating": "5", "countrating": "1", "id": "1", "name": "Вода питьевая негазированная \"Донской Родник\"", "description": "Артезианская негазированная вода", "price": "140", "count": "90", "weight": "19", "unit": "л.", "create_time": "2022-05-21 16:34:47", "update_time": "2022-05-25 06:57:49", "image": "d19_0.png", "status": "1", "addons": [{ "id": "1", "item": "1", "addon": "1", "type": "radio", "group_id": "1", "name": "", "price": "0", "addon_type": "money", "promotions": [{ "item": "1", "id": "1", "type": "%", "name": "Скидка от 2-х штук", "text": "При покупке от {% worked_from_count %} штук, цена снижается на {% size %}%", "size": "5", "worked_from_price": null, "worked_from_count": "2", "worked_from_weight": null, "worked_to_price": null, "worked_to_count": null, "worked_to_weight": null, "worked_from_time": null, "worked_to_time": null, "state": "1" }] }, { "id": "6", "item": "1", "addon": "2", "type": "radio", "group_id": "1", "name": "С тарой", "price": "400", "addon_type": "money", "promotions": [] }], "addons_list": ["1", "6"], "cart": [{ "id": "245", "user": "1", "count": "4", "create_time": "2022-06-16 10:19:45", "update_time": "2022-06-16 10:19:51", "state": "1", "addons": ["1"] }], "image-path": "/images/items/" };
                let item = document.querySelector('[popups] [' + name + ']');
                let image = item.querySelector('img#item-image');
                let iname = item.querySelector('input#item-name-input');
                let idesc = item.querySelector('input#item-desc-input');
                let iprice = item.querySelector('input#item-price-input');
                let weight = item.querySelector('input#item-weight-input');
                let unit = item.querySelector('input#item-unit-input');
                let count = item.querySelector('input#item-count-input');
                let istatus = item.querySelector('input#item-view-status');
                let admin_groups = item.querySelectorAll('.admin-group');
                let admin_group_content = item.querySelector('#admin-group-content');

                for (let i = 0; i < admin_groups.length; i++) {
                    admin_groups[i].onclick = async () => {
                        await send_request("/api/items/list.php", {'item': Items.selected_item}, async (result, response) => {
                            if (response.status !== 200) {
                                item.innerHTML = '<h3 title class="title">Не удалось загрузить</h3>';
                                Notify.error("Ошибка", response.statusText)
                            } else if (result == null || result.success === 0) {
                                item.innerHTML = '<h3 title class="title">Не удалось загрузить</h3>';
                                Notify.error("Ошибка", result.message)
                            } else if (result.success === -1) {
                                Popup.back();
                                Popup.prevent = true;
                                return;
                            } else {
                                one = result.items[0];
                                set_item_data();
                            }
                            let container = document.querySelector("[popups]");
                            let controls = document.querySelector("[popups-controls]");
                            let popup = container.querySelector('[' + name + ']');

                            let rect = popup.getBoundingClientRect();
                            controls.style.left = (rect.x + rect.width) + "px";
                            controls.style.top = (rect.y) + "px";
                            item.querySelectorAll(".first-column input").forEach(input => {
                                input.oninput();
                                input.onchange = load_item_data;
                            });
                        });
                        for (let j = 0; j < admin_groups.length; j++) {
                            admin_groups[j].classList.toggle("selected", i === j);
                        }
                        let sx = admin_groups[i].offsetLeft - admin_groups[i].parentElement.offsetLeft - (admin_groups[i].parentElement.offsetWidth - admin_groups[i].offsetWidth) / 2;
                        console.log(sx)
                        admin_groups[i].parentElement.scrollTo(sx, 0);
                        switch (admin_groups[i].id) {
                            case "admin-item-categories":
                                send_request("/api/items/list.php?categories", null, async (result) => {
                                    if (result == null || result.success == 0) {
                                        Notify.error(result.message);
                                    } else {
                                        for (let c = 0; c < result.length; c++) {
                                            result[c].active = result[c].id == one.category ? "selected" : "";
                                        }
                                        admin_group_content.innerHTML = await multi_template("items/mini-category", result);
                                        item.querySelectorAll('.item-category').forEach(cat => {
                                            cat.onclick = () => {
                                                send_request("/api/admin/set-category.php", {
                                                    "item": one.id,
                                                    "category": cat.getAttribute("category")
                                                }, (result) => {
                                                    if (result.success == 1) {
                                                        one.category = result.category;
                                                        item.querySelector("#admin-item-categories").onclick();
                                                    } else {
                                                        Notify.error(result.message);
                                                    }
                                                });
                                            };
                                        });
                                    }
                                });
                                break;
                            case "admin-item-addons":
                                send_request("/api/items/addons.php", null, async (result) => {
                                    if (result != null && result.success == 1) {
                                        addons = result.addons;
                                        let groups = {};
                                        for (let j = 0; j < one.addons.length; j++) {
                                            groups[one.addons[j].group_id] = {
                                                "type": one.addons[j].type,
                                                "addons": [],
                                                "addon_list": ""
                                            };
                                        }
                                        for (let k = 0; k < one.addons.length; k++) {
                                            groups[one.addons[k].group_id].addons.push(one.addons[k].addon);
                                        }
                                        let group_keys = Object.keys(groups);
                                        let last_g = group_keys[group_keys.length - 1] - 0;
                                        if (isNaN(last_g))
                                            last_g = 0;
                                        let gg = [];
                                        for (let g = 0; g < group_keys.length; g++) {
                                            const group = groups[group_keys[g]];
                                            let addon_list = [];
                                            for (let j = 0; j < addons.length; j++) {
                                                let addon = {};
                                                addon.checked = "";
                                                for (let a = 0; a < group.addons.length; a++) {
                                                    if (addons[j].id == group.addons[a]) {
                                                        addon.checked = "checked";
                                                        break;
                                                    }
                                                }
                                                addon.id = addons[j].id;
                                                addon.item = one.id;
                                                addon.group_id = group_keys[g];
                                                addon.name = addons[j].name;
                                                addon.type = addons[j].type.replace("money", "₽");
                                                addon.price = addons[j].price;
                                                addon_list.push(addon);
                                            }
                                            group.addon_list = await multi_template("items/addon-item", addon_list);
                                            group.id = group_keys[g];
                                            group.radio = group.type == "radio" ? "checked" : "";
                                            group.check = group.type == "checkbox" ? "checked" : "";
                                            gg.push(group);
                                        }

                                        admin_group_content.innerHTML = await multi_template("items/addon-group", gg);
                                        if (admin_group_content.innerHTML.length < 5)
                                            admin_group_content.innerHTML = "<a style='text-align:center;' id='admin-groups-message'>Чтобы товар появился на сайте нужно выбрать хотя бы одно дополнение</a>";
                                        admin_group_content.innerHTML += "<div id='admin-groups-add'>Добавить группу дополнений</div>"
                                        let add_group_btn = admin_group_content.querySelector("#admin-groups-add");
                                        add_group_btn.onclick = async () => {
                                            let addon_list = [];
                                            for (let j = 0; j < addons.length; j++) {
                                                let addon = {};
                                                addon.checked = "";
                                                addon.id = addons[j].id;
                                                addon.item = one.id;
                                                addon.group_id = ++last_g;
                                                addon.name = addons[j].name;
                                                addon.type = addons[j].type.replace("money", "₽");
                                                addon.price = addons[j].price;
                                                addon_list.push(addon);
                                            }
                                            let group = {"type": "checkbox"};
                                            group.addon_list = await multi_template("items/addon-item", addon_list);
                                            group.id = last_g;
                                            group.radio = group.type == "radio" ? "checked" : "";
                                            group.check = group.type == "checkbox" ? "checked" : "";
                                            let mdiv = document.createElement("div");
                                            mdiv.innerHTML = await template("items/addon-group", group);
                                            add_group_btn.parentElement.insertBefore(mdiv, add_group_btn);
                                            admin_group_content.querySelectorAll("[group-id]").forEach(elem => {
                                                elem.onchange = () => {
                                                    let addons = [];
                                                    elem.querySelector("#addons").querySelectorAll("input:checked").forEach(inp => {
                                                        addons.push(inp.getAttribute("addon"));
                                                    });
                                                    let gt = elem.querySelector("#group-control").querySelector("input:checked").value;
                                                    send_request("/api/admin/set-addons.php", {
                                                        "item": one.id,
                                                        "type": gt,
                                                        "addons": addons.join(","),
                                                        "group": elem.getAttribute('group-id')
                                                    }, (result) => {
                                                        if (result.success == 1) {
                                                            Notify.info(result.message);
                                                        } else {
                                                            Notify.error(result.message);
                                                        }
                                                    });
                                                }
                                            });
                                        };
                                        admin_group_content.querySelectorAll("[group-id]").forEach(elem => {
                                            elem.onchange = () => {
                                                let addons = [];
                                                elem.querySelector("#addons").querySelectorAll("input:checked").forEach(inp => {
                                                    addons.push(inp.getAttribute("addon"));
                                                });
                                                let gt = elem.querySelector("#group-control").querySelector("input:checked").value;
                                                send_request("/api/admin/set-addons.php", {
                                                    "item": one.id,
                                                    "type": gt,
                                                    "addons": addons.join(","),
                                                    "group": elem.getAttribute('group-id')
                                                }, (result) => {
                                                    if (result.success == 1) {
                                                        Notify.info(result.message);
                                                    } else {
                                                        Notify.error(result.message);
                                                    }
                                                });
                                                console.log({
                                                    "item": one.id,
                                                    "type": gt,
                                                    "addons": addons.join(","),
                                                    "group": elem.getAttribute('group-id')
                                                });
                                            }
                                        });
                                    }
                                });
                                break;
                            case "admin-item-rating":
                                admin_group_content.innerHTML = "В разработке";
                                break;
                            case "admin-item-cart":
                                admin_group_content.innerHTML = "В разработке";
                                break;
                            case "admin-item-orders":
                                admin_group_content.innerHTML = "В разработке";
                                break;
                            case "admin-item-stat":
                                admin_group_content.innerHTML = "В разработке";
                                break;
                        }
                    }
                }
                item.querySelectorAll("input").forEach(input => {
                    input.oninput = () => {
                        input.classList.toggle("show-placeholder", input.value.length > 0)
                    }
                    input.onchange = null;
                })
                admin_groups[0].onclick(one);
                break;
            case 'admin-chat':
                let chat = document.querySelector('[popups] [' + name + ']');
                let messages = chat.querySelector("#messages");
                let load_messages = () => {
                    send_request("/api/users/messages.php", null, async (result) => {
                        if (result != null) {
                            if (result.success == 0) {
                                Notify.error(result.message);
                                chat.querySelector("#messages").innerHTML = '<div class="empty-messages">Пусто</div>';
                            } else {
                                for (let i = 0; i < result.length; i++) {
                                    let x = result[i].send_time.split(" ")[1].split(":");
                                    result[i].send_time = x.slice(0, 2).join(":");
                                }
                                let msg_count = messages.children.length;
                                messages.innerHTML = await multi_template("user/message", result);
                                if (msg_count < messages.children.length)
                                    messages.lastChild.scrollIntoView();
                            }
                        } else {
                            chat.querySelector("#messages").innerHTML = '<div class="empty-messages">Пусто</div>';
                        }
                        let container = document.querySelector("[popups]");
                        let controls = document.querySelector("[popups-controls]");
                        let popup = container.querySelector('[' + name + ']');

                        let rect = popup.getBoundingClientRect();
                        controls.style.left = (rect.x + rect.width) + "px";
                        controls.style.top = (rect.y) + "px";
                    });
                };
                chat_id = setInterval(load_messages, 5000)
                let send_btn = chat.querySelector('#send-message');
                let message_tb = chat.querySelector('#message');
                message_tb.oninput = () => {
                    message_tb.classList.toggle("show-placeholder", message_tb.value.length > 0);
                }
                message_tb.onkeyup = (e) => {
                    if (e.keyCode === 13) {
                        send_btn.onclick();
                    }
                };
                send_btn.onclick = () => {
                    if (message_tb.value.length === 0) {
                        Notify.info("Внимание", "Слишком короткое сообщение");
                        return;
                    }
                    send_request("/api/users/messages.php", {'message': message_tb.value}, async (result) => {
                        if (result != null) {
                            if (result.success === 0) {
                                Notify.error(result.message);
                                chat.querySelector("#messages").innerHTML = '<div class="empty-messages">Пусто</div>';
                            } else {
                                for (let i = 0; i < result.length; i++) {
                                    let x = result[i].send_time.split(" ")[1].split(":");
                                    result[i].send_time = x.slice(0, 2).join(":");
                                }
                                messages.innerHTML = await multi_template("user/message", result);
                                messages.lastChild.scrollIntoView();
                            }
                        } else {
                            chat.querySelector("#messages").innerHTML = '<div class="empty-messages">Пусто</div>';
                        }
                        let container = document.querySelector("[popups]");
                        let controls = document.querySelector("[popups-controls]");
                        let popup = container.querySelector('[' + name + ']');

                        let rect = popup.getBoundingClientRect();
                        controls.style.left = (rect.x + rect.width) + "px";
                        controls.style.top = (rect.y) + "px";
                    });
                    message_tb.value = "";
                }
                load_messages();
                break
            case 'cart':
                let cart = document.querySelector('[popups] [' + name + ']');
                await Items.load_cart(cart.querySelector('.linear'), 'linear-item', '.mini-item');
                let cartEmpty = cart.querySelectorAll('.mini-item').length == 0;

                cart.querySelector('.linear').hidden = cartEmpty;
                cart.querySelector('.cart-info').hidden = cartEmpty;
                cart.querySelector('#order-run').hidden = cartEmpty;
                cart.querySelector('[subtitle]').hidden = !cartEmpty;

                if (!cartEmpty) {
                    let count = 0;
                    let sum = 0;
                    let sum2 = 0;
                    let sum3 = 0;
                    Items.items[0].forEach((item) => {
                        let cc = item['cart'][0]['count'] - 0;
                        let real_price = item['price'] - 0;
                        let weight = item['weight'] - 0;
                        let price = real_price;
                        let p2 = real_price;
                        for (let i = 0; i < item['cart'][0]['addons'].length; i++) {
                            const addon = item['cart'][0]['addons'][i];
                            let k = 0;
                            for (; k < item['addons'].length; k++) {
                                if (item['addons'][k]['id'] == addon) break;
                            }
                            let add_price = item['addons'][k]['price'];
                            let add_type = item['addons'][k]['addon_type'];
                            switch (add_type) {
                                case 'money':
                                    price -= -add_price;
                                    break;
                                case '%':
                                    price -= -real_price * add_price / 100;
                                    break
                            }
                            p2 = price;
                            let curtime = new Date();
                            let promotions = item.addons[k].promotions;
                            for (let j = 0; j < promotions.length; j++) {

                                let krit = promotions[j].worked_from_count == null || cc >= promotions[j].worked_from_count; // От определенного количества
                                krit = krit && (promotions[j].worked_to_count == null || cc <= promotions[j].worked_to_count); // До определенного количества
                                krit = krit && (promotions[j].worked_from_price == null || price * cc >= promotions[j].worked_from_price); // До определенного количества
                                krit = krit && (promotions[j].worked_to_price == null || price * cc <= promotions[j].worked_to_price); // До определенного количества
                                krit = krit && (promotions[j].worked_from_weight == null || weight >= promotions[j].worked_from_weight); // До определенного количества
                                krit = krit && (promotions[j].worked_to_weight == null || weight <= promotions[j].worked_to_weight); // До определенного количества
                                krit = krit && (promotions[j].worked_from_time == null || curtime >= new Date(promotions[j].worked_from_time)); // До определенного количества
                                krit = krit && (promotions[j].worked_to_time == null || curtime <= new Date(promotions[j].worked_to_time)); // До определенного количества
                                if (krit) {
                                    switch (promotions[j]['type']) {
                                        case 'money':
                                            price += (-promotions[j]['size']) / cc;
                                            break;
                                        case '%':
                                            price += -real_price * promotions[j]['size'] / 100;
                                    }
                                }
                            }
                        }
                        sum3 += weight * cc;
                        sum2 += p2 * cc;
                        sum += price * cc;
                        count += cc;
                    });
                    Items.real_price = sum2;
                    Items.price = sum;
                    cart.querySelector('.cart-info [count]').innerHTML = "x" + count;
                    cart.querySelector('.cart-info [weight]').innerHTML = sum3;
                    cart.querySelector('.cart-info [orig-price]').innerHTML = sum2;
                    cart.querySelector('.cart-info [promo-price]').innerHTML = sum2 - sum;
                    cart.querySelector('.cart-info [price]').innerHTML = sum;
                    cart.querySelector('#order-run').onclick = () => {
                        Popup.show('buy-menu');
                    };
                    // User.buy_menu;
                }
                cart.onclick = (event) => {
                    event.stopPropagation();
                }
                break;
            case 'buy-menu':
                let buymenu = document.querySelector('[popups] [' + name + ']');
                await send_request('/api/address/get.php', null, async (result) => {
                    if (result != null && result.success == 1) {
                        for (let i = 0; i < result.address.length; i++) {
                            const address = result.address[i];
                            address['full'] = await multi_template('address/item-line', address['full']);
                            address['mf'] = address['manyfloors'];
                            address['manyfloors'] = address['manyfloors'] == 1 ? "" : 'hidden';
                            address['note'] = address['note'].replaceAll("\"", "''");
                        }
                        buymenu.querySelector('#addresses').innerHTML = await multi_template('address/item', result.address);
                    } else {
                        buymenu.querySelector('#addresses').innerHTML = "";
                    }
                });
                buymenu.onclick = (event) => {
                    event.stopPropagation();
                };
                let childs = buymenu.querySelectorAll('.address-item');
                buymenu.querySelector('.add-btn').onclick = () => {
                    Popup.show('add-address')
                };
                buymenu.querySelector('.address-empty').onclick = () => {
                    Popup.show('add-address')
                };
                let phone = buymenu.querySelector('input#phone');
                phone.oninput = () => {
                    phone.parentElement.children[1].classList.toggle('show-placeholder', phone.value.length > 0)
                };
                let callcb = buymenu.querySelector('input#call');
                callcb.onchange = () => {
                    phone.hidden = !callcb.checked;
                };
                callcb.onchange();
                let time_tb = buymenu.querySelector('input#time');
                let date_tb = buymenu.querySelector('input#date');
                let now = new Date();
                now.setDate(now.getDate() + 1);
                let strnow = now.toLocaleDateString().split(".").reverse();
                strnow = strnow.join("-");
                date_tb.value = strnow;
                buymenu.querySelector('input#pay').onclick = () => {
                    if (buymenu.querySelector('.address-item.selected') === null) {
                        Notify.error("Добавьте адрес")
                    } else {
                        send_request('/api/items/buy.php', {
                            'address': buymenu.querySelector('.address-item.selected').getAttribute("address-id"),
                            'phone': phone.value,
                            'datetime': date_tb.value + " " + time_tb.value
                        }, async (result) => {
                            if (result != null && result.success == 1) {
                                Notify.info(result.message);
                                Popup.show('pay');
                                setTimeout(() => {
                                    Popup.hideAll();
                                    Popup.show("orders");
                                }, 5000)
                            } else {
                                Notify.error(result.message)
                            }
                        });
                    }
                }
                buymenu.querySelector('.address-empty').hidden = childs.length > 0;
                buymenu.querySelector('.address-top .del-btn').parentNode.hidden = childs.length == 0;
                let pprice = buymenu.querySelector('[promo-price]');
                let price = buymenu.querySelector('[price]');
                pprice.innerHTML = 0;
                price.innerHTML = Items.price;
                if (childs.length > 0) {
                    for (let i = 0; i < childs.length; i++) {
                        childs[i].onclick = () => {
                            for (let j = 0; j < childs.length; j++) {
                                childs[j].classList.toggle('selected', i == j);
                            }
                            send_request('/api/address/price.php?id=' + childs[i].getAttribute("address-id"), null, async (result) => {
                                if (result != null && result.success == 1) {
                                    pprice.innerHTML = result.price == null || result.price == 0 ? "Бесплатная" : result.price;
                                    pprice.parentElement.children[1].style.display = result.price == null || result.price == 0 ? "none" : "inline";
                                    price.innerHTML = Items.price - (-result.price);
                                } else {
                                    Notify.error(result.message)
                                }
                            });
                        }
                    }
                    childs[0].onclick();
                    buymenu.querySelector('.del-btn').onclick = () => {
                        send_request("/api/address/delete.php?", {'id': buymenu.querySelector('.address-item.selected').getAttribute('address-id')}, (result) => {
                            if (result.success == 1) {
                                Notify.info(result.message)
                                Popup.show('buy-menu')
                                // User.buy_menu();
                            } else {
                                Notify.error(result.message)
                            }
                        })
                    }
                } else {
                    buymenu.querySelector('.del-btn').onclick = null;
                }
                break;
            case 'orders':
                let orders = document.querySelector('[popups] [' + name + ']');
                orders.onclick = (event) => {
                    event.stopPropagation();
                }
                await Items.load_orders(orders);
                break;
            case 'add-address':
                let address = document.querySelector('[popups] [' + name + ']');
                address.onclick = (event) => {
                    event.stopPropagation();
                }
                address_info_load('add-address', (result) => {
                    if (result != null && result.success == 1) {
                        Notify.info(result.message);
                        Popup.hide('add-address');
                    } else {
                        Notify.error("Ошибка", result.message);
                    }
                }, 700);
                break;
        }

        let container = document.querySelector("[popups]");
        let controls = document.querySelector("[popups-controls]");
        let popup = container.querySelector('[' + name + ']');

        let rect = popup.getBoundingClientRect();
        controls.style.left = (rect.x + rect.width) + "px";
        controls.style.top = (rect.y) + "px";
    });
})