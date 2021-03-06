class Notify {

    static id = 0;
    static max = 5;
    static count = 0;
    static close_delay = 300;
    static wait = [];
    static notify_template_more = 'notify/notify-more';
    static notify_template_info = 'notify/notify-info';
    static notify_template_error = 'notify/notify-error';
    static notify_template_confrim = 'notify/notify-confrim';

    static quick_remove(id) {
        let container = document.querySelector('[notify]');
        container.querySelector("[notifyid='" + id + "']").remove();
        this.count--;
        if (this.wait.length > 0) {
            let new_notify = this.wait[0];
            this.wait.remove(0)
            new_notify[0].apply(this, new_notify[1]);
        }
    }

    static remove(id, delay) {
        setTimeout(() => {
            document.querySelector("[notify] [notifyid='" + id + "']").setAttribute("deleted", "true");
            setTimeout(() => this.quick_remove(id), this.close_delay);
        }, delay - this.close_delay);
    }

    static async info(title, text, delay = 5000) {
        let container = document.querySelector('[notify]');
        if (this.count >= this.max) {
            this.wait.push([this.info, [title, text, delay]]);
        } else {
            this.count++;
            let id = this.id++;
            let content = await template(this.notify_template_info, { 'id': id, 'title': title, 'text': text });
            let block = document.createElement('div');
            block.innerHTML = content;
            if (container.children.length == 1)
                container.appendChild(block.childNodes[0]);
            else
                container.insertBefore(block.childNodes[0], container.childNodes[2]);
            this.remove(id, delay);
        }

        let nmore = container.querySelector("[notify-block]");
        if (this.wait.length > 0) {
            let content = await template(this.notify_template_more, { 'count': this.wait.length, 'title': 'Ещё ' + this.wait.length + ' уведомлений' });
            let notify_more = document.createElement('div');
            notify_more.innerHTML = content;
            nmore.innerHTML = notify_more.innerHTML;
        } else {
            nmore.innerHTML = "";
        }
    }

    static async error(title, text, delay = 5000) {
        let container = document.querySelector('[notify]');
        if (this.count >= this.max) {
            this.wait.push([this.error, [title, text, delay]]);
        } else {
            this.count++;
            let id = this.id++;
            let content = await template(this.notify_template_error, { 'id': id, 'title': title, 'text': text });
            let block = document.createElement('div');
            block.innerHTML = content;
            if (container.children.length == 1)
                container.appendChild(block.childNodes[0]);
            else
                container.insertBefore(block.childNodes[0], container.childNodes[2]);
            this.remove(id, delay);
        }

        let nmore = container.querySelector("[notify-block]");
        if (this.wait.length > 0) {
            let content = await template(this.notify_template_more, { 'count': this.wait.length, 'title': 'Ещё ' + this.wait.length + ' уведомлений' });
            let notify_more = document.createElement('div');
            notify_more.innerHTML = content;
            nmore.innerHTML = notify_more.innerHTML;
        } else {
            nmore.innerHTML = "";
        }
    }

    static async confirm(title, text, on_yes = null, on_no = null, yes = "Подтвердить", no = "Закрыть") {
        let container = document.querySelector('[notify]');
        if (this.count >= this.max) {
            this.wait.push([this.confirm, [title, text, on_yes, on_no, yes, no]]);
        } else {
            this.count++;
            let id = this.id++;
            let content = await template(this.notify_template_confirm, { 'id': id, 'title': title, 'text': text });
            let block = document.createElement('div');
            block.innerHTML = content;
            if (container.children.length == 1)
                container.appendChild(block.childNodes[0]);
            else
                container.insertBefore(block.childNodes[0], container.childNodes[2]);
            container.querySelector("[notifyid='" + id + "'] [yes]").innerHTML = yes
            container.querySelector("[notifyid='" + id + "'] [no]").innerHTML = no
            container.querySelector("[notifyid='" + id + "'] [yes]").onclick = (event) => {
                if (on_yes !== undefined && on_yes !== null) on_yes(event);
                container.querySelector("[notifyid='" + id + "']").setAttribute("deleted", "true");
                setTimeout(() => this.remove(id), this.close_delay);
            }

            container.querySelector("[notifyid='" + id + "'] [no]").onclick = (event) => {
                if (on_no !== undefined && on_no !== null) on_no(event);
                container.querySelector("[notifyid='" + id + "']").setAttribute("deleted", "true");
                setTimeout(() => this.remove(id), this.close_delay);
            }
        }

        let nmore = container.querySelector("[notify-block]");
        if (this.wait.length > 0) {
            let content = await template(this.notify_template_more, { 'count': this.wait.length, 'title': 'Ещё ' + this.wait.length + ' уведомлений' });
            let notify_more = document.createElement('div');
            notify_more.innerHTML = content;
            nmore.innerHTML = notify_more.innerHTML;
        } else {
            nmore.innerHTML = "";
        }
    }
}