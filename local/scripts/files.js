function SizeSimplify(bytes, si = false, dp = 1) {
    const thresh = si ? 1000 : 1024;
    if (Math.abs(bytes) < thresh) {
        return bytes + ' B';
    }
    const units = si
        ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
    let u = -1;
    const r = 10 ** dp;
    do {
        bytes /= thresh;
        ++u;
    } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1);
    return bytes.toFixed(dp) + ' ' + units[u];
}
 
function setFileDrop(file_drop, file, filter) {
    file_drop.ondragleave = function (e) {
        if (file.files.length == 0) {
            if (file.multiple) {
                this.innerHTML = "Выберите файлы";
            } else {
                this.innerHTML = "Выберите файл";
            }
        } else {
            beforeDrop();
        }
        this.classList.remove("is-active");
        e.preventDefault();
    }
    file_drop.ondragover = function (e) {
        e.preventDefault();
    }
    file_drop.ondragenter = function (e) {
        if (file.multiple) {
            this.innerHTML = "Перетащите файлы сюда, чтоб загрузить";
        } else {
            this.innerHTML = "Перетащите файл сюда, чтоб загрузить";
        }
        this.classList.add("is-active");
        e.preventDefault();
    }
    function beforeDrop() {
        var f_counts = file.files.length;
        var size = 0;
        for (var i = 0; i < file.files.length; i++) {
            size += file.files[i]['size'];
        }
        if (f_counts == 1) {
            file_drop.innerHTML = file.files[0]['name'] + " [" + SizeSimplify(size) + "]";
        } else {
            file_drop.innerHTML = "Файлов загружено: " + f_counts + " [" + SizeSimplify(size) + "]";
        }
    }
    file_drop.ondrop = function (e) {
        file.files = e.dataTransfer.files;
        this.classList.remove("is-active");
        // Если нужны определённые
        // if (filter != undefined) {
        //     const data = new DataTransfer();
        //     let fs = e.dataTransfer.files;
        //     for (let i = 0; i < fs.length; i++) {
        //         if (filter(fs[i])) {
        //             data.items.add(fs[i]);
        //         }
        //     }
        //     file.files = data.files;
        // }
        beforeDrop();
        e.preventDefault();
    }
    file.onchange = function (e) {
        beforeDrop();
    }
}