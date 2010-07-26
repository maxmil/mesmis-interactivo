
/*
 * Generic button for core
 * @author Max Pimm
 * @created 12-07-2005
 * @version 1.0
 */
class core.comp.BubbleBtn extends core.util.GenericMovieClip {
	
	//the text displayed on the button
	private var literal:String;
	
	//the format of the text displayed on the button
	private var txtFormat:TextFormat;
	
	//the callback object and callback function to exectute
	//when the button is clicked
	private var callBackObj:Object;
	private var callBackFunc: Function;
		
	//background colors and line styles
	private var bgExLightCol:Number = 0xccffcc;
	private var bgLightCol:Number = 0x00cc00;
	private var bgDarkCol:Number = 0x006600;
	
	//bolean flag used to activate and desactivate the button
	private var active:Boolean;
	
	//dimensions of the text field
	var metrics:Object;
	
	//dimensions of button, if not forced by init object will take the
	//dimensions of the text field
	var w:Number;
	var h:Number;
	
	/*
	 * Constructor
	 */
	public function BubbleBtn() {
		
		//activate by default
		if(active == undefined){
			active = true;
		}
		
		//init text format if not defined by initial object
		if (!txtFormat){
			initTxtFormat();
		}
		
		//get text metrics
		metrics = this.txtFormat.getTextExtent(this.literal);
		w = (w) ? w : metrics.textFieldWidth+20;
		h = (h) ? h : metrics.textFieldHeight+1;
		
		//fill usefuls
		var fillColors;
		var alphas;
		var ratios;
		var matrix;

		//create background clip
		var bg:MovieClip = this.createEmptyMovieClip("bg", 1);	
		fillColors = [(this.bgLightCol+this.bgDarkCol)/2, this.bgDarkCol];
		drawBgBubble(bg, fillColors);
		fillColors = [this.bgExLightCol, this.bgExLightCol];
		drawTopReflection(bg, fillColors);
		fillColors = [bgLightCol, bgLightCol];
		drawBottomReflection(bg, fillColors);

		//create roll over clip
		var roll:MovieClip = this.createEmptyMovieClip("roll", 2);
		roll._alpha = 0;
		fillColors = [this.bgLightCol, this.bgLightCol];
		drawBgBubble(roll, fillColors);
		fillColors = [0xffffff, 0xffffff];
		drawTopReflection(roll, fillColors);
		fillColors = [this.bgExLightCol, this.bgLightCol];
		drawBottomReflection(roll, fillColors);

		//create hit clip
		var hit:MovieClip = this.createEmptyMovieClip("hit", 3);
		hit._alpha = 0;
		fillColors = [this.bgDarkCol, this.bgDarkCol];
		drawBgBubble(hit, fillColors);
		fillColors = [this.bgLightCol, this.bgLightCol];
		drawTopReflection(hit, fillColors);
		fillColors = [this.bgLightCol, this.bgLightCol];
		drawBottomReflection(hit, fillColors);
		
		//create text clips
		var txt_mc:MovieClip = this.createEmptyMovieClip("txt_mc", 4);
		txt_mc.createTextField("tf_1", 2, 0, 0, w, h);
		txt_mc["tf_1"].text = this.literal;
		txt_mc["tf_1"].embedFonts = true;
		txt_mc["tf_1"].setTextFormat(this.txtFormat);
		this.txtFormat.color = 0x000000;
		txt_mc.createTextField("tf_2", 1, 1, 1, w-1, h);
		txt_mc["tf_2"].text = this.literal;
		txt_mc["tf_2"].embedFonts = true;
		txt_mc["tf_2"].setTextFormat(this.txtFormat);
		
		//on roll over alpha up roll clip
		this.onRollOver = function(){
			if(this.active){
				this["roll"].alphaTo(100, 5);
			}
		};

		//on roll out alpha down roll clip
		this.onRollOut = function(){
			if(this.active){
				this["roll"]._alpha = 0;
				this["hit"]._alpha = 0;
				if (this["roll"].alpha_mc) {
					this["roll"].alpha_mc.removeMovieClip();
				}
			}
		};
		
		//add on press functionality
		this.onPress = function(){
			if(this.active){
				this["hit"]._alpha = 100;
				if (this["roll"].alpha_mc) {
					this["roll"].alpha_mc.removeMovieClip();
				}
			}
		};
		
		//add onclick functionality
		this.onRelease = function(){
			if(this.active){
				this["hit"]._alpha = 0;
				this.callBackFunc.apply(this.callBackObj);
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
		this.txtFormat.align = "center";
		this.txtFormat.bold = true;
		this.txtFormat.color = 0xffffff;
	}
	
	/*
	 * Draws bg bubble
	 */
	private function drawBgBubble(mc:MovieClip, fillColors):Void{
		var alphas:Array = [100, 100];
		var ratios:Array = [0, 0xff];
		var matrix:Object = {matrixType:"box", x:0, y:0, w:w, h:h, r:Math.PI/2};
		mc.beginGradientFill ("linear", fillColors, alphas, ratios, matrix);
		drawBubble(mc, this.w, this.h, 0.5*this.h);
		mc.endFill();
	}
	
	/*
	 * Draws top reflexion
	 */
	private function drawTopReflection(mc:MovieClip, fillColors):Void{
		var alphas:Array = [100, 0];
		var ratios:Array = [10, 0xff];
		var matrix:Object = {matrixType:"box", x:0, y:h/8, w:w, h:h/8, r:Math.PI/2};
		mc.beginGradientFill("linear", fillColors, alphas, ratios, matrix);
		drawHalfBubble(mc, 0.01*this.w, this.h/8, 0.98*this.w, 2*this.h/8, 0.5*this.h);
		mc.endFill();
	}
	
	/*
	 * Draws bottom reflexion
	 */
	private function drawBottomReflection(mc:MovieClip, fillColors):Void{
		var alphas:Array = [0, 100];
		var ratios:Array = [0, 100];
		var matrix:Object = {matrixType:"box", x:0, y:3*h/8, w:w, h:4*h/8, r:Math.PI/2};
		mc.beginGradientFill("linear", fillColors, alphas, ratios, matrix);
		drawHalfBubble(mc, 0.01*this.w, 3*this.h/8, 0.98*this.w, 4*this.h/8, 0.5*this.h);
		mc.endFill();
	}
	
	/*
	 * Draws the bubble
	 */
	private function drawBubble(container:MovieClip, w:Number, h:Number, curveDist:Number):Void{
		container.moveTo(curveDist, 0);
		container.lineTo(w-curveDist, 0);
		container.curveTo(w, 0, w, curveDist);
		container.lineTo(w, h-curveDist);
		container.curveTo(w, h, w-curveDist, h);
		container.lineTo(curveDist, h);
		container.curveTo(0, h, 0, h-curveDist);
		container.lineTo(0, curveDist);
		container.curveTo(0, 0, curveDist, 0);
	}
	
	
	/*
	 * Draw a portion of a bubble 
	 */
	private function drawHalfBubble(container:MovieClip, x:Number, y:Number, w:Number, h:Number, curveDist:Number):Void{
		
		//if is top half
		if (y+h<this.h/2){
			container.moveTo(x+curveDist, y);
			container.lineTo(x+w-curveDist, y);
			container.curveTo(x+w, y, x+w, y+curveDist);
			container.lineTo(x+w, y+h);
			container.lineTo(x, y+h);
			container.lineTo(x, y+curveDist);
			container.curveTo(x, y, x+curveDist, y);
		}else{
			container.moveTo(x, y);
			container.lineTo(x+w, y);
			container.lineTo(x+w, y+h-curveDist);
			container.curveTo(x+w, y+h, x+w-curveDist, y+h);
			container.lineTo(x+curveDist, y+h);
			container.curveTo(x, y+h, x, y+h-curveDist);
			container.lineTo(x, y);
		}
	}
}
