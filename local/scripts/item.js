/**
 * Dependencies:
 * - main.js
 * - notify.js
 * - popups.js
 * - templates.js
 */

class Items {

    static real_price = 0;
    static price = 0;
    static items = [];
    static orders = [];
    static selected_item = -1;

    static update_one(item) {
        if (isInt(item))
            item = document.querySelector("[item-id='" + item + "']");
        let category = item.getAttribute('category');
        let index = item.getAttribute('data');
        let promotion = item.querySelector('[promotion]');
        let addons = Items.get_addons(item);
        let cart = Items.get_cart(item, category, index);

        let count = 0;
        let real_price = Items.items[category][index]['price'] - 0;
        let count_sk = Items.items[category][index]['count'] - 0;
        let weight = Items.items[category][index]['weight'] - 0;
        if (cart != null) {
            count = cart['count'] - 0;
        }
        // console.log(cart);
        let price = real_price;
        let orig_price = price;
        let exprom = false;
        let all_proms = [];
        let used_proms = [];
        for (let i = 0; i < addons.length; i++) {
            const addon = addons[i];
            let add_price = Items.items[category][index]['addons'][addon]['price'];
            let add_type = Items.items[category][index]['addons'][addon]['addon_type'];

            switch (add_type) {
                case 'money':
                    orig_price -= -add_price;
                    price -= -add_price;
                    break;
                case '%':
                    orig_price -= -real_price * add_price / 100;
                    price -= -real_price * add_price / 100;
            }
            ;
        }
        ;

        for (let i = 0; i < addons.length; i++) {
            const addon = addons[i];
            let curtime = new Date();
            let promotions = Items.items[category][index].addons[addon].promotions;
            for (let j = 0; j < promotions.length; j++) {
                exprom = true;
                let krit = promotions[j].worked_from_time == null || curtime >= new Date(promotions[j].worked_from_time); // От определенного времени
                krit = krit && (promotions[j].worked_to_time == null || curtime <= new Date(promotions[j].worked_to_time)); // До определенного времени
                if (krit)
                    all_proms.push(promotions[j]);
                else
                    continue;
                krit = krit && (promotions[j].worked_from_count == null || count >= promotions[j].worked_from_count); // От определенного количества
                krit = krit && (promotions[j].worked_to_count == null || count <= promotions[j].worked_to_count); // До определенного количества
                krit = krit && (promotions[j].worked_from_price == null || price * count >= promotions[j].worked_from_price); // От определенной цены
                krit = krit && (promotions[j].worked_to_price == null || price * count <= promotions[j].worked_to_price); // До определенной цены
                krit = krit && (promotions[j].worked_from_weight == null || weight >= promotions[j].worked_from_weight); // До определенного объема
                krit = krit && (promotions[j].worked_to_weight == null || weight <= promotions[j].worked_to_weight); // До определенного объема
                if (krit) {
                    used_proms.push([promotions[j], price]);
                    switch (promotions[j]['type']) {
                        case 'money':
                            price += (-promotions[j]['size']) / count;
                            break;
                        case '%':
                            price += -real_price * promotions[j]['size'] / 100;
                    }
                    ;
                }
            }
        }
        let socfull = item.querySelector('[soc-full]');
        let pricehistory = item.querySelector('[price-history]');
        if (pricehistory != null) {
            pricehistory.classList.toggle('hidden', used_proms.length == 0);
            pricehistory.onclick = async (event) => {
                event.stopPropagation();
                let mdiv = document.createElement('div');
                let t = "";
                used_proms.forEach((prom) => {
                    t += "<li><del accent>" + prom[1] + "₽</del> - " + prom[0].name + "</li>";
                });
                mdiv.innerHTML = await template("items/price-popup", {'list': t});
                socfull.innerHTML = mdiv.outerHTML;
                mdiv = socfull.lastElementChild;
                mdiv.style.marginTop = (item.querySelector('[description]').offsetTop + item.querySelector('[description]').offsetHeight - mdiv.offsetHeight + 20) + 'px';
            }
        }
        if (promotion != null) {
            promotion.hidden = !exprom;
            promotion.onclick = async (event) => {
                event.stopPropagation();
                let mdiv = document.createElement('div');
                mdiv.style.marginTop = (promotion.offsetTop + promotion.offsetHeight + 10) + 'px';
                let t = "";
                all_proms.forEach((prom) => {
                    let text = "<a>" + prom.name + "</a> - " + prom.text;
                    Object.keys(prom).forEach((key) => text = replace_template(text, key, prom[key]));
                    t += "<li>" + text + "</li>";
                });
                mdiv.innerHTML = await template("items/promotion-popup", {'list': t});
                socfull.innerHTML = mdiv.outerHTML;
            }
        }

        if (item.querySelector('[count-sk]') !== null) {
            item.querySelector("[count-sk]").innerHTML = (count_sk > 0 ? "x" + count_sk : "НЕТ В НАЛИЧИИ");
        }
        if (item.querySelector('[count]') !== null) {
            item.querySelector("[count]").innerHTML = count_sk == 0 ? "Нет в наличии" : count > 0 ? (item.querySelector('[cart-count]') !== null ? "x" : "") + count : "В КОРЗИНУ";
        }
        if (item.querySelector('[price]') !== null) {
            item.querySelector("[price]").innerHTML = count_sk == 0 ? "-" : price + "₽";
        }
        if (item.querySelector('[sum]') !== null) {
            item.querySelector("[sum]").innerHTML = price * count + "₽";
        }
        if (item.querySelector('[minus-cart]') !== null) {
            item.querySelector("[minus-cart]").parentNode.hidden = count == 0;
        }
        if (item.querySelector('[plus-cart]') !== null) {
            item.querySelector("[plus-cart]").parentNode.hidden = count == 0;
        }
    }

    static async pages(element, current, count, type, click, offset = 2) {

        let page_elements = offset * 2 + 1;
        let pages = [];

        if (current > 1) {
            if (count > page_elements) {
                pages.push({'type': type, 'page': 1, 'text': '<<', 'checked': ""});
            }
            // pages.push({'type': type, 'page': current - 1, 'text': '<', 'checked': ""});
        }

        let i = Math.max(1, current - 2);
        let pages_count = Math.min(count, current + 2);

        if (pages_count - i < page_elements) {
            if (i <= offset) {
                pages_count = Math.min(pages_count + page_elements - (pages_count - i + 1), count);
            } else {
                i = Math.max(pages_count - page_elements + 1, 1);
            }
        }

        for (; i <= pages_count; i++) {
            pages.push({'type': type, 'page': i, 'text': i, 'checked': current === i ? "checked" : ""});
        }

        if (current < count) {
            // pages.push({'type': type, 'page': current + 1, 'text': '>', 'checked': ""});
            if (count > page_elements) {
                pages.push({'type': type, 'page': count, 'text': '>>', 'checked': ""});
            }
        }

        element.innerHTML = await multi_template('elements/page', pages);
        element.querySelectorAll('input[name=page' + type + ']').forEach((element) => {
            element.onchange = () => click(element.getAttribute('page') - 0, count);
        });
    }

    static update(grid, item_selector) {
        grid.querySelectorAll(item_selector).forEach((item) => Items.update_one(item));
    }

    static in_cart_count() {
        let cart = document.querySelector('[body-top] [cart-overlay]');
        if (cart == null) return;
        let count = 0;
        for (let i = 1; i < Items.items.length; i++) {
            for (let j = 0; j < Items.items[i].length; j++) {
                for (let k = 0; k < Items.items[i][j]['cart'].length; k++) {
                    if (Items.items[i][j]['cart'][k]['count'] > 0) {
                        count++;
                    }
                }
            }
        }
        cart.querySelector('[cart-count]').innerText = count;
        cart.style.display = count === 0 ? "none" : "block";
    }

    static on_cart(item, add = true) {
        if (isInt(item))
            item = document.querySelector("[item-id='" + item + "']");
        let id = item.getAttribute('item-id') - 0;
        let step = item.getAttribute('step') - 0;
        let category = item.getAttribute('category');
        let index = item.getAttribute('data');

        let addon_array = Items.get_addons(item, true);
        let addons = addon_array.join(",");
        let cart = Items.get_cart(item, category, index);

        let count = 0;
        if (cart != null)
            count -= -cart['count'];
        let rc = count;
        count = count + step * (add ? 1 : -1);
        send_request(`/api/items/cart.php?change&id=${id}&count=${count}&prev=${rc}&addons=` + addons, null, result => {
            let cc = -1;
            if (result.success == 1) {
                cc = count;
            } else if (result.success == -1) {
                cc = result.count;
                Notify.info("Внимание", result.message);
            } else {
                Notify.error("Внимание", result.message);
            }
            if (cc != -1) {
                if (cart == null) {
                    if (Items.items[category][index]['cart'] == null)
                        Items.items[category][index]['cart'] = [];
                    Items.items[category][index]['cart'].push({
                        'id': -1,
                        'addons': addon_array,
                        'user': User.id,
                        'count': cc
                    });
                } else {
                    cart['count'] = cc;
                }
            }
            Items.update_one(item);
            Items.in_cart_count();
        });
    }

    static async load_categories(on_result) {
        await send_request('/api/items/list.php?categories', null, on_result);
    }

    static async load_orders(orders, page = 1) {
        await send_request("/api/items/list.php?orders&page=" + page + (User.on_crm ? '&all' : ''), null, async (result) => {
            if (result != null && result.success === 1) {
                if (result.orders === null || result.orders === undefined || result.orders.length === 0) {
                    // Notify.info(result.message);
                    orders.querySelector('[order-list]').innerHTML = "<div style='text-align:center;'>" + result.message + "</div>";
                    return;
                }
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
                        buyitem['item->image-path'] = order['image-path'];
                        buyitem['item->addon'] = addons.join(",");
                        buyitem['item->addon_name'] = addon_name.join(", ");
                    }
                    order['items'] = await multi_template('orders/item-line', order.buylist, {
                        'item->image': {
                            'item->image-url': {
                                null: 'icon-error.svg',
                                "": 'icon-error.svg'
                            },
                            'item->image-class': {
                                null: 'accent padding',
                                '': 'accent padding'
                            }
                        }
                    });
                    order['items-min'] = await multi_template('orders/item-rect', order.buylist, {
                        'item->image': {
                            'item->image-url': {
                                null: 'icon-error.svg',
                                "": 'icon-error.svg'
                            },
                            'item->image-class': {
                                null: 'accent padding',
                                '': 'accent padding'
                            }
                        }
                    });
                }
                orders.querySelector('[order-list]').innerHTML = await multi_template('orders/big-item', Items.orders);
                await Items.pages(orders.querySelector('[page-nav]'), result.current_page, result.pages, name, (page, all) => {
                    Items.load_orders(orders, page);
                });
            } else {
                Notify.error("Ошибка", result.message);
            }
        })
    }

    static get_addons(item, get_id = false) {
        let addons = item.querySelectorAll('.addons input');
        let checkeds = [];
        for (let i = 0; i < addons.length; i++) {
            if (addons[i].checked) {
                if (get_id) {
                    checkeds.push(addons[i].parentNode.getAttribute('addon-id'));
                } else {
                    checkeds.push(i);
                }
            }
        }
        return checkeds;
    }

    static get_cart(item, category = null, index = null) {
        if (category == null)
            category = item.getAttribute('category');
        if (index == null)
            index = item.getAttribute('data');
        let addons = Items.get_addons(item, true);
        let cart = Items.items[category][index]['cart'];
        for (let i = 0; i < cart.length; i++) {
            const c = cart[i];
            if (addons.length != c['addons'].length) continue;
            let b = true;
            for (let j = 0; j < c['addons'].length; j++) {
                if (!addons.includes(c['addons'][j])) {
                    b = false;
                    break;
                }
            }
            if (b) return c;
        }
        return null;
    }

    static async load_cart(grid, file, item_selector, category = 0) {
        let category_w = category == 0 ? '' : '&category=' + category;
        await send_request('/api/items/list.php?show-all' + category_w + '&cart=true', null, async (result) => {
            if (result == null || result instanceof String || result.success == 0) {
                Notify.error("Ошибка", result.message);
                return;
            } else if (result.success == 2) {
                Notify.info(result.message);
            }
            result = result.items;
            Items.items[category] = [];
            let index = 0;
            for (let i = 0; i < result.length; i++) {
                result[i]['addons-selector'] = await multi_template('items/cart-addon', result[i]['addons'], {
                    'name': {
                        'addon-text': {
                            '': 'Без тары',
                            null: 'Без тары'
                        }
                    }
                });
                result[i]['category'] = category;
                for (let j = 0; j < result[i]['cart'].length; j++) {
                    Items.items[category].push(JSON.parse(JSON.stringify(result[i])));
                    Items.items[category][Items.items[category].length - 1]['addons-selector'] = replace_template(Items.items[category][Items.items[category].length - 1]['addons-selector'], 'random', Math.random())
                    Items.items[category][Items.items[category].length - 1]['cart'] = [result[i]['cart'][j]];
                    Items.items[category][Items.items[category].length - 1]['index'] = index++;
                }
            }
            grid.innerHTML = await multi_template('items/' + file, Items.items[category], {
                image: {
                    'image-url': {
                        null: 'icon-error.svg'
                    },
                    'image-class': {
                        null: 'accent padding'
                    }
                }
            });
            let gridItems = grid.querySelectorAll(item_selector);
            for (let i = 0; i < Items.items[category].length; i++) {
                let item = gridItems[i];
                // console.log(item);
                let addons = item.querySelector('.addons');
                let aitems = addons.querySelectorAll('input');
                aitems.forEach(addon => {
                    addon.onchange = () => {
                        Items.update_one(item);
                    }
                })
                addons.hidden = aitems.length <= 1;
                Items.items[category][i]['cart'][0]['addons'].forEach(addon => {
                    item.querySelector("[addon-id='" + addon + "'] input").checked = true;
                });

                aitems.forEach(addon => {
                    addon.parentNode.parentNode.classList.toggle('hidden', !addon.checked);
                })
                if (item.querySelector('[from-cart]') !== null) {
                    item.querySelector('[from-cart]').onclick = (event) => {
                        let cart = Items.get_cart(item);
                        if (cart != null && cart['count'] > 0)
                            Items.on_cart(item, false, true);
                    }
                }
                if (item.querySelector('[to-cart]') !== null) {
                    item.querySelector('[to-cart]').onclick = (event) => {
                        let cart = Items.get_cart(item);
                        if (cart == null || cart['count'] == 0)
                            Items.on_cart(item, true);
                    }
                }

                if (item.querySelector('[minus-cart]') !== null) {
                    item.querySelector('[minus-cart]').onclick = (event) => {
                        Items.on_cart(item, false);
                    }
                }

                if (item.querySelector('[plus-cart]') !== null) {
                    item.querySelector('[plus-cart]').onclick = (event) => {
                        Items.on_cart(item, true);
                    }
                }
            }
            Items.update(grid, item_selector);
            Items.in_cart_count();
        });
    }

    static rating(item, event) {
        event.stopPropagation();
        send_request('/api/items/rating.php?', {
            'rating': item.getAttribute("rat-star"),
            'item': item.getAttribute("rat-item")
        }, (result) => {
            if (result.success == 1) {
                let p = item.closest("div.big-item");
                let r = p.querySelector('[rating]');
                item.parentNode.setAttribute('mrating', item.getAttribute('rat-star'));
                r.innerHTML = "Рейтинг: " + result.rating + " (" + result.count + ")";
                Notify.info(result.message);
            } else {
                Notify.error(result.message);
            }
        });
    }

    static async load(grid, file, item_selector, category = 0, onlycart = false, addon = 'addon') {
        let category_w = category == 0 ? '' : '&category=' + category;
        await send_request('/api/items/list.php?show-all' + category_w + '&cart=' + onlycart + (User.on_crm ? '&all' : ''), null, async (result) => {
            if (result == null || result instanceof String || result.success == 0) {
                Notify.error("Ошибка", result.message);
                return;
            } else if (result.success == 2) {
                Notify.info(result.message);
            }
            result = result.items;
            for (let i = 0; i < result.length; i++) {
                result[i]['addons-selector'] = await multi_template('items/' + addon, result[i]['addons'], {
                    'name': {
                        'addon-text': {
                            '': 'Без тары'
                        }
                    }
                });
                result[i]['category'] = category;
                result[i]['index'] = i;
            }
            grid.innerHTML = await multi_template('items/' + file, result, {
                'image': {
                    'image-url': {
                        null: 'icon-error.svg',
                        "": 'icon-error.svg'
                    },
                    'image-class': {
                        null: 'accent padding',
                        '': 'accent padding'
                    }
                }
            });
            Items.items[category] = result;
            let gridItems = grid.querySelectorAll(item_selector);
            for (let i = 0; i < gridItems.length; i++) {
                let item = gridItems[i];
                let rating = item.querySelector('[rating]');
                let socfull = item.querySelector('[soc-full]');

                item.onclick = (event) => {
                    event.stopPropagation();
                    socfull.innerHTML = "";
                }

                let addons = item.querySelector('.addons');
                let aitems = addons.querySelectorAll('input');
                for (let j = 0; j < aitems.length; j++) {
                    let addon_input = aitems[j];
                    addon_input.onchange = () => Items.update_one(item);
                    addon_input.checked = j == 0;
                }
                addons.hidden = aitems.length <= 1;
                if (item.querySelector('[from-cart]') !== null) {
                    item.querySelector('[from-cart]').onclick = (event) => {
                        let cart = Items.get_cart(item);
                        if (cart != null && cart['count'] > 0)
                            Items.on_cart(item, false, true);
                    }
                }
                if (item.querySelector('[to-cart]') !== null) {
                    item.querySelector('[to-cart]').onclick = (event) => {
                        let cart = Items.get_cart(item);
                        if (cart == null || cart['count'] == 0)
                            Items.on_cart(item, true);
                    }
                }

                if (item.querySelector('[minus-cart]') !== null) {
                    item.querySelector('[minus-cart]').onclick = (event) => {
                        Items.on_cart(item, false);
                    }
                }

                if (item.querySelector('[plus-cart]') !== null) {
                    item.querySelector('[plus-cart]').onclick = (event) => {
                        Items.on_cart(item, true);
                    }
                }

                // Rating
                if (rating != null) {
                    if (rating.getAttribute('rating') == '0') {
                        rating.innerHTML = "Нет оценок"
                    }
                    rating.hidden = false;
                    rating.onclick = async (event) => {
                        event.stopPropagation();
                        // console.log(rating.);
                        let mdiv = document.createElement('div');
                        mdiv.style.marginTop = (rating.offsetTop + rating.offsetHeight + 10) + 'px';
                        mdiv.innerHTML = await template('items/rating-popup', {
                            'item': item.getAttribute('item-id'),
                            'rating': result[i].myrating
                        });
                        socfull.innerHTML = mdiv.outerHTML;
                    }
                }
            }
            Items.update(grid, item_selector);
            Items.in_cart_count();
        });
    }
}