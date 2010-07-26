import core.util.Utils;
import core.util.Proxy;
import core.comp.Scroll;

/*
 * Window type component that contains a vertically scrollable content pane, vertical
 * resize funcionality, animated minimize/maximize functionality and a close button
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 08-03-2005
 */
class core.comp.TextPane extends core.util.GenericMovieClip {
	
	//reference to the content pane
	var contentPane : MovieClip;
	
	//dimensions of the text pane
	var w:Number;
	var h:Number;
	var headerH:Number;
	
	//the title text and its format
	var titleTxt:String = "";
	var titleTxtFormat:TextFormat;
	
	//boolean flag that when true activates a scroll for the content pane
	var doScroll:Boolean = true;
	
	//boolean flag that when true draws the maximize/minimize button
	var btnMinMax:Boolean = true;
	
	//boolean flag that when true draws the close button
	var btnClose:Boolean = false;
	
	//boolean flag that when true allows vertical resizing
	var resize:Boolean = true;
	
	//boolean flag that when true allows the text pane to be dragged
	var allowDrag:Boolean = true;
	
	//background transparency and color
	var bgColor:Number = 0xE6E3C6;
	var bgAlpha:Number = 100;
	
	//necessary for listener and event dispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	/*
	 * Constructor, creates the header and the empty content clip. In order to 
	 * initialize the scroll the init function should be called once content has
	 * been added
	 */
	public function TextPane(){
		
		//init event dispatcher
		mx.events.EventDispatcher.initialize (this);
		
		//initialize the title text format if it has not been defined by initial properties
		if (!this.titleTxtFormat){
			this.titleTxtFormat = new TextFormat ();
			this.titleTxtFormat.size = 18;
			this.titleTxtFormat.font = "Arial";
			this.titleTxtFormat.bold = false;
			this.titleTxtFormat.align = "left";
			this.titleTxtFormat.color = 0x996633;
		}
		
		w = (w) ? w : 200;
		h = (h) ? h : 400;
		headerH = (headerH) ? headerH : 30;
		
		createHeader();
		createBody();
		
		//hide until initialized
		this._visible = false;
	}
	
	/*
	 * Creates the header
	 */
	private function createHeader():Void{
		
		//create header clip
		var header = this.createEmptyMovieClip ("header", 10);
		
		//create background
		header.beginFill (0xE6E3C6, 90);
		header.moveTo (0, 0);
		header.lineTo (0, headerH);
		header.lineTo (this.w, headerH);
		header.lineTo (this.w, 0);
		header.lineTo (0, 0);
		header.endFill ();
		
		//create border
		header.lineStyle (1, 0x996633, 100);
		header.moveTo (0, headerH);
		header.lineTo (0, 0);
		header.lineTo (this.w, 0);
		header.lineTo (this.w, headerH);
		header.lineTo (0, headerH);
		header.moveTo (2, 2);
		
		//create gradientFill
		header.lineStyle (1, 0x996633, 0);
		var fillColors = [0x996633, 0x996633];
		var alphas = [50, 0];
		var ratios = [0, 32];
		var matrix = {
			matrixType : "box", x : 0, y : 0, w : 1500, h : headerH-2, r : 0
		};
		header.beginGradientFill ("linear", fillColors, alphas, ratios, matrix);
		header.lineTo (this.w - 2, 2);
		header.lineTo (this.w - 2, headerH-1);
		header.lineTo (2, headerH-1);
		header.lineTo (2, 2);
		header.endGradientFill ();

		//create title text
		header.createTextField ("txt", 2, 2, 2, this.w - 2, headerH-1);
		header.txt.text = this.titleTxt;
		header.txt.embedFonts = true;
		header.txt.setTextFormat(this.titleTxtFormat);
		
		//if dragging is allowed add drag funcionality to header
		if (this.allowDrag){
			header.onPress = function (){
				this._parent.startDrag (false);
			};
			header.onRelease = function (){
				this._parent.stopDrag ();
			};
		}
		
		//if close button is active then draw it
		var btn_close:MovieClip;
		if (this.btnClose){
			btn_close = this.attachMovie("btn_close", "btn_close", 20);
			btn_close._x = this.w - btn_close._width - 2;
			btn_close._y = 2;
			btn_close.onRelease = function () {
				this._parent.dispatchEvent({type: "closed", target: this});
				this._parent.removeMovieClip();
			};
		}
		
		//if minmax button is active then draw it
		var btn_minMax:MovieClip;
		if (this.btnMinMax){
			btn_minMax = this.attachMovie("btn_min", "btn_minMax", 30);
			btn_minMax._x = (this.btnClose) ? this.w-btn_close._width-btn_minMax._width-4 : this.w-btn_minMax._width-2;
			btn_minMax._y = 2;
			btn_minMax.onRelease = function () {
				this._parent.closeBlind();
			};
		}
	}
	
	/*
	 * Creates an empty body that contains a content pane
	 */
	private function createBody():Void{
		
		//create body clip
		var body = this.createEmptyMovieClip ("body", 40);
		body._y = headerH;
		
		//create blind mask
		var mask = body.createEmptyMovieClip ("mask", 10);
		mask.beginFill (0x000000, 100);
		mask.moveTo (0, 0);
		mask.lineTo (this.w + 1, 0);
		mask.lineTo (this.w + 1, this.h - 29);
		mask.lineTo (0, this.h - 29);
		mask.lineTo (0, 0);
		mask.endFill ();
		body.setMask (mask);
		
		//create blind clip
		var blind = body.createEmptyMovieClip ("blind", 20);
		
		//create background
		var bg = blind.createEmptyMovieClip ("bg", 10);
		bg.lineStyle (1, 0x996633, 100);
		bg.beginFill (this.bgColor, this.bgAlpha);
		bg.moveTo (0, 0);
		bg.lineTo (this.w, 0);
		bg.lineTo (this.w, this.h - this.headerH - 6);
		bg.lineTo (0, this.h - this.headerH - 6);
		bg.lineTo (0, 0);
		bg.endFill ();

		//if scroll is active create scroll pane
		//else create simple movie clip
		if (this.doScroll){
			//create scroll pane
			var scrollPane = Utils.newObject (Scroll, blind, "scrollpane", 20,{_x:1, _y:2, w:this.w-4, h:this.h-40});
			this.contentPane = scrollPane.getContentClip ();
		}else{
			this.contentPane = blind.createEmptyMovieClip ("scrollpane", 20);
			this.contentPane._x = 1;
			this.contentPane._y = 2;
		}
		
		//if resize allowed then draw resize bar
		if (this.resize){
		
			//create resize bar at bottom
			var resizeBar = blind.createEmptyMovieClip ("resizeBar", 30);
			resizeBar.textPane = this;
			resizeBar._y = this.h - 36;
			
			//create background
			var bg2:MovieClip = resizeBar.createEmptyMovieClip ("bg", 1);
			bg2.lineStyle (1, 0x996633, 100);
			bg2.beginFill (0xE6E3C6, 100);
			bg2.moveTo (0, 0);
			bg2.lineTo (this.w, 0);
			bg2.lineTo (this.w, 6);
			bg2.lineTo (0, 6);
			bg2.lineTo (0, 0);
			bg2.endFill ();
			
			//create rollover background
			var bg0:MovieClip = resizeBar.createEmptyMovieClip ("bgOver", 2);
			bg0._alpha = 0;
			bg0.lineStyle (1, 0xFF6633, 100);
			bg0.beginFill (0xFF6633, 100);
			bg0.moveTo (0, 0);
			bg0.lineTo (this.w, 0);
			bg0.lineTo (this.w, 6);
			bg0.lineTo (0, 6);
			bg0.lineTo (0, 0);
			bg0.endFill ();
			
			//add events
			resizeBar.onRollOver = function (){
				this.bgOver._alpha = 50;
			};
			resizeBar.onRollOut = function (){
				this.bgOver._alpha = 0;
			};
			resizeBar.onPress = function (){
				this.startDrag (false, 0, 0, 0, _root._height);
				this.onEnterFrame = function (){
					this.textPane.resizeHeight(this._y + this._height + this.textPane.headerH);
				};
			};
			resizeBar.onRelease = function (){
				this.stopDrag ();
				delete this.onEnterFrame;
			};
		}
	}
	
	/*
	 * Returns the content pane
	 * 
	 * @return the content pane movie clip
	 */
	public function getContent():MovieClip	{
		return this.contentPane;
	}
	
	/*
	 * Minimizes the text pane
	 */
	public function closeBlind():Void{
		
		//animate blind
		this["body"].blind.glideTo(this ["body"].blind._x, this.headerH - this.h, 5);
		
		//change button
		var x:Number = this["btn_minMax"]._x;
		this["asdfasdf"].removeMovieClip();
		var btn_minMax = this.attachMovie ("btn_max", "btn_minMax", 30);
		btn_minMax._x = x;
		btn_minMax._y = 2;
		btn_minMax.onRelease = function () {
			this._parent.openBlind();
		};
	}
	
	/*
	 * Maximizes the text pane
	 */
	public function openBlind(callbackFunc:Function):Void{
		
		//animate blind
		this ["body"].blind.glideTo(this["body"].blind._x, 0, 2, callbackFunc);
		
		//change button
		var x:Number = this["btn_minMax"]._x;
		this ["btn_minMax"].removeMovieClip();
		var btn_minMax = this.attachMovie ("btn_min", "btn_minMax", 30);
		btn_minMax._x = x;
		btn_minMax._y = 2;
		btn_minMax.onRelease = function () {
			this._parent.closeBlind();
		};
	}

	/*
	 * Initializes the text pane. This method should be called once the content has been
	 * added to the content pane
	 * 
	 * @param animate if true the text pane is slid open
	 */
	public function init(animate:Boolean):Void{
		
		//show component
		this._visible = true;
		
		//if scroll then initialize
		if (this.doScroll){
			this ["body"].blind.scrollpane.init ();
		}
		
		//if animate then descativate the text pane and open blind
		if (animate){
			this.desactivate ();
			this ["body"].blind._y = this.headerH - this.h;
			this.openBlind(Proxy.create(this, this.activate));
		}
	}

	/*
	 * Resizes the height
	 * 
	 * @param h the new height
	 */
	public function resizeHeight (h:Number):Void{
		
		//if scroll then resize the scroll
		if (this.doScroll){
			this ["body"].blind.scrollpane.resizeHeight (h - 42);
		}
		
		//change the necesarry heights 
		this ["body"].mask._height = h - this.headerH - 1;
		this ["body"].blind.bg._height = h - this.headerH;
		this.h = h;
	}
	
	/*
	 * Dynamically changes the title text
	 * 
	 * @param titleTxt the new title
	 */
	public function setTitle (titleTxt:String):Void{
		this ["header"].txt.text = titleTxt;
		this ["header"].txt.setTextFormat (this.titleTxtFormat);
	}
	
	/*
	 * Activates the text pane
	 */
	public function activate ():Void{
		delete this.onPress;
	}

	/*
	 * Desactivates the text pane
	 */
	public function desactivate (){
		this.onPress = function (){
			//to avoid interaction with textPane while it opens
		};
	}
	
	/*
	 * Returns the relative x positon of the content pane to the
	 * overall text pane object
	 */
	public function getContentX():Number{
		return 0;
	}
	
	/*
	 * Returns the relative y positon of the content pane to the
	 * overall text pane object
	 */
	public function getContentY():Number{
		return this.headerH;
	}
	 
	 
}
