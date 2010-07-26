/*
 * Generic button
 * @author Max Pimm
 * @created 12-07-2005
 * @version 1.0
 */
class core.comp.EyeBtn extends core.util.GenericMovieClip {
	
	//the text displayed on the button
	private var literal:String;
	
	//the format of the text displayed on the button
	private var txtFormat:TextFormat;
	
	//the callback object and callback function to exectute
	//when the button is clicked
	private var callBackObj:Object;
	private var callBackFunc: Function;
	
	//background colors and line styles
	private var bgColor:Number = 0xE6E3C6;
	private var bgOverColor:Number = 0xffffff;
	private var lineColor:Number = 0x006600;
	private var lineOverColor:Number = 0xff6600;
	
	//boolean flags
	private var drawEye:Boolean = true;
	private var drawBg:Boolean = true;
	
	//bolean flag used to activate and desactivate the button
	private var active:Boolean;
	
	/*
	 * Constructor
	 */
	function EyeBtn() {
		
		this._focusrect = false;
		
		//activate by default
		if(active == undefined){
			active = true;
		}
		
		//init text format if not defined by initial object
		if (!txtFormat){
			initTxtFormat();
		}
		
		//create background clip
		var bg = this.createEmptyMovieClip("bg", 1);
		if (this.drawEye){
			bg.attachMovie("eye_button", "eye", 1, {_x:2, _y:2});
		}
		drawText(bg, lineColor);
		if (this.drawBg){
			bg.lineStyle(1, this.lineColor, 100);
			this.drawBubble(bg, this.bgColor, 100);
		}
		
		//create rollover clip
		var roll = this.createEmptyMovieClip("roll", 11);
		if (this.drawEye){
			roll.attachMovie("eye_button_over", "eye", 10, {_x:2, _y:2});
		}
		drawText(roll, lineOverColor);
		if (this.drawBg){
			roll.lineStyle(2, this.lineOverColor, 100);
			this.drawBubble(roll, this.bgOverColor, 100);
		}
		roll._alpha = 0;

		//on roll over alpha up roll clip
		this.onRollOver = function(){
			if(this.active){
				this["roll"].alphaTo(100, 10);
			}
		};

		//on roll out alpha down roll clip
		this.onRollOut = function(){
			if(this.active){
				this["roll"]._alpha = 0;
				if (this["roll"].alpha_mc) {
					this["roll"].alpha_mc.removeMovieClip();
				}
			}
		};

		//add onclick functionality
		this.onRelease = function(){
			if(this.active){
				this.callBackFunc.apply(this.callBackObj);
				Selection.setFocus(this);
			}
		}

		//disable hand cursor if not active
		if(!this.active){
			this.useHandCursor = false;
		}
	}
	
	/*
	 * Initialize the text format
	 */
	private function initTxtFormat() {
		this.txtFormat = new TextFormat();
		this.txtFormat.size = 12;
		this.txtFormat.font = "Arial";
		this.txtFormat.bold = true;
		this.txtFormat.color = 0x006600;
	}
	
	/*
	 * Draws the bubble
	 */
	private function drawBubble(cont:MovieClip, fillColor:Number, fillAlpha:Number) {
		var curveDist = 5;
		var w = cont["txtField"]._width+25;
		var h = cont["txtField"]._height+5;
		cont.beginFill(fillColor, 100);
		cont.moveTo(curveDist, 0);
		cont.lineTo(w-curveDist, 0);
		cont.curveTo(w, 0, w, curveDist);
		cont.lineTo(w, h-curveDist);
		cont.curveTo(w, h, w-curveDist, h);
		cont.lineTo(curveDist, h);
		cont.curveTo(0, h, 0, h-curveDist);
		cont.lineTo(0, curveDist);
		cont.curveTo(0, 0, curveDist, 0);
		cont.endFill();
	}
	
	/*
	 * Draws the text
	 */
	private function drawText(mc:MovieClip, _color:Number){
		mc.createTextField("txtField", mc.getNextHighestDepth(), 20, 2, 1, 20);
		mc.txtField.text = this.literal;
		this.txtFormat.color = _color;
		mc.txtField.setTextFormat(this.txtFormat);
		mc.txtField.autoSize = true;
		mc.txtField.selectable = false;
		mc.txtField.embedFonts = true;
	}
	
	/*
	 * Activates and disactivates the button
	 * 
	 * @param active a boolean value, true activates the button
	 */
	public function setActive(active:Boolean):Void{
		if(!active){
			this.onRollOut();
			this.useHandCursor = false;
		}else{
			this.useHandCursor = true;
		}
		this.active = active;
	}
}
