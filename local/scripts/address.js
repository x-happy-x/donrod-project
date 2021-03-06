class Code {

    code_item
    data
    addresses = ['state', 'area', 'city', 'locality', 'street', 'house'];
    length = [2, 3, 3, 3, 4, 4];

    constructor(selector) {
        this.code_item = document.querySelector(selector);
        this.data = {};
        for (let i = 0; i < this.addresses.length; i++)
            this.data[this.addresses[i] + '_id'] = '-'.repeat(this.length[i]);
        this.update();
    }

    set_code(code) {
        let code_parts = code.split('.')
        for (let i = 0; i < code_parts.length; i++)
            this.set_part_code(this.addresses[i], code_parts[i]);
    }

    set_part_code(address, code = null) {
        if (code == null)
            code = '-'.repeat(this.length[this.addresses.indexOf(address)]);
        console.log()
        let ifor = AddressForm.address_datalist.getAttribute('items-for').split(',');
        if (code === '0'.repeat(this.length[this.addresses.indexOf(address)]) && this.addresses.indexOf(address) > this.addresses.indexOf(ifor[0].trim())) {
            this.data[address + '_id'] = code.replaceAll('0', '-');
        } else {
            this.data[address + '_id'] = code;
        }
        // this.data[address + '_id'] = code;
        this.update();
    }

    update() {
        let text = '';
        for (let i = 0; i < this.addresses.length; i++)
            text += this.data[this.addresses[i] + '_id'].replaceAll('-', '0') + ' ';
        this.code_item.value = 'Код: ' + text;
    }
}

class AddressForm {
    static add;
    static address_code;
    static address_inputs;
    static address_datalist;
    static timer;
}

show_address_datalist = (input, i) => {
    send_request("/api/address/search.php?filter_street&find=" + input.getAttribute('address') + "&text=" + input.value, AddressForm.address_code.data, async(result) => {
        if (result.success === 1) {
            // AddressForm.address_datalist.innerHTML = "";
            // AddressForm.address_code.addresses.forEach(address => {
            // });
            let temp = await multi_template('address/help-item', result.datalist);
            AddressForm.address_datalist.setAttribute('items-for', result.message);
            // console.log(result.datalist.length);
            if (result.datalist.length == 0) {
                AddressForm.address_datalist.innerHTML = "<h4 class='input_datalist_title input_datalist_empty'>Неверный адрес</h4>";
            } else {
                AddressForm.address_datalist.innerHTML = "<h4 class='input_datalist_title'>Выберите адрес из списка</h4>" + temp;
            }
            AddressForm.address_datalist.querySelectorAll('[address-item]').forEach(item => {
                AddressForm.form.onclick = (event) => {
                    event.stopPropagation();
                    AddressForm.address_datalist.hidden = true;
                }
                item.onclick = () => {
                    let cdata = JSON.parse(JSON.stringify(AddressForm.address_code.data));
                    AddressForm.address_code.set_code(item.getAttribute('code'));
                    let data = AddressForm.address_code.data;
                    AddressForm.address_code.data = cdata;
                    send_request('/api/address/filter.php?find=' + AddressForm.address_datalist.getAttribute('items-for'), data, (result) => {
                        if (result.success == 1) {
                            input.value = item.getAttribute('real_name');
                            input.setAttribute('selected', input.value);
                            input.setAttribute('success', 'true');
                            AddressForm.address_code.set_code(item.getAttribute('code'));
                            for (let j = i + 1; j < AddressForm.address_inputs.length; j++) {
                                AddressForm.address_inputs[j].value = "";
                                AddressForm.address_inputs[j].setAttribute('selected', null);
                                AddressForm.address_inputs[j].disabled = j != i + 1;
                                AddressForm.address_inputs[j].setAttribute('success', 'false');
                                AddressForm.address_inputs[j].parentElement.querySelector('.placeholder').classList.toggle('show-placeholder', AddressForm.address_inputs[j].value.length > 0)
                            }
                            if (AddressForm.address_inputs[0].getAttribute('success') === 'true')
                                AddressForm.address_inputs[AddressForm.address_inputs.length - 2].disabled = false;
                            AddressForm.add.disabled = i + 1 != AddressForm.address_inputs.length;
                            let placeholder = input.parentElement.querySelector('.placeholder');
                            placeholder.innerText = item.getAttribute('type');
                            placeholder.classList.toggle('show-placeholder', input.value.length > 0)
                            AddressForm.address_datalist.hidden = true;
                            if (i + 1 < AddressForm.address_inputs.length) {
                                AddressForm.address_inputs[i + 1].focus();
                            } else {
                                AddressForm.form.focus();
                            }
                        } else {
                            Notify.error(result.message);
                        }
                    });
                }
            });
            AddressForm.address_datalist.hidden = false;
        } else {
            AddressForm.address_datalist.hidden = true;
        }
    });
}

address_info_load = (attr = 'add-address', on_add, pause = 500) => {
    let form = document.querySelector('[' + attr + ']');
    AddressForm.form = form;
    AddressForm.add = form.querySelector('#address_add');
    AddressForm.address_code = new Code('#address_code');
    AddressForm.address_inputs = form.querySelectorAll("input[address]");
    AddressForm.address_datalist = document.querySelector('#input_datalist');
    let checkbox = form.querySelector('#manyfloors')
    checkbox.onchange = () => {
        form.querySelector('#detail-table').hidden = !checkbox.checked;
    }
    let details_inputs = form.querySelectorAll("#detail-table .input-container");

    for (let i = 0; i < details_inputs.length; i++) {
        const input = details_inputs[i];
        input.onkeyup = (e) => {
            if (e.keyCode == 13 || e.keyCode == 9) {
                if (i + 1 < details_inputs.length) {
                    details_inputs[i + 1].querySelector('input').focus();
                } else {
                    form.focus();
                }
            }
        };
        input.oninput = () => {
            input.onchange();
        }
        input.onchange = () => {
            input.querySelector('.placeholder').classList.toggle('show-placeholder', input.querySelector('input').value.length > 0)
        }
    }
    for (let i = 0; i < AddressForm.address_inputs.length; i++) {

        const input = AddressForm.address_inputs[i];

        // Key up
        input.onkeyup = (e) => {
            if (e.keyCode == 13 && AddressForm.address_datalist.children.length > 1) {
                AddressForm.address_datalist.children[1].click();
                if (i + 1 < AddressForm.address_inputs.length) {
                    AddressForm.address_inputs[i + 1].focus();
                } else {
                    form.focus();
                }
            }
        };

        // Focus
        input.onfocus = () => {
            let input_rect = input.getBoundingClientRect();
            let form_rect = form.getBoundingClientRect();
            AddressForm.address_datalist.style['top'] = (input_rect.y - form_rect.y + input_rect.height) + 'px';
            //AddressForm.address_datalist.style['left'] = (input_rect.x - form_rect.x - 2) + 'px';
            //AddressForm.address_datalist.style['width'] = (input_rect.width) + 'px';
            input.oninput()
        };

        // Input
        input.onclick = (event) => {
            event.stopPropagation();
        };
        // Input
        let timer = -1;
        input.oninput = (event) => {
            if (input.value != input.getAttribute('selected')) {
                input.getAttribute('address').split(',').forEach(addr => {
                    AddressForm.address_code.set_part_code(addr.trim())
                })
                input.setAttribute('selected', null);
                input.setAttribute('success', 'false');
                for (let j = i + 1; j < AddressForm.address_inputs.length; j++) {
                    AddressForm.address_inputs[j].setAttribute('success', 'false');
                    AddressForm.address_inputs[j].disabled = true;
                    AddressForm.address_inputs[j].value = "";
                }

                if (AddressForm.address_inputs[0].getAttribute('success') === 'true')
                    AddressForm.address_inputs[AddressForm.address_inputs.length - 2].disabled = false;
                if (!AddressForm.add.disabled) AddressForm.add.disabled = true;
            }
            input.parentElement.querySelector('.placeholder').classList.toggle('show-placeholder', input.value.length > 0)
            clearTimeout(timer);
            timer = setTimeout(() => show_address_datalist(input, i), pause);
            // show_address_datalist(input, i);
        };
    }
    AddressForm.add.onclick = () => {
        AddressForm.address_code.data['house'] = AddressForm.address_inputs[AddressForm.address_inputs.length - 1].value;
        AddressForm.address_code.data['manyfloors'] = checkbox.checked;
        AddressForm.address_code.data['entrance'] = form.querySelector('input[name=entrance]').value;
        AddressForm.address_code.data['floor'] = form.querySelector('input[name=floor]').value;
        AddressForm.address_code.data['apartment'] = form.querySelector('input[name=apartment]').value;
        AddressForm.address_code.data['dcode'] = form.querySelector('input[name=dcode]').value;
        AddressForm.address_code.data['note'] = form.querySelector('input[name=note]').value;
        send_request('/api/address/add.php', AddressForm.address_code.data, on_add);
    }
}