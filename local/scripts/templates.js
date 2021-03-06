let loaded_templates = [];
// Замена ключа на значение
replace_template = (text, key, value) => {
    return text.replaceAll("{% " + key + " %}", value == null ? '' : value);
};
// Шаблонизатор файла
template = async(name, row = null) => {
    let file = "/templates/" + name + ".html";
    let text;
    if (file in loaded_templates) {
        text = loaded_templates[file];
    } else {
        text = await get_file(file);
        if (text[0] != 200) {
            Notify.error("Ошибка "+text[0], text[1]);
            return "";
        }
        text = text[2];
        loaded_templates[file] = text;
    }
    if (row != null)
        Object.keys(row).forEach((key) => text = replace_template(text, key, row[key]));
    return text;
};
// Мульти-шаблонизатор файла
multi_template = async(name, result, where = null, else_ = null, default_else = '') => {
    let file = "/templates/" + name + ".html";
    let temp;
    if (file in loaded_templates) {
        temp = loaded_templates[file];
    } else {
        temp = await get_file(file);
        if (temp[0] != 200) {
            Notify.error("Ошибка "+temp[0], temp[1]);
            return "";
        }
        temp = temp[2];
        loaded_templates[file] = temp;
    }
    let output = "";
    if (result != null && result.length > 0) {
        result.forEach((row) => {
            let output_part = temp;
            Object.keys(row).forEach((key) => output_part = replace_template(output_part, key, row[key]));
            if (where != null) {
                Object.keys(where).forEach((key) => {
                    if (key in row) {
                        Object.keys(where[key]).forEach((key2) => {
                            if (row[key] in where[key][key2]) {
                                output_part = replace_template(output_part, key2, where[key][key2][row[key]]);
                            } else if (else_ != null && key2 in else_) {
                                output_part = replace_template(output_part, key2, else_[key2])
                            } else {
                                output_part = replace_template(output_part, key2, default_else)
                            }
                        });
                    }
                });
            }
            output += output_part;
        });
    }
    return output;
};