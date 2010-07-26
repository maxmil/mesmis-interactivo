import core.util.Proxy;
import core.util.GenericMovieClip;

/*
 * Rains letters
 * 
 * @autor Max Pimm
 * @created 01-09-2005
 * @version 1.0
 */
class core.comp.RainingText extends core.util.GenericMovieClip{
	
	//the text string to rain
	public var txt:String;
	
	//the text format
	public var txtFormat:TextFormat;
	public var txtCol:Number;
	public var bgCol:Number;
	
	//initial and final coordinates
	public var initX:Number;
	public var initY:Number;
	public var finX:Number;
	public var finY:Number;
	
	//animation control
	public var speed:Number;
	public var delay:Number;
	public var separation:Number;
	public var _order:String; //valid values are "normal", "reverse", "random", default is "normal"
	public var isShowBox:Boolean;
	
	//functions
	public var onComplete:Function;
	
	/*
	 * Constructor
	 */
	public function RainingText() {
		
		//initialize text format
		if (!txtFormat){
			txtFormat = new TextFormat();
			txtFormat.font = "Arial bold";
			txtFormat.bold = true;
			txtFormat.align = "left";
			txtFormat.color = (txtCol) ? txtCol : 0xffffff;
		}
		txtCol = txtFormat.color;
		bgCol = (bgCol==undefined) ? txtCol : bgCol;
				
		//define coordinates
		initX = (initX) ? initX : 0;
		initY = (initY) ? initY : 0;
		finX = (finX) ? finX : initX;
		finY = (finY) ? finY : initY;
		
		//define animation control
		speed = (speed) ? speed : 10;
		delay = (delay) ? delay : 0;
		separation = (separation) ? separation : 1;
		_order = (_order) ? _order : "normal";
		isShowBox = (isShowBox) ? isShowBox : false;
		
		//define useful variables
		var newChar:String;
		var currX:Number = 0;
		var metrics:Object;
		var charW:Number;
		var charH:Number;
		var id:String;
		var mc;
		
		//create character clips
		for (var i=0; i<txt.length; i++){
			
			//define letter and metrics
			newChar = txt.substring(i, i+1);
			metrics = txtFormat.getTextExtent(newChar);
			charW = (metrics.textFieldWidth>0) ? metrics.textFieldWidth*1.2 : txtFormat.size;
			charH = (metrics.textFieldHeight>0) ? metrics.textFieldHeight : txtFormat.size*1.5;
			id = "char_"+String(i+1);
			
			//create character movie clip
			mc = this.createEmptyMovieClip(id, i+1);
			mc._x = initX;
			mc._y = initY;
			
			//create text field
			mc.createTextField("tf", 1, currX, -charH, charW, charH);
			mc["tf"].text = newChar;
			mc["tf"].embedFonts = true;
			mc["tf"].setTextFormat(txtFormat);
			mc["tf"].selectable = false

			//create semi transparent mask
			mc.createEmptyMovieClip("mask", 3);
			mc.mask.beginFill(bgCol, 50);
			mc.mask.lineStyle(1, txtCol, 50);
			mc.mask.moveTo(0,0);
			mc.mask.lineTo(charW, 0);
			mc.mask.lineTo(charW, charH);
			mc.mask.lineTo(0, charH);
			mc.mask.lineTo(0, 0);
			mc.mask.endFill();
			mc.mask._x = currX;
			mc.mask._y = -charH;
			
			//increment currX
			currX += charW;
		}
		
		//create animator clip
		var animator:MovieClip = this.createEmptyMovieClip("animation_clip", this.getNextHighestDepth());
		animator.frameCnt = 0;
		
		//initiate array of indices to manage the release order if is random
		if (_order == "random"){
			animator.indices = initRandomInds();
		}
		
		//define animation
		animator.onEnterFrame = function() {
			
			var rt:RainingText = this._parent;
			
			if(this.frameCnt<rt.txt.length*rt.separation){
				
				//if is time to release another character
				if(this.frameCnt%rt.separation==0){

					//get index of char to release
					var ind:Number;
					var isLast:Boolean;
					switch (rt._order){
						case "reverse":
							ind = rt.txt.length-this.frameCnt/rt.separation;
							isLast = (ind==1) ? true : false;
						break;
						case "random":
							ind = this.indices[this.frameCnt/rt.separation]+1;
							isLast = (this.frameCnt/rt.separation == this.indices.length-1) ? true : false;
						break;
						default:
							ind = this.frameCnt/rt.separation+1;
							isLast = (ind==rt.txt.length) ? true : false;
						break;
					}
					
					//define function to set _alpha to 0 on arrival
					//if is last character then call onComplete aswell
					var fnc:Function;
					if (isLast){
						fnc = function(){
							if (!this._parent.isShowBox){
								this.mask._alpha = 0;
							}
							this._parent.onComplete();
						}
					}else{
						fnc = function(){
							if (!this._parent.isShowBox){
								this.mask._alpha = 0;
							}
						}	
					}
					
					//release new character
					var char:MovieClip = rt["char_"+String(ind)];
					char.glideTo(rt.finX, rt.finY, rt.speed, Proxy.create(char, fnc));
				}

				//increment frame count
				this.frameCnt++;
			}else{
				
				//all characters released
				delete this.onEnterFrame;
				this.removeMovieClip();
			}
		}
	}
	
	/*
	 * Shows the box around each character
	 */
	public function showBox():Void{
		
		this.isShowBox = true;
		
		//box all characters
		for (var i=0; i<txt.length; i++){
			this["char_"+String(i+1)].mask._alpha = 100;
		}
	}
	
	/*
	 * removes and adds boxes whilst waiting
	 * 
	 * @param waitInt the wait interval in frames
	 */
	public function startWait(waitInt:Number):Void{
		
		//if boxes must be shown then don't do anything
		if (isShowBox){
			return;
		}
		
		//redefine wait interval
		if (waitInt < 30){
			waitInt = 30;
		}
		
		//create animator clip
		var animator:MovieClip = this.createEmptyMovieClip("animation_clip", this.getNextHighestDepth());
		animator.frameCnt = 0;
		
		//initiate array of indices to manage the release order if is random
		if (_order == "random"){
			animator.indices = initRandomInds();
		}
		
		//define animation
		animator.onEnterFrame = function() {
					
			var rt:RainingText = this._parent;
			
			//if is time to release another character
			if(this.frameCnt%rt.separation==0){
				
				//define alpha
				var alpha:Number = ((Math.floor(this.frameCnt/rt.separation/rt.txt.length))%2==0) ? 100 : 0;
				
				//get character
				var char:GenericMovieClip;
				var ind:Number;
				switch (rt._order){
					case "reverse":
						ind = rt.txt.length-(this.frameCnt/rt.separation)%rt.txt.length;
						char = rt["char_"+String(ind)];
					break;
					case "random":
						ind = this.indices[(this.frameCnt/rt.separation)%rt.txt.length]+1;
						char = rt["char_"+String(ind)];
					break;
					default:
						ind = (this.frameCnt/rt.separation)%rt.txt.length+1;
						char = rt["char_"+String(ind)];
					break;
				}
				
				//apply alpha to character
				char["mask"]._alpha = alpha;
			}
			
			//increment frame count
			this.frameCnt++;
			
			//if isShowBox is true then stop animation
			if (rt.isShowBox){
				rt.showBox();
				delete this.onEnterFrame;
				this.removeMovieClip();
			}
		}
	}
	
	/*
	 * ends waiting, removes animation clip
	 */
	public function endWait():Void{
		this["animation_clip"].removeMovieClip();
	}
	
	/*
	 * initializes an array of random indicies
	 */
	private function initRandomInds():Array{
		
		var ret:Array = new Array(txt.length);
		for (var i=0; i<txt.length; i++){
			var tmpInd:Number;
			tmpInd = Math.floor(Math.random()*txt.length);
			while (ret[tmpInd] != undefined){
				tmpInd = Math.floor(Math.random()*txt.length);
			}
			ret[tmpInd] = i;
		}
		
		return ret;
	}
}
