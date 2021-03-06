/**
 * Dependencies:
 * - main.js
 * - popups.js
 * - notify.js
 * - items.js (open_cart)
 */

class User {

    static on_crm = false;
    static id = -1;
    static class = 5;
    static name = "";
    static mail = "";
    static signed = false;
    static popup;

    static update_status(event) {
        let sign_cb = User.popup.querySelector("#signin").checked;
        User.popup.querySelector("#profile-classes").hidden = User.signed || sign_cb;
        User.popup.querySelector("[sign-control]").hidden = User.signed;
        User.popup.querySelector("[title]").innerHTML = User.signed ? User.name : sign_cb ? "Авторизация" : "Регистрация";
        User.popup.querySelector("[subtitle]").innerHTML = User.signed ? User.mail : "";
        User.popup.querySelector("input[name=sign]").value = sign_cb ? "in" : "up";
        User.popup.querySelector("input[type=submit]").value = User.signed ? "Выход" : sign_cb ? "Авторизация" : "Регистрация";

        let priv = User.popup.querySelector("#privacy-message");
        priv.hidden = User.signed;
        priv.innerHTML = priv.innerHTML.replaceAll(!sign_cb ? "Авторизация" : "Регистрация", sign_cb ? "Авторизация" : "Регистрация");
        User.popup.querySelector("#signin").hidden = User.signed;
        User.popup.querySelector("[subtitle]").hidden = !User.signed;
        User.popup.querySelector("#crm-btn").hidden = !User.signed || User.class > 2;
        User.popup.querySelector("#orders-btn").hidden = !User.signed;
        User.popup.querySelector("#cart-btn").hidden = !User.signed;
        User.popup.querySelector("input[name=mail]").hidden = User.signed;
        User.popup.querySelector("input[name=pass]").hidden = User.signed;
        User.popup.querySelector("input[name=name]").hidden = User.signed || sign_cb;
    }

    static async submit(event) {
        if (event !== undefined) event.preventDefault();
        if (User.signed) {
            send_request("/api/users/auth.php?sign=exit", null, result => Notify.info("Внимание", "Вы вышли из учетной записи"));
            User.signed = false;
            User.update_status();
            run_on_update(User.after_auth, [User.signed]);
            if (!User.popup.hidden) {
                Popup.show('profile');
            }
        } else {
            send_request("/api/users/auth.php", get_form_data(User.popup), (result) => {
                if (result.success == 0)
                    Notify.error("Ошибка при " + (User.popup.querySelector("#signin").checked ? "авторизации" : "регистрации"), result.message)
                User.after_auth(result);
            });
        }
    }

    static auth(on_result) {
        send_request("/api/users/auth.php", null, (result) => {
            User.after_auth(result);
            if (on_result !== undefined && on_result !== null) on_result();
        })
    }
    static async add_address() {
        Popup.show('add-address');
    }

    static async buy_menu() {
        Popup.show('buy-menu');
    }

    static open_orders() {
        Popup.show('orders');
    }

    static async open_cart() {
        Popup.show('cart');
    }

    static after_auth(result) {
        User.signed = result.success === 1;
        if (User.signed) {
            User.id = result.user.id;
            User.class = result.user.class;
            User.name = result.user.name;
            User.mail = result.user.mail;
        }
        User.popup = document.querySelector("[profile]");
        User.popup.querySelector("#orders-btn").onclick = User.open_orders;
        User.popup.querySelector("#cart-btn").onclick = User.open_cart;

        User.popup.onclick = (event) => {
            event.stopPropagation();
        }
        User.popup.querySelector("#signin").onchange = User.update_status;
        User.popup.onsubmit = User.submit;
        User.update_status();
        run_on_update(User.after_auth, [User.signed]);
        if (!User.popup.hidden) {
            Popup.show('profile');
        }
    }
}