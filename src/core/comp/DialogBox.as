class core.comp.DialogBox {
	private var container:MovieClip;
	public function DialogBox(id:String, parentClip:MovieClip, depth:Number, x:Number, y:Number, w:Number, h:Number) {
		var curveDist = 5;
		container = parentClip.createEmptyMovieClip(id, depth);
		container._x = x;
		container._y = y;
		//create background
		var bg = container.createEmptyMovieClip("bg", 10);
		bg.lineStyle(1, 0x996633, 100);
		bg.beginFill(0xE2D8CB, 80);
		bg.moveTo(curveDist, 0);
		bg.lineTo(w-curveDist, 0);
		bg.curveTo(w, 0, w, curveDist);
		bg.lineTo(w, h-curveDist);
		bg.curveTo(w, h, w-curveDist, h);
		bg.lineTo(curveDist, h);
		bg.curveTo(0, h, 0, h-curveDist);
		bg.lineTo(0, curveDist);
		bg.curveTo(0, 0, curveDist, 0);
		bg.endFill();
		//create close button
		var closeBtn = container.attachMovie("close_btn", "close_btn", 12);
		closeBtn._x = w-closeBtn._width-2;
		closeBtn._y = 2;
		closeBtn.onRelease = function(){
			this._parent.removeMovieClip();
		}
		//create contents clip
		var contentClip = container.createEmptyMovieClip("cont", 11);
		contentClip._x = curveDist;
		contentClip._y = closeBtn._height;
	}
	//
	public function getContent(){
		return this.container.cont;
	}
	//
	public function remove(){
		this.container.removeMovieClip();
	}
}
