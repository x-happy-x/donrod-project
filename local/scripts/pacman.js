class Pacman {

    block_types_pac = ['0', '1', '2', '3', '4', '9'];
    block_types_ghosts = ['0', '1', '2', '4', 'l', '9'];
    block_no_pictures = ['0', '3', '5', '6', '7', '8', '9'];
    image_type = [
        'fruct_small.png',
        'fruct_big.png',
        'outborder_line.png',
        'outborder_angle.png',
        'outborder_mixed.png',
        'inborder_line.png',
        'inborder_angle.png',
        'border.png',
        'line.png'
    ];
    blocks = {
        '2': [0, 0], // small point
        '4': [1, 0], // big point
        '5': ['5', '#ff6663', [
            [0, 0],
            [0, 0]
        ],
            ["up"], 0, 10, ["up"],
            ['0']
        ], // ghost 1
        '6': ['6', '#F0F', [
            [0, 0],
            [0, 0]
        ],
            ["up"], 0, 10, ["up"],
            ['0']
        ], // ghost 2
        '7': ['7', '#FF0', [
            [0, 0],
            [0, 0]
        ],
            ["up"], 0, 10, ["up"],
            ['0']
        ], // ghost 3
        '8': ['8', '#0FF', [
            [0, 0],
            [0, 0]
        ],
            ["up"], 0, 10, ["up"],
            ['0']
        ], // ghost 4
        'a': [3, 270], // outborder down right
        'b': [3, 0], // outborder down left
        'c': [3, 180], // outborder top right
        'd': [3, 90], // outborder top left
        'v': [2, 90], // outborder vertical
        'h': [2, 0], // outborder horizontal
        'e': [5, 90], // inborder vertical
        'f': [5, 0], // inborder horizontal
        'x': [6, 0], // inborder down left
        'z': [6, 270], // inborder down right
        'w': [6, 180], // inborder top right
        'p': [6, 90], // inborder top left
        'y': [4, 90], // outborder vertical left mixed
        'q': [4, 270], // outborder vertical right mixed
        'u': [4, 180], // outborder horizontal top mixed
        't': [4, 0], // outborder horizontal down mixed
        'k': [7, 0], // base border
        'l': [8, 0], // baseline
    }

    loseDelta = 0;
    loseUpd = false;

    score = 0;
    lives = 3;
    s = 5;
    map;
    w = 74;
    h = 33;
    cord = [38, 25];
    cord_pacman = [
        [38, 25],
        [38, 25],
        [0, 0]
    ];
    canvas;
    parent;
    ctx;
    images = [];
    ghosts = [];
    all_points = 0;
    pointF = false;

    new_dir = ['left'];
    current_dir = ['left'];
    dir = -10;
    pct_open = 100;
    delta = 30;
    is_draw = 0;
    firstDraw = false;
    lose = false;
    pause = true;
    start = true;
    live_cord = [9, this.h - 2];
    ghost_eat = false;
    ghost_eat_confirm = false;

    constructor(map, canvas_q = "#canvas", parent_q = "#parent", images = '/images/pacman/') {
        this.load_images(images);
        this.load_map(map, canvas_q, parent_q).then(r => {
        });
        const game = this;
        document.addEventListener('keydown', (event) => game.keydown(game, event));
    }

    // Обработчик рендера
    render(game) {
        if (game.pause) {
            game.is_draw = 0;
            game.update_map();
        }
        let i;
        for (i = 0; i < game.ghosts.length; i++) {
            game.update_map_part(game.ghosts[i][2][0]);
        }
        game.drawPacman((game.current_dir)[0] === 'stop' ? game.pct_open : game.pct_open += game.dir);
        for (i = 0; i < game.ghosts.length; i++) {
            game.drawGhost(game.ghosts[i][4] += game.ghosts[i][5], game.ghosts[i][2], game.ghosts[i][1]);
            if (game.ghosts[i][4] % 100 === 0) {
                game.ghosts[i][5] *= -1;
            }
        }
        if (game.pct_open >= 100) {
            game.dir = -10;
        } else if (game.pct_open <= 0) {
            game.dir = 10;
        }
        if (game.pause) {
            if (game.start) {
                game.show_title("НАЖМИТЕ ENTER ЧТОБЫ НАЧАТЬ");
            } else {
                game.show_title("ИГРА ПРИОСТАНОВЛЕНА");
            }
        } else if (game.lives === 0) {
            game.show_title("ИГРА ЗАКОНЧЕНА");
        } else if (game.all_points === 0) {
            game.ghost_eat = true;
            game.show_title("ПОЗДРАВЛЯЮ ВЫ ПОБЕДИЛИ");
        }
    }

    // Обработчик нажатий клавиш
    keydown(game, event) {
        if (event.code === 'ArrowLeft') {
            game.new_dir[0] = 'left';
        } else if (event.code === 'ArrowRight') {
            game.new_dir[0] = 'right';
        } else if (event.code === 'ArrowUp') {
            game.new_dir[0] = 'up';
        } else if (event.code === 'ArrowDown') {
            game.new_dir[0] = 'down';
        } else if (event.code === 'KeyP') {
            game.pause = !game.pause;
            if (game.start) game.start = false;
        } else if (event.code === 'KeyR') {

        } else if (event.code === 'Enter') {
            game.start = false;
            game.pause = !game.pause;
            game.update_map();
        }
    }

    // Обработчик движений
    motion(game) {
        if (!game.pause) {
            for (let i = 0; i < game.ghosts.length; i++) {
                game.set_rand_dir(game.ghosts[i][2][1], game.ghosts[i][6], game.ghosts[i][3]);
                if (game.ghosts[i][2][0][1] - 0.8 < (game.cord_pacman)[0][1] &&
                    (game.cord_pacman)[0][1] < game.ghosts[i][2][0][1] + 0.8 &&
                    game.ghosts[i][2][0][0] - 0.8 < (game.cord_pacman)[0][0] &&
                    (game.cord_pacman)[0][0] < game.ghosts[i][2][0][0] + 0.8) {
                    if (!game.ghost_eat) game.lose = true;
                    else {
                        game.ghosts[i][2][1] = game.copy(game.ghosts[i][2][2]);
                        game.score += 100;
                    }
                }
                game.move(game.ghosts[i][2][1], game.ghosts[i][2], game.ghosts[i][3], game.ghosts[i][6], game.ghosts[i][7], false);
            }
            if (!game.lose) game.move(game.cord, game.cord_pacman, game.current_dir, game.new_dir, ['3'], true);
        }
    }

    // Загрузка карты
    async load_map(map, canvas_q, parent_q) {
        let data = await get_file('/templates/maps-pacman/' + map);
        if (data[0] === 200) {
            this.set_map(data[2], canvas_q, parent_q);
        } else {
            await Notify.error("Не удалось загрузить карту", data[1]);
        }
    }

    // Установка карты
    set_map(content, canvas_q, parent_q) {
        this.map = content.replaceAll("\r", "").split('\n');
        this.w = this.map[0].length - 2;
        this.h = this.map.length - 2;
        for (let i = 0; i < this.h; i++) {
            for (let j = 0; j < this.w; j++) {
                if (this.map[i].substr(j,1) === '9') {
                    this.cord[0] = j;
                    this.cord[1] = i;
                    break;
                }
            }
        }
        this.map[this.cord[1]] = this.map_replace(this.cord[1], this.cord[0], '9');
        this.show_map(canvas_q, parent_q);
    }

    // Показ карты
    show_map(canvas_q, parent_q) {
        this.canvas = document.querySelector(canvas_q);
        this.parent = document.querySelector(parent_q);
        this.canvas.width = this.parent.offsetWidth / 1.2;
        this.canvas.height = this.canvas.width / this.w * this.h;
        this.s = this.canvas.width / this.map[0].length;
        this.ctx = this.canvas.getContext("2d");
        this.is_draw = 2;
        this.update_map();
    }

    // Обновление части карты
    update_map_part(pos) {
        for (let i = Math.floor(pos[1] - 1); Math.floor(pos[1] + 2) >= i; i++) {
            for (let j = Math.floor(pos[0] - 1); Math.floor(pos[0] + 2) >= j; j++) {
                //ctx.fillStyle = block_color[map[i][j]];
                //ctx.fillRect(j*s,i*s,s,s);
                if (i < 0 || i > this.h || j < 0 || j > this.w) continue;
                if (this.block_no_pictures.indexOf(this.map[i][j]) !== -1) {
                    this.ctx.clearRect(j * this.s, i * this.s, this.s, this.s);
                    continue;
                }
                const block = this.blocks[this.map[i][j]];
                this.draw_image(this.images[block[0]], j * this.s, i * this.s, this.s, this.s, block[1]);
            }
        }
    }

    // Обновление всей карты
    update_map() {
        if (this.is_draw < 3) {
            if (!this.firstDraw) this.ghosts = [];
            for (let i = 0; i < this.map.length; i++) {
                for (let j = 0; j < this.map[i].length; j++) {
                    if (!this.pointF && (this.map[i][j] === '2' || this.map[i][j] === '4')) this.all_points++;
                    if (!this.firstDraw) {
                        if (this.map[i][j] === '5' || this.map[i][j] === '6' || this.map[i][j] === '7' || this.map[i][j] === '8') {
                            this.ghosts.push(this.copy(this.blocks[this.map[i][j]]));
                            this.ghosts[this.ghosts.length - 1][2] = [
                                [j, i],
                                [j, i],
                                [j, i]
                            ];
                            continue;
                        } else if (this.map[i][j] === '9') {
                            this.cord_pacman[2] = [j, i];
                            continue;
                        }
                    }
                    if (this.block_no_pictures.indexOf(this.map[i][j]) !== -1) {
                        this.ctx.clearRect(j * this.s, i * this.s, this.s, this.s);
                        continue;
                    }
                    const block = this.blocks[this.map[i][j]];
                    if (!block) continue;
                    this.draw_image(this.images[block[0]], j * this.s, i * this.s, this.s, this.s, block[1]);
                }
            }
            this.pointF = true;
            this.is_draw++;
        }
        if (!this.firstDraw) {
            this.cord = this.copy(this.cord_pacman[2]);
            this.cord_pacman[0] = this.copy(this.cord_pacman[2]);
            this.cord_pacman[1] = this.copy(this.cord_pacman[2]);
            this.firstDraw = true;
        }

        this.ctx.clearRect((this.live_cord[0] - 6) * this.s, (this.live_cord[1] - 4) * this.s, (12) * this.s, this.s * 6)
        this.ctx.fillStyle = "#ff6663";
        this.ctx.textAlign = 'left';
        this.ctx.font = this.s * 1.2 + "px Arial";
        this.ctx.fillText("LIVES:", (this.live_cord[0] - 6) * this.s, this.live_cord[1] * this.s + this.s / 1.1);
        this.ctx.fillText("SCORE:", (this.live_cord[0] - 6) * this.s, (this.live_cord[1] - 2) * this.s + this.s / 1.1);
        this.ctx.fillText("" + this.score, (this.live_cord[0]) * this.s, (this.live_cord[1] - 2) * this.s + this.s / 1.1);
        for (let i = 0; i < this.lives; i++) {
            this.ctx.beginPath();
            this.ctx.arc((this.live_cord[0] + i * 2) * this.s + this.s / 2, this.live_cord[1] * this.s + this.s / 2, this.s / 1.6, (1 + (this.lose && i === this.lives - 1 ? this.loseDelta : 1) * 0.2) * Math.PI, (1 - (this.lose && i === this.lives - 1 ? this.loseDelta : 1) * 0.2) * Math.PI);
            this.ctx.lineTo((this.live_cord[0] + i * 2) * this.s + this.s / 2, this.live_cord[1] * this.s + this.s / 2);
            this.ctx.closePath();
            this.ctx.fillStyle = "#FF0";
            this.ctx.fill();
            this.ctx.strokeStyle = '#000';
            this.ctx.stroke();
        }
    }

    // Загрузка изображений
    load_images(path) {
        for (let i = 0; i < this.image_type.length; i++) {
            this.images.push(new Image(this.s, this.s));
            (this.images)[i].src = path + (this.image_type)[i];
        }
    }

    // Рисование изображения
    draw_image(image, x, y, w, h, rotation) {
        let angle = rotation / 180 * Math.PI;
        this.ctx.save();
        this.ctx.translate(x + w / 2, y + h / 2);
        this.ctx.rotate(angle);
        this.ctx.translate(-x - w / 2, -y - h / 2);
        this.ctx.drawImage(image, x, y, w, h);
        this.ctx.restore();
    }

    // Показ заголовков
    show_title(text, color = "#ff6663", bg = "#ffffff") {
        let w1 = this.s * 30;
        let h1 = this.s * 3;
        let x1 = (this.w + 2) * this.s / 2 - w1 / 2;
        let y1 = (this.h - 3) * this.s / 2;
        let grd = this.ctx.createLinearGradient(x1, y1, x1 + w1, y1 + h1);
        grd.addColorStop(0, bg + "00");
        grd.addColorStop(0.2, bg + "ff");
        grd.addColorStop(0.8, bg + "ff");
        grd.addColorStop(1, bg + "00");
        this.ctx.fillStyle = grd;
        this.ctx.fillRect(x1, y1, w1, h1);
        grd = this.ctx.createLinearGradient(x1, y1, x1 + w1, y1 + h1);
        grd.addColorStop(0, color + "00");
        grd.addColorStop(0.2, color + "ff");
        grd.addColorStop(0.8, color + "ff");
        grd.addColorStop(1, color + "00");
        this.ctx.fillStyle = grd;
        this.ctx.fillRect(x1, y1, w1, 2);
        this.ctx.fillRect(x1, y1 + h1 - 2, w1, 2);
        this.ctx.fillStyle = "#000";
        this.ctx.textAlign = 'center';
        this.ctx.font = (h1 / 2.5) + "px Arial";
        this.ctx.fillText(text, x1 + w1 / 2, y1 + h1 / 1.5);
    }

    // Копирование объекта
    copy(aObject) {
        if (!aObject) {
            return aObject;
        }
        let v;
        let bObject = Array.isArray(aObject) ? [] : {};
        for (const k in aObject) {
            v = aObject[k];
            bObject[k] = (typeof v === "object") ? this.copy(v) : v;
        }
        return bObject;
    }

    // Рисование пэкмена
    drawPacman(pctOpen) {
        this.clearPacman();
        this.cord_pacman[0][0] += (this.cord_pacman[1][0] - this.cord_pacman[0][0]) / 4;
        this.cord_pacman[0][1] += (this.cord_pacman[1][1] - this.cord_pacman[0][1]) / 4;
        let fltOpen = pctOpen / 100;
        if (fltOpen === 0) fltOpen = 0.01
        if (this.lose) {
            if (this.loseDelta < 4.9) this.loseDelta += 0.1;
            else {
                this.loseDelta = 4.99;
                if (!this.loseUpd && this.lives > 0) {
                    const game = this;
                    setTimeout(() => this.game_lose(game), 1000);
                    this.loseUpd = true;
                }
            }
        }
        this.drawArc(this.lose ? this.loseDelta : fltOpen, this.current_dir[0] === 'stop' ? this.new_dir : this.current_dir);
    }

    // Рисование дуги с заливкой
    drawArc(fltOpen, _dir_, color = "#ffff00", stroke = "#000000") {
        this.ctx.beginPath();
        if (_dir_[0] === 'left') {
            this.ctx.arc(this.cord_pacman[0][0] * this.s + this.s / 2, this.cord_pacman[0][1] * this.s + this.s / 2, this.s / 1.6, (1 + fltOpen * 0.2) * Math.PI, (1 - fltOpen * 0.2) * Math.PI);
        } else if (_dir_[0] === 'right') {
            this.ctx.arc(this.cord_pacman[0][0] * this.s + this.s / 2, this.cord_pacman[0][1] * this.s + this.s / 2, this.s / 1.6, (fltOpen * 0.2) * Math.PI, (2 - fltOpen * 0.2) * Math.PI);
        } else if (_dir_[0] === 'up') {
            this.ctx.arc(this.cord_pacman[0][0] * this.s + this.s / 2, this.cord_pacman[0][1] * this.s + this.s / 2, this.s / 1.6, (1.5 + fltOpen * 0.2) * Math.PI, (1.5 - fltOpen * 0.2) * Math.PI);
        } else if (_dir_[0] === 'down') {
            this.ctx.arc(this.cord_pacman[0][0] * this.s + this.s / 2, this.cord_pacman[0][1] * this.s + this.s / 2, this.s / 1.6, (0.5 + fltOpen * 0.2) * Math.PI, (0.5 - fltOpen * 0.2) * Math.PI);
        }
        this.ctx.lineTo(this.cord_pacman[0][0] * this.s + this.s / 2, this.cord_pacman[0][1] * this.s + this.s / 2);
        this.ctx.closePath();
        this.ctx.fillStyle = color;
        this.ctx.fill();
        this.ctx.strokeStyle = stroke;
        if (this.loseDelta < 4.5) this.ctx.stroke();
    }

    // Очистка пэкмена
    clearPacman() {
        this.ctx.beginPath();
        this.ctx.arc(this.cord_pacman[0][0] * this.s + this.s / 2, this.cord_pacman[0][1] * this.s + this.s / 2, this.s / 1.4, 0, 2 * Math.PI);
        this.ctx.fillStyle = "#FFF";
        this.ctx.fill();
    }

    // Пэкмен был сьеден
    game_lose(game) {
        game.lives--;
        if (game.lives > 0) {
            game.lose = false;
            game.loseDelta = 0;
            game.loseUpd = false;
            game.new_dir[0] = 'left';
            game.current_dir[0] = 'left';
            game.firstDraw = false;
            game.is_draw--;
            game.update_map();
        }
    }

    // Рисование призрака
    drawGhost(pctOpen, position, color, eat_color = "#4040ee", stroke = "#000000") {
        position[0][0] += (position[1][0] - position[0][0]) / 4;
        position[0][1] += (position[1][1] - position[0][1]) / 4;
        const fltOpen = pctOpen / 100;
        const count = pctOpen > 50 && this.dir > 0 || pctOpen < 50 && this.dir < 0 ? 6 : 4;
        this.ctx.beginPath();
        this.ctx.arc(position[0][0] * this.s + this.s / 2, position[0][1] * this.s + this.s / 2.2, this.s / 1.6, Math.PI, 2 * Math.PI);
        const k = 1 + (this.s / 1.6 - this.s / 2) / this.s;
        this.ctx.lineTo(position[0][0] * this.s + this.s * k, position[0][1] * this.s + this.s);
        for (let i = count - 1; i > 0; i--) {
            this.ctx.lineTo(position[0][0] * this.s - this.s * (k - 1) + this.s * k * (i / count), position[0][1] * this.s + (i % 2 !== 0 ? this.s / 1.3 : this.s));
        }
        this.ctx.lineTo(position[0][0] * this.s - this.s * (k - 1), position[0][1] * this.s + this.s);
        this.ctx.closePath();
        this.ctx.fillStyle = this.ghost_eat ? eat_color : color;
        this.ctx.fill();
        this.ctx.strokeStyle = stroke;
        this.ctx.stroke();
    }

    // Очистка призрака
    clearGhost(position) {
        this.update_map_part(position[1]);
    }


    // Доступна правая сторона
    right_available(cord, block_types) {
        return block_types.indexOf(this.map[cord[1]].substr(cord[0] + 1,1)) === -1;
    }

    // Доступна левая сторона
    left_available(cord, block_types) {
        return block_types.indexOf(this.map[cord[1]].substr(cord[0] - 1,1)) === -1;
    }

    // Доступна верхняя сторона
    up_available(cord, block_types) {
        return block_types.indexOf(this.map[cord[1] - 1].substr(cord[0],1)) === -1;
    }

    // Доступна нижняя сторона
    down_available(cord, block_types) {
        return block_types.indexOf(this.map[cord[1] + 1].substr(cord[0],1)) === -1;
    }

    // Установка рандомного маршрута
    set_rand_dir(cord, new_dir, current_dir) {
        const rand_dir = Math.floor(Math.random() * 4);
        if (rand_dir === 1) {
            if (new_dir[0] === 'left' && current_dir[0] === 'stop' || current_dir[0] === 'right')
                this.set_rand_dir(cord, new_dir, current_dir);
            else
                new_dir[0] = 'left';
        } else if (rand_dir === 2) {
            if (new_dir[0] === 'right' && current_dir[0] === 'stop' || current_dir[0] === 'left')
                this.set_rand_dir(cord, new_dir, current_dir);
            else
                new_dir[0] = 'right';
        } else if (rand_dir === 3) {
            if (new_dir[0] === 'up' && current_dir[0] === 'stop' || current_dir[0] === 'down')
                this.set_rand_dir(cord, new_dir, current_dir);
            else
                new_dir[0] = 'up';
        } else {
            if (new_dir[0] === 'down' && current_dir[0] === 'stop' || current_dir[0] === 'up')
                this.set_rand_dir(cord, new_dir, current_dir);
            else
                new_dir[0] = 'down';
        }
    }

    // Движение объекта
    move(cord, cord_pacman, current_dir, new_dir, pv, b) {
        let a = false;
        const block_types = b ? this.block_types_pac : this.block_types_ghosts;
        if (current_dir[0] !== new_dir[0]) {
            if (new_dir[0] === 'left' && block_types.indexOf(this.map[cord[1]][cord[0] - 1]) !== -1) {
                a = true;
                this.move_left(cord, cord_pacman, current_dir, pv, b);
            } else if (new_dir[0] === 'right' && block_types.indexOf(this.map[cord[1]][cord[0] + 1]) !== -1) {
                a = true;
                this.move_right(cord, cord_pacman, current_dir, pv, b);
            } else if (new_dir[0] === 'up' && block_types.indexOf(this.map[cord[1] - 1][cord[0]]) !== -1) {
                a = true;
                this.move_up(cord, cord_pacman, current_dir, pv, b);
            } else if (new_dir[0] === 'down' && block_types.indexOf(this.map[cord[1] + 1][cord[0]]) !== -1) {
                a = true;
                this.move_down(cord, cord_pacman, current_dir, pv, b);
            }
            if (a) current_dir[0] = new_dir[0];
        }
        if (!a) {
            if (current_dir[0] === 'left') {
                this.move_left(cord, cord_pacman, current_dir, pv, b);
            } else if (current_dir[0] === 'right') {
                this.move_right(cord, cord_pacman, current_dir, pv, b);
            } else if (current_dir[0] === 'up') {
                this.move_up(cord, cord_pacman, current_dir, pv, b);
            } else if (current_dir[0] === 'down') {
                this.move_down(cord, cord_pacman, current_dir, pv, b);
            }
        }
        this.update_map()
    }

    // Движение объекта вверх
    move_up(cord, cord_pacman, current_dir, pv, b) {
        if (this.up_available(cord, b ? this.block_types_pac : this.block_types_ghosts)) {
            current_dir[0] = 'stop';
            return;
        }
        if (cord[1] === 1) {
            if (b) this.replace(cord, 0, 0, pv[0]);
            pv[0] = this.map[this.h][cord[0]];
            if (b) this.clearPacman();
            else this.clearGhost(cord_pacman);
            cord[1] = this.h;
            cord_pacman[1][1] = cord[1] - 1;
            cord_pacman[0][1] = cord[1];
            return;
        }
        if (b) this.replace(cord, 0, 0, pv[0]);
        pv[0] = this.map[cord[1] - 1][cord[0]];
        cord[1]--;
        cord_pacman[1][1] = cord[1];
    }

    // Движение объекта вниз
    move_down(cord, cord_pacman, current_dir, pv, b) {
        if (this.down_available(cord, b ? this.block_types_pac : this.block_types_ghosts)) {
            current_dir[0] = 'stop';
            return;
        }
        if (cord[1] === this.h) {
            console.log(b);
            if (b) this.replace(cord, 0, 0, pv[0]);
            pv[0] = this.map[1][cord[0]];
            if (b) this.clearPacman();
            else this.clearGhost(cord_pacman);
            cord[1] = 1;
            cord_pacman[1][1] = cord[1] + 1;
            cord_pacman[0][1] = cord[1];
            return;
        }
        if (b) this.replace(cord, 0, 0, pv[0]);
        pv[0] = this.map[cord[1] + 1][cord[0]];
        cord[1]++;
        cord_pacman[1][1] = cord[1];
    }

    // Движение объекта влево
    move_left(cord, cord_pacman, current_dir, pv, b) {
        if (this.left_available(cord, b ? this.block_types_pac : this.block_types_ghosts)) {
            current_dir[0] = 'stop';
            return;
        }
        if (cord[0] === 1) {
            if (b) this.replace(cord, 0, 0, pv[0]);
            pv[0] = this.map[cord[1]][this.w];
            //replaceAt(cord[1],w,nv[0]);
            if (b) this.clearPacman();
            else this.clearGhost(cord_pacman);
            cord[0] = this.w;
            cord_pacman[1][0] = cord[0] - 1;
            cord_pacman[0][0] = cord[0];
            return;
        }
        if (b) this.replace(cord, 0, 0, pv[0]);
        pv[0] = this.map[cord[1]][cord[0] - 1];
        cord[0]--;
        cord_pacman[1][0] = cord[0];
    }

    // Движение объекта вправо
    move_right(cord, cord_pacman, current_dir, pv, b) {
        if (this.right_available(cord, b ? this.block_types_pac : this.block_types_ghosts)) {
            current_dir[0] = 'stop';
            return;
        }
        if (cord[0] === this.w) {
            if (b) this.replace(cord, 0, 0, pv[0]);
            pv[0] = this.map[cord[1]][cord[0] + 1];
            //replaceAt(cord[1],1,nv[0]);
            if (b) this.clearPacman();
            else this.clearGhost(cord_pacman);
            cord[0] = 1;
            cord_pacman[1][0] = cord[0] + 1;
            cord_pacman[0][0] = cord[0];
            return;
        }
        if (b) this.replace(cord, 0, 0, pv[0]);
        pv[0] = this.map[cord[1]][cord[0] + 1];
        cord[0]++;
        cord_pacman[1][0] = cord[0];
    }

    replaceAt(x, y, z) {
        if (this.map[x][y] === '2') {
            this.score += 10;
            this.all_points--;
        } else if (this.map[x][y] === '4') {
            this.score += 50;
            this.all_points--;
            if (this.ghost_eat) {
                this.ghost_eat_confirm = true;
            } else {
                this.ghost_eat = true;
                this.ghost_eat_confirm = false;
            }
            const game_ = this;
            setTimeout(function () {
                if (!game_.ghost_eat_confirm) game_.ghost_eat = false;
                else game_.ghost_eat_confirm = false;
            }, 10000);
        }
        this.map[x] = this.map_replace(x, y, z);
    }

    replace(cord, x, y, z) {
        this.replaceAt(cord[1] + x, cord[0] + y, z);
    }

    map_replace(i, j, replacement) {
        return this.map[i].substr(0, j) + replacement + this.map[i].substr(j + replacement.length);
    }

    // Запуск игры
    run(motion_delta = 150, render_delta = 30) {
        this.delta = render_delta;
        const game = this;
        setInterval(() => game.render(game), render_delta);
        setInterval(() => game.motion(game), motion_delta);
    }
}