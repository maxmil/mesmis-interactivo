import core.util.Utils;
import core.util.Proxy;
import core.comp.BubbleBtn;

/*
 * Displays a message for the user
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 18-07-2005
 */
class core.comp.UserMessage extends core.util.GenericMovieClip {
	
	//the text and text format of the message
	private var txt:String;
	private var txtFormat:TextFormat;
	
	//title text, when defined a title is drawn with the specified title height
	private var titleTxt:String;
	private var titleHeight:Number;
	private var titleTxtFormat:TextFormat;
	
	//the dimensions of the message. The height is calculated dynamically unless defined by the initial properties
	private var w:Number;
	private var h:Number;
	
	//Boolean flag that when true paints a close button for the message
	private var btnClose:Boolean;
	
	//boolean flag that when true allows the message to be dragged
	private var allowDrag:Boolean;
	
	//if there are buttons defined these are drawn after the text. Each button should be an object
	//with the properties callBackObj, callBackFunc and literal
	private var callBack_btns:Array;
	
	//the spacing between the accept button and message
	private var btn_msg_spacing:Number;
	
	//the spacing between buttons and message
	private var btn_spacing:Number;
	
	//the magnitude of the curved corners of the box
	private var curveDist:Number;
	
	//colors and transparency
	private var fgColor:Number;
	private var bgColor:Number;
	private var isTransparent:Boolean;
	
	//shadows
	private var shadowLength:Number;
	private var shadowCol:Number;
	private var shadowAlpha:Number;
	
	//if fadeOutAfter is greater than 0 the message is faded out after the number of miliseconds specified
	//by the value of fadeOutAfter
	private var fadeOutAfter:Number;
	private var fadeOutInt:Number;
	private var fadeOutSpeed:Number;
	
	//object and function to be executed when the message has faded in
	private var onInitFunc:Function;
	
	
	/*
	 * Constructor
	 */
	public function UserMessage() {
		
		//define default properties if not defined via initial object
		fgColor = (fgColor==undefined) ? 0x996633 : fgColor;
		bgColor = (bgColor==undefined) ? 0xe2d8cb : bgColor;
		isTransparent = (isTransparent==undefined) ? false : isTransparent;
		titleHeight = (titleHeight==undefined) ? 25 : titleHeight;
		w = (w==undefined) ? 200 : w;
		btnClose = (btnClose==undefined) ? true : btnClose;
		allowDrag = (allowDrag==undefined) ? true : allowDrag;
		btn_msg_spacing = (btn_msg_spacing==undefined) ? 10 : btn_msg_spacing;
		btn_spacing = (btn_spacing==undefined) ? 10 : btn_spacing;
		curveDist = (curveDist==undefined) ? 10 : curveDist;
		shadowLength = (shadowLength==undefined) ? 10 : shadowLength;
		shadowCol = (shadowCol==undefined) ? fgColor : shadowCol;
		shadowAlpha = (shadowAlpha==undefined) ? 100 : shadowAlpha;
		
		//init fade in
		this._alpha = 0;
		this["alphaTo"](100, 10, onInitFunc);
		
		//create title text
		if (this.titleTxt) {
			
			//create clip
			var mc_title:MovieClip = this.createEmptyMovieClip("title", 20);
			if (!this.isTransparent) {
				
				//create fill
				mc_title.lineStyle(1, this.fgColor, 0);
				var fillColors = [this.fgColor, this.fgColor];
				var alphas = [50, 0];
				var ratios = [0, 32];
				var matrix = {matrixType:"box", x:0, y:0, w:this.w*10, h:28, r:0};
				mc_title.beginGradientFill("linear", fillColors, alphas, ratios, matrix);
				mc_title.moveTo(this.curveDist, 0);
				mc_title.lineTo(this.w-this.curveDist, 0);
				mc_title.curveTo(this.w, 0, this.w, this.curveDist);
				mc_title.lineTo(this.w, this.titleHeight);
				mc_title.lineTo(0, this.titleHeight);
				mc_title.lineTo(0, this.curveDist);
				mc_title.curveTo(0, 0, this.curveDist, 0);
				mc_title.endGradientFill();
			}
			
			//create text
			mc_title.createTextField("tf", 1, this.curveDist, 0, this.w-this.curveDist, this.titleHeight);
			mc_title["tf"].text = this.titleTxt;
			mc_title["tf"].setTextFormat(this.titleTxtFormat);
			mc_title["tf"].embedFonts = true;
			mc_title["tf"].selectable = false;
		}
		
		//create close button
		var closeBtn:MovieClip;
		if (this.btnClose) {
			closeBtn= this.attachMovie("close_btn", "close_btn", 40);
			closeBtn._x = this.w-this.curveDist/4-closeBtn._width-2;
			closeBtn._y = 2+curveDist/4;
			closeBtn.onRelease = function() {
				this._parent.removeMovieClip();
			};
		}
		
		//create main text
		var txtWidth:Number = (!this.btnClose || this.titleTxt) ? w-2*this.curveDist : w-curveDist-closeBtn._width;
		this.createTextField("tf", 30, this.curveDist, Math.max(this._height, this.curveDist), txtWidth, 100);
		this["tf"].text = txt;
		this["tf"].setTextFormat(this.txtFormat);
		this["tf"].embedFonts = true;
		this["tf"].wordWrap = true;
		this["tf"].autoSize = true;
		this["tf"].selectable = false;
		
		//create btns if aplicable
		if (this.callBack_btns && this.callBack_btns.length>0) {
			
			//create buttons container clip
			var btns:MovieClip = this.createEmptyMovieClip("btn", this.getNextHighestDepth());
			
			//create buttons
			var btn:BubbleBtn;
			var currX:Number = 0;
			for (var i=0; i<this.callBack_btns.length; i++){
				btn = Utils.newObject(BubbleBtn, btns, "btn_"+String(i), btns.getNextHighestDepth(), {literal:this.callBack_btns[i].literal});
				btn._x = (i==0) ? 0 : btns._width+this.btn_spacing;
				btn["btnObj"] = this.callBack_btns[i];
				btn.onRelease = function() {
					this.btnObj.callBackFunc.call(this.btnObj.callBackObj);
				};
			}
			
			//position buttons
			btns._x = (this.w-btns._width)/2;
			btns._y = this._height+this.btn_msg_spacing;
		}else{
			this.btn_msg_spacing = 0;
		}
		
		//if height has not been previously defined then define it
		if (this.h == null) {
			if (this.titleTxt) {
				this.h = this._height;
			} else {
				this.h = this._height+2*this.curveDist;
			}
		}
		
		//create background
		if (!this.isTransparent) {

			//draw bg
			var bg = this.createEmptyMovieClip("bg", 10);
			bg.lineStyle(1, this.fgColor, 100);
			bg.beginFill(this.bgColor, 95);
			bg.moveTo(this.curveDist, 0);
			bg.lineTo(this.w-this.curveDist, 0);
			bg.curveTo(this.w, 0, this.w, this.curveDist);
			bg.lineTo(this.w, this.h-this.curveDist);
			bg.curveTo(this.w, this.h, this.w-this.curveDist, this.h);
			bg.lineTo(this.curveDist, this.h);
			bg.curveTo(0, this.h, 0, this.h-this.curveDist);
			bg.lineTo(0, this.curveDist);
			bg.curveTo(0, 0, this.curveDist, 0);
			bg.endFill();
			
			//make draggable
			if (this.allowDrag){
				bg.onPress = function(){
					this._parent.startDrag(false);
				}
				bg.onRelease = function(){
					this._parent.stopDrag();
				}
			}
		}
		
		//if fadeOutAfter is defined then set interval
		if(this.fadeOutAfter > 0){
			this.fadeOutInt = setInterval(this, "fadeOut", fadeOutAfter);
		}
		
		//draw shadow
		if(this.shadowLength && !this.isTransparent){
			drawShadow();
		}
	}
	
	/*
	 * Removes the message
	 */
	public function remove():Void{
		this.removeMovieClip();
	}
	
	/*
	 * Fades out the user message, when the fade completes the message is deleted
	 */
	public function fadeOut():Void{
		
		//definse fadeOut speed
		fadeOutSpeed = (fadeOutSpeed) ? fadeOutSpeed : 10;
		
		//remove interval if exists
		if (this.fadeOutInt){
			clearInterval(this.fadeOutInt);
		}
		
		//fade out the message
		if (fadeOutSpeed>1){
			this["alphaTo"](0, 10, Proxy.create(this, this.remove));
		}else{
			this.remove();
		}
	}
	
	/*
	 * Draws shadow around message
	 */
	private function drawShadow():Void{
		
		//useful fill data
		var fillCols:Array = [this.shadowCol, this.shadowCol];
		var alphas:Array = [this.shadowAlpha, 0];
		var ratios:Array = [0, 0xff];
		var matrix:Object;
		
		//redimension shadow length if necessary
		var sl:Number = this.shadowLength
		var cd:Number = (this.shadowLength>this.curveDist) ? this.curveDist : this.shadowLength;
		//var cd:Number = this.curveDist;

		if (sl>cd){
			
			//draw right edge solid block
			this.beginFill(this.shadowCol, this.shadowAlpha);
			this.moveTo(this.w, sl+cd);
			this.lineTo(this.w+sl-cd, sl+cd);
			this.lineTo(this.w+sl-cd, this.h+sl-cd);
			this.lineTo(this.w, this.h+sl-cd);
			this.lineTo(this.w, sl+cd);
			this.endFill();

			//draw bottom edge solid block
			this.beginFill(this.shadowCol, this.shadowAlpha);
			this.moveTo(sl+cd, this.h);
			this.lineTo(this.w+sl-cd, this.h);
			this.lineTo(this.w+sl-cd, this.h+sl-cd);
			this.lineTo(sl+cd, this.h+sl-cd);
			this.lineTo(sl+cd, this.h);
			this.endFill();
		
			//draw bottom left corner rectangle
			matrix = {matrixType:"box", x:sl, y:this.h, w:cd, h:sl, r:Math.PI};
			this.beginGradientFill("linear", fillCols, alphas, ratios, matrix);
			this.moveTo(sl, this.h);
			this.lineTo(sl+cd, this.h);
			this.lineTo(sl+cd, this.h+sl-cd);
			this.lineTo(sl, this.h+sl-cd);
			this.lineTo(sl, this.h);
			this.endFill();
			
			//draw top right corner rectangle
			matrix = {matrixType:"box", x:this.w, y:sl, w:sl-cd, h:cd, r:-Math.PI/2};
			this.beginGradientFill("linear", fillCols, alphas, ratios, matrix);
			this.moveTo(this.w, sl);
			this.lineTo(this.w+sl-cd, sl);
			this.lineTo(this.w+sl-cd, sl+cd);
			this.lineTo(this.w, sl+cd);
			this.lineTo(this.w, sl);
			this.endFill();
		}
		
		//draw right edge gradient
		matrix = {matrixType:"box", x:this.w+sl-cd, y:sl, w:cd, h:this.h+sl-cd, r:0};
		this.beginGradientFill("linear", fillCols, alphas, ratios, matrix);
		this.moveTo(this.w+sl-cd, sl+cd);
		this.lineTo(this.w+sl, sl+cd);
		this.lineTo(this.w+sl, this.h+sl-cd);
		this.lineTo(this.w+sl-cd, this.h+sl-cd);
		this.lineTo(this.w+sl-cd, sl+cd);
		this.endFill();
		
		//draw bottom edge gradient
		matrix = {matrixType:"box", x:sl+cd, y:this.h+sl-cd, w:this.w-2*cd, h:cd, r:Math.PI/2};
		this.beginGradientFill("linear", fillCols, alphas, ratios, matrix);
		this.moveTo(sl+cd, this.h+sl-cd);
		this.lineTo(this.w+sl-cd, this.h+sl-cd);
		this.lineTo(this.w+sl-cd, this.h+sl);
		this.lineTo(sl+cd, this.h+sl);
		this.lineTo(sl+cd, this.h+sl-cd);
		this.endFill();

		//draw bottom left corner
		matrix = {matrixType:"box", x:sl, y:this.h+sl-2*cd, w:2*cd, h:2*cd, r:0};
		this.beginGradientFill("radial", fillCols, alphas, ratios, matrix);
		this.moveTo(sl, this.h+sl-cd);
		this.lineTo(sl+cd, this.h+sl-cd);
		this.lineTo(sl+cd, this.h+sl);
		this.curveTo(sl, this.h+sl, sl, this.h+sl-cd);
		this.endFill();

		//draw top right corner
		matrix = {matrixType:"box", x:this.w+sl-2*cd, y:sl, w:2*cd, h:2*cd, r:0};
		this.beginGradientFill("radial", fillCols, alphas, ratios, matrix);
		this.moveTo(this.w+sl-cd, sl);
		this.curveTo(this.w+sl, sl, this.w+sl, sl+cd);
		this.lineTo(this.w+sl-cd, sl+cd);
		this.lineTo(this.w+sl-cd, sl);
		this.endFill();
		
		//draw bottom right corner
		matrix = {matrixType:"box", x:this.w+sl-2*cd, y:this.h+sl-2*cd, w:2*cd, h:2*cd, r:0};
		this.beginGradientFill("radial", fillCols, alphas, ratios, matrix);
		this.moveTo(this.w+sl-cd, this.h+sl-cd);
		this.lineTo(this.w+sl, this.h+sl-cd);
		this.curveTo(this.w+sl, this.h+sl, this.w+sl-cd, this.h+sl);
		this.lineTo(this.w+sl-cd, this.h+sl-cd);
		this.endFill();
		
		//draw inside corner solid fill
		this.beginFill(this.shadowCol, this.shadowAlpha);
		this.moveTo(this.w-this.curveDist, this.h);
		this.curveTo(this.w, this.h, this.w, this.h-this.curveDist);
		this.lineTo(this.w, this.h);
		this.lineTo(this.w-this.curveDist, this.h);
		this.endFill();
	}
}
