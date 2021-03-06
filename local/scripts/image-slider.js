class ImageSlider {
    constructor(pname, slider, image, template, onclick = null) {
        this.pname = pname;
        this.slider = document.querySelector("#" + slider);
        this.image = document.querySelector("#" + image);
        console.log(this.slider, this.image)
        this.template = template;
        this.first_img = true;
        if (typeof click !== 'undefined')
            this.onclick = click;
    }
    add_image(image, template) {
        let img_block;
        if (typeof template !== 'undefined')
            img_block = template.replace("{image}", image);
        else
            img_block = this.template.replace("{image}", image);
        let i = img_block.indexOf(">");
        this.slider.innerHTML += img_block.slice(0, i) + " onclick=\"" + this.pname + ".onclick(this);\"" + img_block.slice(i);
        if (this.first_img) {
            this.onclick(this.slider.children[0]);
            this.first_img = false;
        }
        console.log(this.slider, this.image)
    }
    add_before_click(listener) {
        this.slistener = listener;
    }
    add_after_click(listener) {
        this.elistener = listener;
    }
    onclick(block) {
        if (typeof this.slistener !== "undefined")
            this.slistener(block)
        let image = block.querySelector('img[forslider]');
        this.image.src = image.src;
        let blocks = this.slider.children;
        for (let i = 0; i < blocks.length; i++)
            blocks[i].classList.remove("slider-image-active");
        block.classList.add("slider-image-active");
        if (typeof this.elistener !== "undefined")
            this.elistener(block)
    }
}
function centering(obj, target, offset = 0) {
    obj.style.left = offset + target.offsetLeft + 'px';
    obj.style.top = target.offsetTop + target.clientHeight / 2 - obj.clientHeight / 2 + 'px';
}