class core.comp.Scroll extends core.util.GenericMovieClip {
	
	private var speed:Number;
	private var w:Number;
	private var h:Number;
	
	function Scroll() {
		speed = (speed==undefined)?5:speed;
		this.createEmptyMovieClip("mask", 10);
		this.createEmptyMovieClip("content", 20);
	}
	
	public function getContentClip() {
		return this["content"];
	}
	
	public function init() {
		//create mask clip
		this["mask"].beginFill(0xFFFFFF);
		this["mask"].moveTo(0, 0);
		this["mask"].lineTo(this.w, 0);
		this["mask"].lineTo(this.w, this.h);
		this["mask"].lineTo(0, this.h);
		this["mask"].lineTo(0, 0);
		this["mask"].endFill();
		//set mask
		this.setMask(this["mask"]);
		//actionscript bug:need to ask for content height otherwise it doesnte update
		var h:Number = this["content"]._height
		//if necesary add scroll buttons
		if (this.isContentHidden()) {
			this.addScrollButtons();
		}
	}
	/**
	 * Initializes scroll position to top of the page
	 */
	public function resetScroll() {
		this["content"]._y = this._y;
	}
	/**
	 * Scrolls down. Function triggered by mouse passing over scroll down button.
	 * On first entry to the function a scroll interval is created that calls the same 
	 * function every 30 miliseconds (1 frame). Each time the function executes the content
	 * is moved up (the effect given is a downward scroll) by the number of pixels defined
	 * in the root level variable scrollSpeed. When the content bottom aligns with the bottom
	 * of the mask the interval is cancelled.
	 */
	public function scrollDown() {
		if ((this["content"]._y+this["content"]._height)>(this["mask"]._height+this.speed)) {
			if (this["content"].onEnterFrame == null) {
				this["content"].scrollObj = this;
				this["content"].onEnterFrame = function() {
					this.scrollObj.scrollDown();
				};
			} else {
				this["content"]._y = this["content"]._y-speed;
			}
		} else if (this["content"].onEnterFrame != null) {
			this["content"]._y = this["mask"]._height-this["content"]._height;
			delete this["content"].onEnterFrame;
		}
	}
	/**
	 * Scrolls up. Function triggered by mouse passing over scroll up button.
	 * On first entry to the function a scroll interval is created that calls the same 
	 * function every 30 miliseconds (1 frame). Each time the function executes the content
	 * is moved down (the effect given is an upward scroll) by the number of pixels defined
	 * in the root level variable scrollSpeed. When the content top aligns with the top of the 
	 * mask the interval is cancelled.
	 */
	public function scrollUp() {
		if (this["content"]._y<-this.speed) {
			if (this["content"].onEnterFrame == null) {
				this["content"].scrollObj = this;
				this["content"].onEnterFrame = function() {
					this.scrollObj.scrollUp();
				};
			} else {
				this["content"]._y = this["content"]._y+speed;
			}
		} else if (this["content"].onEnterFrame != null) {
			this["content"]._y = 0;
			this["content"].onEnterFrame = null;
		}
	}
	/*
	 * Clears scroll interval which stops any scrolling.
	 * Triggered when mouse leaves the scroll button
	 */
	public function stopScroll() {
		delete this["content"].onEnterFrame;
	}
	/*
	 * returns a boolean variable that equals true only when the bottom of
	 * the content exeeds the bottom of the content mask
	 */
	public function isContentHidden() {
		return (this["content"]._y+this["content"]._height>this._y+this["mask"]._height);
	}
	/*
	 * resizes the height of the scroll pane
	 */
	public function resizeHeight(h:Number) {
		
		//resize scroll pane
		var minH = Math.min(h, this._height);
		this.h = minH;
		this["mask"]._height = minH;
		
		//slide content if neccessary
		if(this["content"]._y<0 && !isContentHidden()){
			this["content"]._y = minH-this["content"]._height;
		}

		//redraw buttons
		if (this.isContentHidden() && minH>30) {
			addScrollButtons();
		} else {
			this.removeScrollButtons();
		}
	}
	/*
	 * adds the scroll buttons
	 */
	private function addScrollButtons() {
		//if necesary resize content
		if (this["content"]._width>this.w-17) {
			this["content"].oldWidth = this["content"]._width;
			this["content"]._width = this.w-17;
		}
		//add movie clips
		this.createEmptyMovieClip("scrollBtns", 30);
		this["scrollBtns"]._x = this.w-13;
		var btn_scrollUp = this["scrollBtns"].attachMovie("btn_scrollUp", "btn_scrollUp", 10);
		var btn_scrollDown = this["scrollBtns"].attachMovie("btn_scrollDown", "btn_scrollDown", 20);
		btn_scrollDown._y = this.h-13;
		//add scroll functionality to buttons
		btn_scrollUp.onRollOver = function() {
			this._parent._parent.scrollUp();
		};
		btn_scrollUp.onRollOut = function() {
			this._parent._parent.stopScroll();
		};
		btn_scrollDown.onRollOver = function() {
			this._parent._parent.scrollDown();
		};
		btn_scrollDown.onRollOut = function() {
			this._parent._parent.stopScroll();
		};
	}
	/**
		  * If scroll bars have been added then they are removed and the content is resized
		  */
	private function removeScrollButtons() {
		//if necesary resize content
		if (this["content"]._width == this.w-17) {
			this["content"]._width = this["content"].oldWidth;
		}
		this["scrollBtns"].removeMovieClip();
	}
	/*
	 * Deconstructor
	 */
	public function remove() {
		this.removeMovieClip();
	}
}
