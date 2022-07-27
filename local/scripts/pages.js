class Page {

    static history = [];
    static loaded = [];
    static current;
    static prevent = false;

    static async load(name, on_result) {
        let content = await get_file('/templates/pages/' + name + '.html');
        if (content[0] != 200) {
            Notify.error("Ошибка "+content[0], content[1]);
            return null;
        }
        content = content[2];
        let container = document.querySelector('[pages]');
        let result = null;
        if (container !== null) {
            let block = document.createElement('div');
            block.innerHTML = content;
            block = block.children[0];
            let page = container.querySelector('[' + name + ']');
            if (page !== null) page.remove();
            container.appendChild(block)
            result = container.lastChild;
        } else {
            Notify.error("Не удалось открыть меню");
        }
        if (on_result !== undefined && on_result !== null)
            await on_result(result);
        if (result != null)
            Page.loaded.push(name);
        return result;
    }

    static set_navigation(list) {
        let nav = document.querySelector('[nav-menu-extended]');
        let x = "";
        let sep = "";
        for (let i = 0; i < list.length; i++) {
            if (list[i].length == 0) {
                sep = " separate";
                continue;
            }
            x += "<li" + sep + "><a id='menu-item-" + i + "' class='menu-item'>" + list[i][0] + "</a></li>";
            if (sep.length > 0)
                sep = "";
        };
        nav.innerHTML = "<ul>" + x + "</ul>";

        for (let i = 0; i < list.length; i++) {
            if (list[i].length == 0) continue;
            let navi = nav.querySelector('#menu-item-' + i)
            navi.onclick = () => {
                for (let j = 0; j < list.length; j++) {
                    if (list[j].length > 0)
                        nav.querySelector('#menu-item-' + j).classList.toggle("selected", j == i);
                }
                switch (list[i][1]) {
                    case "page":
                        Page.show(list[i][2]);
                        break;
                    case "popup":
                        Popup.show(list[i][2]);
                        break;
                    default:
                        list[i][2]();
                        break;
                }
            }
        }
    }

    static change_visible(name, event, visible) {
        if (event !== undefined) event.stopPropagation();
        let container = document.querySelector("[pages]");
        let controls = document.querySelector("[pages-controls]");
        let page = container.querySelector('[' + name + ']');
        if (page !== null) {
            visible = visible !== undefined ? visible : page.hidden;
            page.hidden = !visible;
            page.onclick = (event) => {
                event.stopPropagation();
            }
            let nvisible = Page.history.length > 0;
            container.hidden = !nvisible;

            let main_body = document.querySelector('[body]');
            let actionbar = document.querySelector('[action-bar]');
            let nav = document.querySelector('[nav-menu-extended]');

            if (visible) {
                actionbar.querySelector('#current-state').innerHTML = page.getAttribute(name);
                actionbar.querySelector('#current-state').onclick = Page.back;
            }

            // document.querySelector('[body]').classList.toggle('blurred', nvisible);
            // document.querySelector('[body-top]').classList.toggle('blurred', nvisible);
            // document.querySelector('[body-shadow]').hidden = !nvisible;

            // if (visible) {
            //     controls.style.opacity = 0;
            //     controls.hidden = false;
            //     page.onchange = () => {
            //         let rect = page.getBoundingClientRect();
            //         controls.style.left = (rect.x + rect.width) + "px";
            //         controls.style.top = (rect.y) + "px";
            //     }
            //     add_on_resize(() => {
            //         let rect = page.getBoundingClientRect();
            //         controls.style.left = (rect.x + rect.width) + "px";
            //         controls.style.top = (rect.y) + "px";
            //     });
            //     controls.style.opacity = 1;
            // } else {
            //     controls.hidden = true;
            // }
        }
    }

    static async show(name, event, close_prevent = false) {
        if (close_prevent) Page.hideAll(event);
        if (document.querySelector("[pages] [" + name + "]") == null)
            Page.load(name, (result) => {
                if (result != null) Page.show(name, event)
            });
        else {
            this.current = name;
            Page.prevent = false;
            await run_on_update(Page.show, [name]);
            if (!Page.prevent && Page.history[Page.history.length - 1] != name) {
                Page.hide(Page.history[Page.history.length - 1], event, false, false);
                Page.history.push(name);
                Page.change_visible(name, event, true);
            }
        }
    }

    static close(event) {
        Page.hideAll(event);
    }

    static back(event) {
        if (Page.history.length > 1) {
            Page.hide(Page.history.pop(), event, false);
        } else {
            // Page.close(event);
        }
    }

    static hide(name, event, remove_history = true, open_prev = true) {
        if (remove_history)
            Page.history.removeByValue(name);
        Page.change_visible(name, event, false);
        run_on_update(Page.hide, [name]);
        if (open_prev && Page.history.length > 0) {
            Page.show(Page.history.pop(), event);
        }
    }

    static hideAll(event) {
        Page.loaded.forEach(page => this.hide(page, event, true, false));
    }
}
// 2.1 разработка сайта .1 бэк .2 фронт.
add_on_loads(() => {
    add_on_update(Page.hide, (name) => {

    })
    add_on_update(Page.show, async(name) => {
        let main_body = document.querySelector('[body]');
        switch (name) {
            case 'items':
                Items.load_categories(async(result) => {
                    if (result == null || result.success == 0) {
                        Notify.error('Ошибка доступа', result.message);
                    } else {
                        let page = main_body.querySelector(".items");
                        page.innerHTML = "";
                        for (let i = 0; i < result.length; i++) {
                            let catblock = document.createElement('div')
                            catblock.innerHTML = await template("items/category", result[i]);
                            let block = document.createElement('table');
                            block.classList.add('linear');
                            catblock.appendChild(block)
                            page.appendChild(catblock);
                            await Items.load(block, 'linear-item-full', '.mini-item', result[i].id)
                            block.querySelectorAll('.mini-item').forEach(item => {
                                item.querySelectorAll("input[type=checkbox]").forEach(input_check => {input_check.checked = false; });
                                item.querySelectorAll("input[type=radio]").forEach(input_check => {input_check.checked = false; });
                                item.onclick = (e) => {
                                    e.stopPropagation();
                                    Items.selected_item = item.getAttribute('item-id');
                                    Popup.show('admin-item-full');
                                }
                            });
                            Items.selected_item = -1;
                        }
                    }
                });
                break;
            case 'orders':
                let orders = document.querySelector('[popups] [' + name + ']');
                orders.onclick = (event) => {
                    event.stopPropagation();
                }
                await send_request("/api/items/list.php?orders", null, async (result) => {
                    if (result != null && result.success == 1) {
                        if (result.orders === null || result.orders === undefined || result.orders.length === 0) {
                            // Notify.info(result.message);
                            orders.querySelector('[order-list]').innerHTML = "<div style='text-align:center;'>" + result.message + "</div>";
                            return;
                        }
                        ;
                        Items.orders = result.orders;
                        for (let i = 0; i < Items.orders.length; i++) {
                            const order = Items.orders[i];
                            const address = order['address'];

                            address['full'] = await multi_template('address/item-line', address['full']);
                            address['mf'] = address['manyfloors'];
                            address['manyfloors'] = address['manyfloors'] === 1 ? "" : 'hidden';
                            address['note'] = address['note'] === null ? "" : address['note'].replaceAll("\"", "''");

                            order['address-full'] = await template('orders/address-line', address);
                            for (let j = 0; j < order.buylist.length; j++) {
                                const buyitem = order.buylist[j];
                                let addons = [];
                                let addon_name = [];
                                for (let k = 0; k < buyitem['item'].length; k++) {
                                    const item = buyitem['item'][k];
                                    addons.push(item.addon)
                                    addon_name.push(item.addon_name.length > 0 ? item.addon_name.toLowerCase() : "без тары")
                                }
                                Object.keys(buyitem.item[0]).forEach(key => {
                                    buyitem['item->' + key] = buyitem.item[0][key];
                                });
                                buyitem['item->addon'] = addons.join(",");
                                buyitem['item->addon_name'] = addon_name.join(", ");
                            }

                            order['items'] = await multi_template('orders/item-line', order.buylist);
                        }
                        orders.querySelector('[order-list]').innerHTML = await multi_template('orders/big-item', Items.orders);
                    } else {
                        Notify.error("Ошибка", result.message);
                    }
                });
                break;
            default:
                break;
        }
    });
})